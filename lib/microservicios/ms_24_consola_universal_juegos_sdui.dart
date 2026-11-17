import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import '../nucleo/puente_supabase_sdui.dart';
import '../nucleo/registro_imports_futuro_sdui.dart';

class Ms24ConsolaUniversalJuegosSdui extends StatefulWidget {
  final Map bloque;
  final Function(String) onFeedback;

  const Ms24ConsolaUniversalJuegosSdui({
    super.key,
    required this.bloque,
    required this.onFeedback,
  });

  @override
  State createState() => _Ms24ConsolaUniversalJuegosSduiState();
}

class _Ms24ConsolaUniversalJuegosSduiState extends State {
  final math.Random _rng = math.Random();
  late final ConfettiController _confettiCtrl;
  Timer? _timerJuego;

  String _juegoActivo = 'VEDIC_MATH_IA';
  bool _vozActiva = true;
  String _fraseAvatar = 'Listo para entrenar tus 8 inteligencias con voz y records en vivo.';
  int _puntosTotales = 1850;
  int _recordsBatidos = 4;
  int _tiempoMs = 0;
  bool _relojActivo = false;

  int _cantNums = 25;
  String _modoSchulte = 'PRESIONAR';
  List _tableroNums = [];
  int _objSchulte = 1;
  bool _ocultoChimp = false;

  String _nivelMat = 'DIFICIL_VEDICO';
  String _enunciadoMat = '14 × 16 = ?';
  String _trucoMat = 'Truco Vedico: (14+6)×10 + (4×6) = 200 + 24 = 224';
  int _respCorrectaMat = 224;
  List _opcionesMat = [224, 214, 234, 196];
  int _rachaMat = 0;
  int _vidasMat = 3;

  int _tamMatriz = 3;
  Set _patronObjetivo = {0, 4, 8};
  final Set _patronUsuario = {};
  bool _mostrandoPatron = false;

  String _objRain = 'M-7 (NATURALISTA 🌿)';
  List _itemsRain = ['M-7 (NATURALISTA 🌿)', 'A-2 (LOGICA 🧮)', 'K-9 (MUSICAL 🎵)', 'Z-4 (ESPACIAL 📐)', 'P-5 (EMPATIA 🤝)', 'R-8 (VERBAL 📖)'];
  int _comboRain = 0;

  int _idxRetoGardner = 0;
  static const List _retosGardner = [
    {
      'intel': '1. Inteligencia Musical y Tono Vocal 🎵',
      'preg': 'Si un Leon ruge a 110 Hz (Grave) y un Pajaro canta a 880 Hz (Agudo), ¿cual tiene mayor frecuencia?',
      'ops': ['🐦 Pajaro (880 Hz - Correcta)', '🦁 Leon (110 Hz)', '🥁 Tambor (60 Hz)', '🎸 Bajo (80 Hz)'],
      'ok': 0
    },
    {
      'intel': '2. Inteligencia Interpersonal y Empatia 🤝',
      'preg': 'Un compañero pierde su racha en la Olimpiada Escolar. ¿Que accion fortalece al equipo?',
      'ops': ['🤝 Explicarle el truco vedico y animarlo (Correcta)', 'Ignorarlo', 'Burlarse del tiempo', 'Cerrar la sala'],
      'ok': 0
    },
    {
      'intel': '3. Inteligencia Naturalista y Clasificacion 🌿',
      'preg': '¿Cual de estos elementos pertenece a energia limpia renovable para una ciudad inteligente?',
      'ops': ['☀️ Panel Solar + Hidrogeno Verde (Correcta)', 'Carbon mineral', 'Diesel pesado', 'Plomo'],
      'ok': 0
    },
    {
      'intel': '4. Inteligencia Intrapersonal y Bio-Termometro 💖',
      'preg': 'Antes de un examen cronometrado de 35 numeros, ¿que tecnica reduce el tiempo de duda?',
      'ops': ['🧘 Respiracion 4-4 y fijar vista al centro (Correcta)', 'Mirar al azar', 'Apretar botones sin leer', 'Subir estres'],
      'ok': 0
    },
  ];

