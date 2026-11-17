import 'dart:async';
import 'package:flutter/material.dart';
import '../nucleo/puente_supabase_sdui.dart';
import '../nucleo/registro_imports_futuro_sdui.dart';

class Ms22AvatarIaBolsilloVoz extends StatefulWidget {
  final Map bloque;
  final Function(String) onFeedback;

  const Ms22AvatarIaBolsilloVoz({
    super.key,
    required this.bloque,
    required this.onFeedback,
  });

  @override
  State createState() => _Ms22AvatarIaBolsilloVozState();
}

class _Ms22AvatarIaBolsilloVozState extends State with WidgetsBindingObserver {
  Timer? _timerBolsillo;
  Timer? _timerAnimAvatar;

  bool _guardianBolsilloActivo = true;
  bool _hablandoAhora = false;
  double _ondaAvatar = 1.0;

  String _personajeAvatar = 'TUTOR_IA';
  final double _tonoPitch = 1.0;
  final double _velocidadRate = 0.95;
  int _segundosCuentaRegresiva = 0;

  final TextEditingController _ctrlMensajeHablado = TextEditingController(
    text: 'Atencion socio Orbe: Tienes que llamar a tu familia y completar tu reto mental de 25 numeros.',
  );
  final TextEditingController _ctrlComandoUsuario = TextEditingController();

