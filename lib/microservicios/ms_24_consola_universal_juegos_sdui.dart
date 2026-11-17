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

  String _juegoActivo = 'SCHULTE_PRO_50';
  bool _vozAvatarActiva = true;
  String _mensajeAvatarActual = 'Hola campeon Orbe. Elige un juego o modifica sus reglas desde JSON en Supabase.';

  int _cantNumeros = 25;
  String _modoSchulte = 'PRESIONAR';
  List _tableroSchulte = [];
  int _objetivoSchulte = 1;
  bool _ocultoChimp = false;
  int _tiempoMs = 0;
  bool _corriendoReloj = false;

  int _numA = 14;
  int _numB = 16;
  String _operadorVedico = '×';
  int _respuestaCorrectaVedica = 224;
  List _opcionesVedicas = [224, 214, 234, 196];
  int _aciertosVedicos = 0;

  String _objetivoRain = 'A-7';
  List _burbujasRain = ['A-7', 'B-9', 'K-4', 'M-2', 'X-5', 'Z-1', 'P-8', 'R-3'];
  int _comboRain = 0;

  String _secuenciaDigitSpan = '74928';
  bool _mostrandoSecuencia = true;
  final TextEditingController _ctrlRespuestaSpan = TextEditingController();
  int _nivelSpan = 5;

  int _puntosConsola = 1850;
  int _recordsBatidos = 4;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = ConfettiController(duration: const Duration(seconds: 2));
    _configurarDesdeJsonSupabase();
    _prepararTableroSchulte(iniciar: false);
    _generarRetoVedico();
  }

  void _configurarDesdeJsonSupabase() {
    final Map b = (widget as Ms24ConsolaUniversalJuegosSdui).bloque;
    if (b['motor_inicial'] != null) {
      _juegoActivo = b['motor_inicial'].toString();
    }
    if (b['cantidad_numeros_inicial'] is num) {
      _cantNumeros = (b['cantidad_numeros_inicial'] as num).toInt();
    }
    if (b['saludo_avatar'] != null) {
      _mensajeAvatarActual = b['saludo_avatar'].toString();
    }
  }

  Future _avatarHablar(String frase) async {
    if (!mounted) return;
    setState(() => _mensajeAvatarActual = frase);
    if (!_vozAvatarActiva) return;
    await RegistroImportsFuturoSdui.hablarVozNativa(texto: frase, pitch: 1.05, rate: 0.96);
  }

  @override
  void dispose() {
    _timerJuego?.cancel();
    _confettiCtrl.dispose();
    RegistroImportsFuturoSdui.detenerVozNativa();
    _ctrlRespuestaSpan.dispose();
    super.dispose();
  }

  void _prepararTableroSchulte({required bool iniciar}) {
    _timerJuego?.cancel();
    final List nums = List.generate(_cantNumeros, (i) => i + 1)..shuffle(_rng);
    setState(() {
      _tableroSchulte = nums;
      _objetivoSchulte = 1;
      _ocultoChimp = false;
      _tiempoMs = 0;
      _corriendoReloj = iniciar;
    });
    if (iniciar) {
      _arrancarReloj();
      _avatarHablar(
        _modoSchulte == 'SOLO_MENTAL'
            ? 'Modo solo mental de $_cantNumeros numeros. Busca con tus ojos del 1 al $_cantNumeros.'
            : 'Tablero de $_cantNumeros numeros activado. Busca el numero 1.',
      );
    }
  }

  void _arrancarReloj() {
    _timerJuego?.cancel();
    _timerJuego = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted || !_corriendoReloj) return;
      setState(() => _tiempoMs += 100);
    });
  }

  void _tocarNumeroSchulte(int n) {
    if (_modoSchulte == 'SOLO_MENTAL') {
      if (!_corriendoReloj) {
        _prepararTableroSchulte(iniciar: true);
      }
      return;
    }

    if (!_corriendoReloj && n == 1) {
      _arrancarReloj();
      setState(() {
        _corriendoReloj = true;
        _objetivoSchulte = 2;
        if (_modoSchulte == 'CHIMP') _ocultoChimp = true;
      });
      HapticFeedback.lightImpact();
      return;
    }

    if (!_corriendoReloj) return;

    if (n == _objetivoSchulte) {
      HapticFeedback.selectionClick();
      setState(() {
        if (_objetivoSchulte == 1 && _modoSchulte == 'CHIMP') {
          _ocultoChimp = true;
        }
        _objetivoSchulte++;
        _puntosConsola += 25;
      });

      if (_objetivoSchulte == (_cantNumeros ~/ 2)) {
        _avatarHablar('Vas por la mitad, excelente ritmo.');
      }

      if (_objetivoSchulte > _cantNumeros) {
        _celebrarVictoria('Tablero de $_cantNumeros numeros completado en ${(_tiempoMs / 1000).toStringAsFixed(1)} segundos.');
      }
    } else {
      HapticFeedback.heavyImpact();
      _avatarHablar('Busca el numero $_objetivoSchulte.');
    }
  }

  void _generarRetoVedico() {
    final int a = 11 + _rng.nextInt(19);
    final int b = 11 + _rng.nextInt(19);
    final int ok = a * b;
    final List ops = [ok, ok + 10, ok - 10, ok + 4]..shuffle(_rng);
    setState(() {
      _numA = a;
      _numB = b;
      _operadorVedico = '×';
      _respuestaCorrectaVedica = ok;
      _opcionesVedicas = ops;
    });
  }

  void _responderVedico(int valorElegido) {
    if (valorElegido == _respuestaCorrectaVedica) {
      HapticFeedback.mediumImpact();
      setState(() {
        _aciertosVedicos++;
        _puntosConsola += 80;
      });
      if (_aciertosVedicos % 3 == 0) {
        _confettiCtrl.play();
        _avatarHablar('Racha vedica perfecta de $_aciertosVedicos aciertos.');
      }
      _generarRetoVedico();
    } else {
      HapticFeedback.heavyImpact();
      _avatarHablar('Casi. $_numA por $_numB es $_respuestaCorrectaVedica.');
    }
  }

  void _tocarBurbujaRain(String codigo) {
    if (codigo == _objetivoRain) {
      HapticFeedback.lightImpact();
      final List nuevas = List.from(_burbujasRain)..shuffle(_rng);
      final String nuevoObj = nuevas[_rng.nextInt(nuevas.length)].toString();
      setState(() {
        _comboRain++;
        _puntosConsola += 40;
        _burbujasRain = nuevas;
        _objetivoRain = nuevoObj;
      });
      if (_comboRain % 5 == 0) {
        _confettiCtrl.play();
        _avatarHablar('Combo de reflejos por $_comboRain. Ahora atrapa $nuevoObj.');
      }
    } else {
      HapticFeedback.heavyImpact();
      setState(() => _comboRain = 0);
      _avatarHablar('Objetivo incorrecto, busca $_objetivoRain.');
    }
  }

  void _generarSecuenciaDigitSpan() {
    String s = '';
    for (int i = 0; i < _nivelSpan; i++) {
      s += '${1 + _rng.nextInt(9)}';
    }
    setState(() {
      _secuenciaDigitSpan = s;
      _mostrandoSecuencia = true;
      _ctrlRespuestaSpan.clear();
    });
    _avatarHablar('Memoriza estos $_nivelSpan digitos.');
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _mostrandoSecuencia = false);
      }
    });
  }

  void _verificarDigitSpan() {
    if (_ctrlRespuestaSpan.text.trim() == _secuenciaDigitSpan) {
      setState(() {
        _nivelSpan++;
        _puntosConsola += 150;
      });
      _celebrarVictoria('Memoria exacta. Subes a $_nivelSpan digitos.');
      _generarSecuenciaDigitSpan();
    } else {
      HapticFeedback.heavyImpact();
      _avatarHablar('La secuencia era $_secuenciaDigitSpan. Intentemos otra vez.');
      _generarSecuenciaDigitSpan();
    }
  }

  Future _celebrarVictoria(String detalle) async {
    _timerJuego?.cancel();
    _confettiCtrl.play();
    setState(() {
      _corriendoReloj = false;
      _ocultoChimp = false;
      _recordsBatidos++;
    });
    await _avatarHablar('Felicidades. $detalle');
    (widget as Ms24ConsolaUniversalJuegosSdui).onFeedback('🏆 $detalle');

    await PuenteSupabaseSdui.ejecutarRpcUniversal(
      'esq1_rpc_guardar_app_o_usuario',
      {
        'p_operacion': 'GUARDAR_AVANCE_CEREBRAL_35',
        'p_nivel': '$_juegoActivo ($_cantNumeros)',
        'p_modo_juego': _modoSchulte,
        'p_tiempo_ms': _tiempoMs,
        'p_puntos': _puntosConsola,
      },
      esquemaOverride: 'esquema1',
    );
  }

  @override
  Widget build(BuildContext context) {
    final List nivelesJson = ((widget as Ms24ConsolaUniversalJuegosSdui).bloque['niveles_numeros'] as List?) ??
        [16, 25, 30, 35, 50];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF060B19),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF00FC), width: 1.8),
        boxShadow: const [BoxShadow(color: Color(0x33FF00FC), blurRadius: 16)],
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E1B4B), Color(0xFF0A0A1C)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF00F3FF)),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _avatarHablar(_mensajeAvatarActual),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00F3FF).withAlpha(40),
                          border: Border.all(color: const Color(0xFF00FF66), width: 2),
                        ),
                        child: const Text('🤖', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '🎮 CONSOLA SDUI + AVATAR IA PARLANTE',
                                style: TextStyle(color: Color(0xFF00FF66), fontSize: 11.5, fontWeight: FontWeight.w900),
                              ),
                              Text(
                                '⭐ $_puntosConsola Pts · 🏆 $_recordsBatidos',
                                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 10.5, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '🗣️ "$_mensajeAvatarActual"',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _vozAvatarActiva = !_vozAvatarActiva),
                      icon: Icon(
                        _vozAvatarActiva ? Icons.volume_up : Icons.volume_off,
                        color: _vozAvatarActiva ? const Color(0xFF00FF66) : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _chipMotorJuego('SCHULTE_PRO_50', '🔢 1. Numeros (16 a 50)', const Color(0xFF00FF66)),
                    _chipMotorJuego('VEDIC_MATH_IA', '🧮 2. Calculo Vedico IA', const Color(0xFF00F3FF)),
                    _chipMotorJuego('ALPHA_RAIN_2D', '🌧️ 3. Lluvia Alfanumerica', const Color(0xFFFF00FC)),
                    _chipMotorJuego('DIGIT_SPAN_MEM', '🧠 4. Memoria Secuencial', const Color(0xFFFFD700)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (_juegoActivo == 'SCHULTE_PRO_50') ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    ...nivelesJson.map((rawN) {
                      final int n = (rawN as num).toInt();
                      final bool sel = _cantNumeros == n;
                      return ChoiceChip(
                        label: Text(
                          '$n Nums',
                          style: TextStyle(
                            color: sel ? Colors.black : Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        selected: sel,
                        selectedColor: const Color(0xFF00FF66),
                        backgroundColor: const Color(0xFF142033),
                        onSelected: (_) {
                          setState(() => _cantNumeros = n);
                          _prepararTableroSchulte(iniciar: false);
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _btnModoCorto('PRESIONAR', '👆 Presionar', const Color(0xFF00FF66)),
                    const SizedBox(width: 6),
                    _btnModoCorto('SOLO_MENTAL', '🧠 Solo Mental', const Color(0xFF00F3FF)),
                    const SizedBox(width: 6),
                    _btnModoCorto('CHIMP', '🐒 Chimp Oculto', const Color(0xFFFFD700)),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _cantNumeros == 16 ? 4 : 5,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: _cantNumeros >= 35 ? 1.25 : 1.05,
                  ),
                  itemCount: _tableroSchulte.length,
                  itemBuilder: (ctx, idx) {
                    final int val = (_tableroSchulte[idx] as num).toInt();
                    final bool hecho = _modoSchulte != 'SOLO_MENTAL' && val < _objetivoSchulte;
                    return InkWell(
                      onTap: () => _tocarNumeroSchulte(val),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: hecho
                              ? const Color(0xFF052E16)
                              : (_ocultoChimp ? const Color(0xFF1E293B) : const Color(0xFF0F172A)),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: hecho ? const Color(0xFF00FF66) : const Color(0xFF00F3FF),
                            width: 1.3,
                          ),
                        ),
                        child: Text(
                          _ocultoChimp && !hecho ? '?' : '$val',
                          style: TextStyle(
                            color: hecho ? const Color(0xFF00FF66).withAlpha(110) : Colors.white,
                            fontSize: _cantNumeros >= 35 ? 16 : 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FF66),
                          foregroundColor: Colors.black,
                        ),
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: Text(
                          'INICIAR ($_cantNumeros NUMS) · ${(_tiempoMs / 1000).toStringAsFixed(1)}s',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
                        ),
                        onPressed: () => _prepararTableroSchulte(iniciar: true),
                      ),
                    ),
                    if (_modoSchulte == 'SOLO_MENTAL' && _corriendoReloj) ...[
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () => _celebrarVictoria(
                          'Recorrido mental de $_cantNumeros numeros en ${(_tiempoMs / 1000).toStringAsFixed(1)} segundos.',
                        ),
                        child: const Text('TERMINE MENTAL', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ],
                ),
              ],
              if (_juegoActivo == 'VEDIC_MATH_IA') ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF00F3FF)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Aciertos Vedicos: $_aciertosVedicos',
                        style: const TextStyle(color: Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_numA $_operadorVedico $_numB = ?',
                        style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _opcionesVedicas.map((op) {
                          final int v = (op as num).toInt();
                          return SizedBox(
                            width: 130,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E293B),
                                foregroundColor: const Color(0xFF00FF66),
                                side: const BorderSide(color: Color(0xFF00F3FF)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () => _responderVedico(v),
                              child: Text('$v', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () => _avatarHablar('Cuanto es $_numA multiplicado por $_numB'),
                        icon: const Icon(Icons.record_voice_over, color: Color(0xFF00FF66), size: 18),
                        label: const Text(
                          'ESCUCHAR PREGUNTA CON VOZ DEL AVATAR',
                          style: TextStyle(color: Color(0xFF00FF66), fontSize: 10.5, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_juegoActivo == 'ALPHA_RAIN_2D') ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFF00FC)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '🎯 ATRAPA CAPSULA OBJETIVO: $_objetivoRain  |  🔥 Combo: x$_comboRain',
                        style: const TextStyle(color: Color(0xFFFFD700), fontSize: 13, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: _burbujasRain.map((b) {
                          final String cod = b.toString();
                          return InkWell(
                            onTap: () => _tocarBurbujaRain(cod),
                            child: Container(
                              width: 74,
                              height: 54,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1B4B),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: const Color(0xFF00F3FF), width: 1.5),
                              ),
                              child: Text(
                                cod,
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
              if (_juegoActivo == 'DIGIT_SPAN_MEM') ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFD700)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'NIVEL ACTUAL: $_nivelSpan DIGITOS EN MEMORIA DE TRABAJO',
                        style: const TextStyle(color: Color(0xFFFFD700), fontSize: 11.5, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF00FF66)),
                        ),
                        child: Text(
                          _mostrandoSecuencia ? _secuenciaDigitSpan : '• ' * _nivelSpan,
                          style: const TextStyle(
                            color: Color(0xFF00FF66),
                            fontSize: 26,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _ctrlRespuestaSpan,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 3),
                        decoration: InputDecoration(
                          hintText: 'Escribe la secuencia de $_nivelSpan digitos...',
                          hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                          filled: true,
                          fillColor: Colors.black,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _generarSecuenciaDigitSpan,
                              child: const Text('NUEVA SECUENCIA', style: TextStyle(color: Color(0xFF00F3FF))),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00FF66),
                                foregroundColor: Colors.black,
                              ),
                              onPressed: _verificarDigitSpan,
                              child: const Text('VERIFICAR MEMORIA', style: TextStyle(fontWeight: FontWeight.w900)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          ConfettiWidget(
            confettiController: _confettiCtrl,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Color(0xFF00FF66),
              Color(0xFF00F3FF),
              Color(0xFFFF00FC),
              Color(0xFFFFD700),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipMotorJuego(String id, String label, Color col) {
    final bool sel = _juegoActivo == id;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: sel ? Colors.black : Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        selected: sel,
        selectedColor: col,
        backgroundColor: const Color(0xFF142033),
        onSelected: (_) {
          HapticFeedback.selectionClick();
          setState(() => _juegoActivo = id);
          if (id == 'DIGIT_SPAN_MEM') {
            _generarSecuenciaDigitSpan();
          }
        },
      ),
    );
  }

  Widget _btnModoCorto(String idModo, String label, Color col) {
    final bool sel = _modoSchulte == idModo;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _modoSchulte = idModo);
          _prepararTableroSchulte(iniciar: false);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
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
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}