  @override
  void initState() {
    super.initState();
    _confettiCtrl = ConfettiController(duration: const Duration(seconds: 2));
    final Map b = (widget as Ms24ConsolaUniversalJuegosSdui).bloque;
    if (b['motor_inicial'] != null) _juegoActivo = b['motor_inicial'].toString();
    if (b['cantidad_numeros_inicial'] is num) _cantNums = (b['cantidad_numeros_inicial'] as num).toInt();
    if (b['nivel_matematicas_inicial'] != null) _nivelMat = b['nivel_matematicas_inicial'].toString();
    if (b['saludo_avatar'] != null) _fraseAvatar = b['saludo_avatar'].toString();
    _prepararSchulte(iniciar: false);
    _generarPreguntaMatematicas(hablar: false);
    _generarPatronMatriz();
  }

  @override
  void dispose() {
    _timerJuego?.cancel();
    _confettiCtrl.dispose();
    super.dispose();
  }

  Future _hablar(String txt) async {
    if (!mounted) return;
    setState(() => _fraseAvatar = txt);
    if (!_vozActiva) return;
    await RegistroImportsFuturoSdui.hablarVozNativa(texto: txt);
  }

  void _iniciarReloj() {
    _timerJuego?.cancel();
    _tiempoMs = 0;
    _relojActivo = true;
    _timerJuego = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted && _relojActivo) setState(() => _tiempoMs += 100);
    });
  }

  Future _guardarRecordSupabase(String detalle) async {
    _relojActivo = false;
    _timerJuego?.cancel();
    _confettiCtrl.play();
    setState(() => _recordsBatidos++);
    await _hablar(detalle);
    (widget as Ms24ConsolaUniversalJuegosSdui).onFeedback('🏆 $detalle');
    await PuenteSupabaseSdui.ejecutarRpcUniversal(
      'esq1_rpc_guardar_app_o_usuario',
      {
        'p_operacion': 'GUARDAR_AVANCE_CEREBRAL_35',
        'p_nivel': '$_juegoActivo ($_nivelMat / $_cantNums)',
        'p_modo_juego': _modoSchulte,
        'p_tiempo_ms': _tiempoMs,
        'p_puntos': _puntosTotales,
      },
      esquemaOverride: 'esquema1',
    );
  }

  void _prepararSchulte({required bool iniciar}) {
    final List l = List.generate(_cantNums, (i) => i + 1)..shuffle(_rng);
    setState(() {
      _tableroNums = l;
      _objSchulte = 1;
      _ocultoChimp = false;
      _relojActivo = iniciar;
    });
    if (iniciar) {
      _iniciarReloj();
      _hablar('Tablero de $_cantNums numeros iniciado. Busca el 1.');
    }
  }

  void _tocarCeldaSchulte(int val) {
    if (_modoSchulte == 'SOLO_MENTAL') {
      if (!_relojActivo) _prepararSchulte(iniciar: true);
      return;
    }
    if (!_relojActivo && val == 1) {
      _iniciarReloj();
      setState(() {
        _objSchulte = 2;
        if (_modoSchulte == 'CHIMP') _ocultoChimp = true;
      });
      return;
    }
    if (!_relojActivo) return;
    if (val == _objSchulte) {
      HapticFeedback.selectionClick();
      setState(() {
        if (_objSchulte == 1 && _modoSchulte == 'CHIMP') _ocultoChimp = true;
        _objSchulte++;
        _puntosTotales += 25;
      });
      if (_objSchulte > _cantNums) {
        _guardarRecordSupabase('Completaste $_cantNums numeros en ${(_tiempoMs / 1000).toStringAsFixed(1)} segundos.');
      }
    } else {
      HapticFeedback.heavyImpact();
      _hablar('Busca el numero $_objSchulte');
    }
  }

  void _generarPreguntaMatematicas({bool hablar = true}) {
    int ok = 0;
    String enun = '';
    String truco = '';
    if (_nivelMat == 'BASICO') {
      final int a = 15 + _rng.nextInt(45);
      final int b = 12 + _rng.nextInt(35);
      ok = a + b;
      enun = '$a + $b = ?';
      truco = 'Suma por decenas: (${a ~/ 10 * 10}+${b ~/ 10 * 10}) + (${a % 10}+${b % 10}) = $ok';
    } else if (_nivelMat == 'MEDIO') {
      final int a = 6 + _rng.nextInt(9);
      final int b = 7 + _rng.nextInt(9);
      ok = a * b;
      enun = '$a × $b = ?';
      truco = 'Multiplicacion rapida: $a por $b es igual a $ok';
    } else if (_nivelMat == 'DIFICIL_VEDICO') {
      final int a = 11 + _rng.nextInt(9);
      final int b = 11 + _rng.nextInt(9);
      ok = a * b;
      enun = '$a × $b = ?';
      truco = 'Metodo Vedico Base 10: ($a + ${b - 10})×10 + (${a - 10}×${b - 10}) = $ok';
    } else {
      final int xVal = 3 + _rng.nextInt(12);
      final int m = 2 + _rng.nextInt(5);
      final int suma = 5 + _rng.nextInt(15);
      final int total = m * xVal + suma;
      ok = xVal;
      enun = '${m}x + $suma = $total   ➔   x = ?';
      truco = 'Despeje Algebraico: x = ($total - $suma) / $m = $ok';
    }
    final List ops = [ok, ok + 2, math.max(1, ok - 3), ok + 10]..shuffle(_rng);
    setState(() {
      _enunciadoMat = enun;
      _trucoMat = truco;
      _respCorrectaMat = ok;
      _opcionesMat = ops;
    });
    if (!_relojActivo) _iniciarReloj();
    if (hablar) _hablar('Resuelve: $enun');
  }

  void _responderMatematicas(int elegido) {
    if (elegido == _respCorrectaMat) {
      HapticFeedback.mediumImpact();
      setState(() {
        _rachaMat++;
        _puntosTotales += 80 + (_rachaMat * 10);
      });
      if (_rachaMat % 3 == 0) {
        _guardarRecordSupabase('Racha matematica de $_rachaMat aciertos seguidos.');
      } else {
        _hablar('Correcto, es $_respCorrectaMat.');
      }
      _generarPreguntaMatematicas(hablar: false);
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _rachaMat = 0;
        _vidasMat = math.max(1, _vidasMat - 1);
      });
      _hablar('Respuesta incorrecta. Observa el truco vedico en pantalla.');
    }
  }

  void _generarPatronMatriz() {
    final int totalCeldas = _tamMatriz * _tamMatriz;
    final Set nuevo = {};
    while (nuevo.length < _tamMatriz + 1) {
      nuevo.add(_rng.nextInt(totalCeldas));
    }
    setState(() {
      _patronObjetivo = nuevo;
      _patronUsuario.clear();
      _mostrandoPatron = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _mostrandoPatron = false);
    });
  }

  void _tocarCeldaMatriz(int idx) {
    if (_mostrandoPatron) return;
    HapticFeedback.selectionClick();
    setState(() {
      if (_patronUsuario.contains(idx)) {
        _patronUsuario.remove(idx);
      } else {
        _patronUsuario.add(idx);
      }
    });
    if (_patronUsuario.length == _patronObjetivo.length) {
      if (_patronUsuario.containsAll(_patronObjetivo)) {
        setState(() => _puntosTotales += 120);
        _guardarRecordSupabase('Memoria espacial ${_tamMatriz}x$_tamMatriz superada.');
        _generarPatronMatriz();
      } else {
        _hablar('Patron incompleto, intenta de nuevo.');
        _generarPatronMatriz();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF060B19),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00FF66), width: 1.8),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF142033),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF00F3FF)),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _hablar(_fraseAvatar),
                      child: const CircleAvatar(backgroundColor: Color(0xFF00FF66), child: Text('🤖', style: TextStyle(fontSize: 20))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('⭐ $_puntosTotales PTS · 🏆 Records: $_recordsBatidos · ⏱️ ${(_tiempoMs / 1000).toStringAsFixed(1)}s',
                              style: const TextStyle(color: Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.w900)),
                          Text('🗣️ "$_fraseAvatar"', style: const TextStyle(color: Colors.white, fontSize: 10.5)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(_vozActiva ? Icons.volume_up : Icons.volume_off, color: const Color(0xFF00FF66)),
                      onPressed: () {
                        setState(() => _vozActiva = true);
                        _hablar(_fraseAvatar);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _chipJuego('SCHULTE_PRO_50', '🔢 1. Numeros (16-50)', const Color(0xFF00FF66)),
                    _chipJuego('VEDIC_MATH_IA', '🧮 2. Matematicas Pro', const Color(0xFF00F3FF)),
                    _chipJuego('GRID_DIGIT_MEM', '🧠 3. Matriz Memoria', const Color(0xFFFFD700)),
                    _chipJuego('ALPHA_RAIN_2D', '🌧️ 4. Lluvia & Clasif.', const Color(0xFFFF00FC)),
                    _chipJuego('GARDNER_8_VOZ', '🎓 5. 8 Inteligencias', const Color(0xFF00FF66)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (_juegoActivo == 'SCHULTE_PRO_50') ...[
                Wrap(
                  spacing: 6,
                  children: [16, 25, 30, 35, 50].map((n) => ChoiceChip(
                    label: Text('$n Nums', style: TextStyle(color: _cantNums == n ? Colors.black : Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    selected: _cantNums == n,
                    selectedColor: const Color(0xFF00FF66),
                    onSelected: (_) {
                      setState(() => _cantNums = n);
                      _prepararSchulte(iniciar: false);
                    },
                  )).toList(),
                ),
                const SizedBox(height: 6),
                Row(
                  children: ['PRESIONAR', 'SOLO_MENTAL', 'CHIMP'].map((m) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(backgroundColor: _modoSchulte == m ? const Color(0xFF00F3FF) : Colors.black),
                        onPressed: () {
                          setState(() => _modoSchulte = m);
                          _prepararSchulte(iniciar: false);
                        },
                        child: Text(m, style: TextStyle(color: _modoSchulte == m ? Colors.black : Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _cantNums == 16 ? 4 : 5,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: _cantNums >= 35 ? 1.3 : 1.05,
                  ),
                  itemCount: _tableroNums.length,
                  itemBuilder: (ctx, i) {
                    final int v = (_tableroNums[i] as num).toInt();
                    final bool ok = _modoSchulte != 'SOLO_MENTAL' && v < _objSchulte;
                    return InkWell(
                      onTap: () => _tocarCeldaSchulte(v),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ok ? const Color(0xFF052E16) : const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ok ? const Color(0xFF00FF66) : const Color(0xFF00F3FF)),
                        ),
                        child: Text(_ocultoChimp && !ok ? '?' : '$v',
                            style: TextStyle(color: ok ? Colors.white38 : Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF66), foregroundColor: Colors.black),
                  onPressed: () => _modoSchulte == 'SOLO_MENTAL' && _relojActivo
                      ? _guardarRecordSupabase('Escaneo mental de $_cantNums numeros completado.')
                      : _prepararSchulte(iniciar: true),
                  child: Text(_modoSchulte == 'SOLO_MENTAL' && _relojActivo ? '⏹️ TERMINE RECORRIDO MENTAL' : '▶️ INICIAR PARTIDA ($_cantNums NUMS)',
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                ),
              ],
              if (_juegoActivo == 'VEDIC_MATH_IA') ...[
                Wrap(
                  spacing: 6,
                  children: [
                    {'id': 'BASICO', 't': '🟢 Basico (+ -)'},
                    {'id': 'MEDIO', 't': '🔵 Medio (×)'},
                    {'id': 'DIFICIL_VEDICO', 't': '🟠 Dificil Vedico'},
                    {'id': 'GENIO_ALGEBRA', 't': '👑 Genio Ecuacion x'},
                  ].map((nv) => ChoiceChip(
                    label: Text(nv['t']!, style: TextStyle(color: _nivelMat == nv['id'] ? Colors.black : Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    selected: _nivelMat == nv['id'],
                    selectedColor: const Color(0xFF00F3FF),
                    onSelected: (_) {
                      setState(() => _nivelMat = nv['id']!);
                      _generarPreguntaMatematicas(hablar: true);
                    },
                  )).toList(),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF00F3FF))),
                  child: Column(
                    children: [
                      Text('🔥 Racha: $_rachaMat  |  ❤️ Vidas: $_vidasMat', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 11.5, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(_enunciadoMat, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text('💡 $_trucoMat', textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF00FF66), fontSize: 11)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _opcionesMat.map((op) {
                          final int val = (op as num).toInt();
                          return SizedBox(
                            width: 130,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B), foregroundColor: const Color(0xFF00FF66)),
                              onPressed: () => _responderMatematicas(val),
                              child: Text('$val', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                            ),
                          );
                        }).toList(),
                      ),
                      TextButton.icon(
                        onPressed: () => _hablar('Cuanto es $_enunciadoMat. $_trucoMat'),
                        icon: const Icon(Icons.volume_up, color: Color(0xFFFFD700)),
                        label: const Text('ESCUCHAR OPERACION Y TRUCO CON VOZ', style: TextStyle(color: Color(0xFFFFD700), fontSize: 10.5, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
              if (_juegoActivo == 'GRID_DIGIT_MEM') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [3, 4, 5].map((t) => ChoiceChip(
                    label: Text('Matriz ${t}x$t', style: TextStyle(color: _tamMatriz == t ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                    selected: _tamMatriz == t,
                    selectedColor: const Color(0xFFFFD700),
                    onSelected: (_) {
                      setState(() => _tamMatriz = t);
                      _generarPatronMatriz();
                    },
                  )).toList(),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _tamMatriz, crossAxisSpacing: 6, mainAxisSpacing: 6, childAspectRatio: 1.3),
                  itemCount: _tamMatriz * _tamMatriz,
                  itemBuilder: (ctx, idx) {
                    final bool iluminada = (_mostrandoPatron && _patronObjetivo.contains(idx)) || (!_mostrandoPatron && _patronUsuario.contains(idx));
                    return InkWell(
                      onTap: () => _tocarCeldaMatriz(idx),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: iluminada ? const Color(0xFF00FF66) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFFD700)),
                        ),
                        child: Text(iluminada ? '⚡' : '${idx + 1}', style: TextStyle(color: iluminada ? Colors.black : Colors.white70, fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
                  onPressed: _generarPatronMatriz,
                  child: const Text('🔄 VER NUEVO PATRON DE MEMORIA', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ],
              if (_juegoActivo == 'ALPHA_RAIN_2D') ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFF00FC))),
                  child: Column(
                    children: [
                      Text('🎯 ATRAPA: $_objRain  |  🔥 Combo: x$_comboRain', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 12.5, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _itemsRain.map((it) => ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E1B4B), foregroundColor: Colors.white),
                          onPressed: () {
                            if (it == _objRain) {
                              final List copia = List.from(_itemsRain)..shuffle(_rng);
                              setState(() {
                                _comboRain++;
                                _puntosTotales += 50;
                                _itemsRain = copia;
                                _objRain = copia.first.toString();
                              });
                              if (_comboRain % 4 == 0) _guardarRecordSupabase('Combo clasificador por $_comboRain.');
                            } else {
                              setState(() => _comboRain = 0);
                              _hablar('Busca $_objRain');
                            }
                          },
                          child: Text(it.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ],
              if (_juegoActivo == 'GARDNER_8_VOZ') ...[
                Builder(builder: (ctx) {
                  final Map reto = Map.from(_retosGardner[_idxRetoGardner % _retosGardner.length] as Map);
                  final List ops = reto['ops'] as List;
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF00FF66))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(reto['intel'].toString(), style: const TextStyle(color: Color(0xFFFFD700), fontSize: 12, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 6),
                        Text(reto['preg'].toString(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        ...List.generate(ops.length, (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B), foregroundColor: Colors.white),
                            onPressed: () {
                              if (i == reto['ok']) {
                                setState(() {
                                  _puntosTotales += 100;
                                  _idxRetoGardner++;
                                });
                                _guardarRecordSupabase('Reto de las 8 inteligencias superado.');
                              } else {
                                _hablar('Intenta con otra respuesta.');
                              }
                            },
                            child: Text(ops[i].toString(), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                          ),
                        )),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
          ConfettiWidget(confettiController: _confettiCtrl, blastDirectionality: BlastDirectionality.explosive, shouldLoop: false),
        ],
      ),
    );
  }

  Widget _chipJuego(String id, String lbl, Color col) {
    final bool sel = _juegoActivo == id;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(lbl, style: TextStyle(color: sel ? Colors.black : Colors.white, fontSize: 10.5, fontWeight: FontWeight.w900)),
        selected: sel,
        selectedColor: col,
        backgroundColor: const Color(0xFF142033),
        onSelected: (_) {
          HapticFeedback.selectionClick();
          setState(() => _juegoActivo = id);
          _hablar('Juego activado: $lbl');
        },
      ),
    );
  }
}