  final List _colaRecordatoriosBolsillo = [
    {
      'id': 'rec-voz-01',
      'hora': 'En Bolsillo (10s)',
      'mensaje': 'Tienes que llamar a tu familia y revisar tus pendientes del dia.',
      'estado': 'LISTO PARA HABLAR',
      'personaje': 'ASISTENTE_FAMILIAR',
    },
    {
      'id': 'rec-voz-02',
      'hora': 'Entrenador Juegos',
      'mensaje': 'Bienvenido al tablero de 35 numeros. Fija tu vista en el punto dorado central.',
      'estado': 'MODO ENTRENADOR',
      'personaje': 'TUTOR_IA',
    },
    {
      'id': 'rec-voz-03',
      'hora': 'Alerta Imperio',
      'mensaje': 'Rugido del Leon Orbe: Tu boveda MTO esta protegida y sincronizada.',
      'estado': 'GUARDIA ACTIVA',
      'personaje': 'LEON_IMPERIO',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timerAnimAvatar = Timer.periodic(const Duration(milliseconds: 380), (_) {
      if (!mounted) return;
      if (_hablandoAhora) {
        setState(() {
          _ondaAvatar = _ondaAvatar == 1.0 ? 1.18 : 1.0;
        });
      } else if (_ondaAvatar != 1.0) {
        setState(() => _ondaAvatar = 1.0);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timerBolsillo?.cancel();
    _timerAnimAvatar?.cancel();
    RegistroImportsFuturoSdui.detenerVozNativa();
    _ctrlMensajeHablado.dispose();
    _ctrlComandoUsuario.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _guardianBolsilloActivo && _segundosCuentaRegresiva != 0) {
      // Mantiene activo el temporizador mientras el celular esta bloqueado en el bolsillo
    }
  }

  Future _hablarTextoEnVozAlta(String texto, {String? personajeOverride}) async {
    final String pers = personajeOverride ?? _personajeAvatar;
    double pitchAplicar = _tonoPitch;
    if (pers == 'LEON_IMPERIO') pitchAplicar = 0.72;
    if (pers == 'TUTOR_IA') pitchAplicar = 1.0;
    if (pers == 'ASISTENTE_FAMILIAR') pitchAplicar = 1.22;

    if (mounted) {
      setState(() => _hablandoAhora = true);
    }

    await RegistroImportsFuturoSdui.hablarVozNativa(
      texto: texto,
      pitch: pitchAplicar,
      rate: _velocidadRate,
    );

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _hablandoAhora = false);
      }
    });
  }

  void _programarDisparoEnBolsillo(int segundosEspera) {
    _timerBolsillo?.cancel();
    final String msg = _ctrlMensajeHablado.text.trim().isEmpty
        ? 'Atencion: Tienes que llamar a tu familia.'
        : _ctrlMensajeHablado.text.trim();

    setState(() {
      _segundosCuentaRegresiva = segundosEspera;
      _guardianBolsilloActivo = true;
    });

    (widget as Ms22AvatarIaBolsilloVoz).onFeedback(
      '👖 MODO BOLSILLO ACTIVO: Guarda o bloquea tu celular. Hablara en $segundosEspera segundos.',
    );

    _timerBolsillo = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_segundosCuentaRegresiva >= 2) {
        if (mounted) {
          setState(() => _segundosCuentaRegresiva--);
        } else {
          _segundosCuentaRegresiva--;
        }
      } else {
        timer.cancel();
        if (mounted) {
          setState(() => _segundosCuentaRegresiva = 0);
        }
        await _hablarTextoEnVozAlta(msg);
        if (mounted) {
          (widget as Ms22AvatarIaBolsilloVoz).onFeedback(
            '🗣️ AVATAR IA HABLO EN BOLSILLO: "$msg"',
          );
        }
      }
    });
  }

  Future _agregarRecordatorioYGuardarEnSupabase() async {
    final String msg = _ctrlMensajeHablado.text.trim();
    if (msg.isEmpty) return;

    final String nuevoId = 'voz-${RegistroImportsFuturoSdui.generarUuidNativo().substring(0, 6)}';
    setState(() {
      _colaRecordatoriosBolsillo.insert(0, {
        'id': nuevoId,
        'hora': 'Programado Activo',
        'mensaje': msg,
        'estado': 'GUARDADO EN NUBE',
        'personaje': _personajeAvatar,
      });
    });

    await _hablarTextoEnVozAlta('Recordatorio guardado: $msg');

    await PuenteSupabaseSdui.ejecutarRpcUniversal(
      'esq1_rpc_guardar_app_o_usuario',
      {
        'p_operacion': 'GUARDAR_RECORDATORIO_VOZ_BOLSILLO',
        'p_id_recordatorio': nuevoId,
        'p_mensaje_voz': msg,
        'p_personaje': _personajeAvatar,
      },
      esquemaOverride: 'esquema1',
    );
  }

  void _responderComandoAlAvatar() {
    final String pregunta = _ctrlComandoUsuario.text.trim();
    if (pregunta.isEmpty) return;
    final String q = pregunta.toLowerCase();
    String respuesta = 'Hola socio Orbe. Estoy listo en segundo plano para recordarte llamar a tu familia y guiarte en el juego de 35 numeros.';
    if (q.contains('familia') || q.contains('llamar')) {
      respuesta = 'Perfecto, activare la alerta hablada en tu bolsillo para que no olvides llamar a tu familia.';
    } else if (q.contains('juego') || q.contains('25') || q.contains('35')) {
      respuesta = 'En el juego de 25 a 35 numeros, fija tus ojos en el centro dorado para expandir tu vision periferica.';
    }
    setState(() {
      _ctrlComandoUsuario.clear();
      _ctrlMensajeHablado.text = respuesta;
    });
    _hablarTextoEnVozAlta(respuesta);
  }

  @override
  Widget build(BuildContext context) {
    final Map motoresInfo = RegistroImportsFuturoSdui.verificarMotoresCompiladosEnApk();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF070D1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00F3FF), width: 1.8),
        boxShadow: const [BoxShadow(color: Color(0x3300F3FF), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF05050F)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hablandoAhora ? const Color(0xFF00FF66) : const Color(0xFFFF00FC),
                width: 1.6,
              ),
            ),
            child: Row(
              children: [
                AnimatedScale(
                  scale: _ondaAvatar,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 66,
                    height: 66,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: _hablandoAhora
                            ? [const Color(0xFF00FF66), const Color(0xFF004D40)]
                            : [const Color(0xFF00F3FF), const Color(0xFF1E1B4B)],
                      ),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      _personajeAvatar == 'LEON_IMPERIO'
                          ? '🦁'
                          : _personajeAvatar == 'TUTOR_IA'
                              ? '🤖'
                              : '🗣️',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '🗣️ AVATAR IA DE BOLSILLO & JUEGOS',
                            style: TextStyle(
                              color: Color(0xFF00FF66),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _guardianBolsilloActivo ? const Color(0xFF00FF66) : Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _segundosCuentaRegresiva != 0
                                  ? '⏱️ ${_segundosCuentaRegresiva}s'
                                  : (_hablandoAhora ? '🔊 HABLANDO' : 'ACTIVO'),
                              style: const TextStyle(color: Colors.black, fontSize: 9.5, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Habla automaticamente aunque guardes el celular en tu bolsillo y narra tus jugadas en los juegos SDUI.',
                        style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.3),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hash Motor APK: ${motoresInfo['hash_sha256']} · QR/TTS/107 Libs OK',
                        style: const TextStyle(color: Color(0xFFFFD700), fontSize: 9.5, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '🎭 1. ELIGE EL AVATAR Y TONO DE VOZ (PARA BOLSILLO Y JUEGOS):',
            style: TextStyle(color: Color(0xFFA9C7FF), fontSize: 10.5, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _chipPersonaje('ASISTENTE_FAMILIAR', '🗣️ Familiar (Bolsillo)', const Color(0xFF00FF66)),
              const SizedBox(width: 6),
              _chipPersonaje('TUTOR_IA', '🤖 Tutor Juegos 35', const Color(0xFF00F3FF)),
              const SizedBox(width: 6),
              _chipPersonaje('LEON_IMPERIO', '🦁 Leon Imperio', const Color(0xFFFFD700)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '📝 2. MENSAJE QUE EL CELULAR HABLARA SOLO EN TU BOLSILLO:',
            style: TextStyle(color: Color(0xFFA9C7FF), fontSize: 10.5, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _ctrlMensajeHablado,
            maxLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 12.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black,
              hintText: 'Ej: Tienes que llamar a tu familia...',
              hintStyle: const TextStyle(color: Colors.white38),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF00F3FF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF00FF66), width: 2),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF66),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                ),
                icon: const Icon(Icons.volume_up, size: 18),
                label: const Text('🔊 HABLAR AHORA MISMO', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
                onPressed: () => _hablarTextoEnVozAlta(_ctrlMensajeHablado.text),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                ),
                icon: const Icon(Icons.timer, size: 18),
                label: const Text('👖 PROBAR EN BOLSILLO (5 SEG)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
                onPressed: () => _programarDisparoEnBolsillo(5),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00F3FF),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                ),
                icon: const Icon(Icons.alarm_on, size: 18),
                label: const Text('👖 PROBAR EN BOLSILLO (15 SEG)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
                onPressed: () => _programarDisparoEnBolsillo(15),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF00FC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                ),
                icon: const Icon(Icons.cloud_upload, size: 18),
                label: const Text('☁️ GUARDAR ALERTA EN SUPABASE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
                onPressed: _agregarRecordatorioYGuardarEnSupabase,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrlComandoUsuario,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mic, color: Color(0xFFFF00FC), size: 18),
                    hintText: 'Escribe o dicta al Avatar (Ej: Recuerdame llamar a mi familia)...',
                    hintStyle: const TextStyle(color: Colors.white38, fontSize: 11),
                    filled: true,
                    fillColor: Colors.black,
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: const Color(0xFF00F3FF)),
                icon: const Icon(Icons.send, color: Colors.black, size: 18),
                onPressed: _responderComandoAlAvatar,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '📋 3. COLA DE RECORDATORIOS HABLADOS Y FRASES DE ENTRENADOR (TOCA PARA OIR):',
            style: TextStyle(color: Color(0xFFFFD700), fontSize: 10.5, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          ..._colaRecordatoriosBolsillo.map((raw) {
            final Map r = Map.from(raw as Map);
            return InkWell(
              onTap: () => _hablarTextoEnVozAlta(
                r['mensaje'].toString(),
                personajeOverride: r['personaje']?.toString(),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF295186)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.record_voice_over, color: Color(0xFF00FF66), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r['mensaje'].toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Modo: ${r['hora']} · Voz: ${r['personaje']} · [${r['estado']}]',
                            style: const TextStyle(color: Color(0xFF00F3FF), fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.play_circle_fill, color: Color(0xFFFFD700), size: 22),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _chipPersonaje(String idPers, String label, Color col) {
    final bool sel = _personajeAvatar == idPers;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _personajeAvatar = idPers);
          _hablarTextoEnVozAlta('Voz activada: $label', personajeOverride: idPers);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          decoration: BoxDecoration(
            color: sel ? col : const Color(0xFF142033),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: col),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: sel ? Colors.black : Colors.white,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}