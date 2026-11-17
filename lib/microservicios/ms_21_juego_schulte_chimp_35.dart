import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/puente_supabase_sdui.dart';

class Ms21JuegoSchulteChimp35 extends StatefulWidget {
  final Map bloque;
  final Function(String) onFeedback;

  const Ms21JuegoSchulteChimp35({
    super.key,
    required this.bloque,
    required this.onFeedback,
  });

  @override
  State createState() => _Ms21JuegoSchulteChimp35State();
}

class _Ms21JuegoSchulteChimp35State extends State {
  final math.Random _rng = math.Random();
  Timer? _timerCronometro;

  int _totalNumeros = 25;
  String _nombreNivel = 'MEDIO (25 Numeros)';
  String _modoJuego = 'PRESIONAR';
  String _modoSonido = 'RELAJANTE';

  List _numerosTablero = [];
  List _coloresCeldas = [];
  int _siguienteNumero = 1;
  bool _jugando = false;
  bool _ocultarChimp = false;
  bool _esperandoVerificacionMental = false;
  int _numeroPreguntaMental = 25;
  int _indiceCorrectoMental = 0;

  int _milisegundosTranscurridos = 0;
  int _puntosPartida = 0;
  int _erroresPartida = 0;
  int _rachaActual = 0;
  int _ultimoTiempoTapMs = 0;
  int _dudasDetectadas = 0;

  final Map _mejoresTiemposMs = {16: 18400, 25: 29800, 30: 44200, 35: 58900};
  int _puntosTotalesAcumulados = 1450;
  int _partidasCompletadas = 3;

  final List _historialAvance = [
    {'nivel': 'MEDIO (25 Numeros)', 'modo': 'PRESIONAR', 'tiempo': '29.8s', 'puntos': 620, 'rango': 'Experto Visual'},
    {'nivel': 'GENIO (35 Numeros)', 'modo': 'SOLO_MENTAL', 'tiempo': '58.9s', 'puntos': 980, 'rango': 'Maestro Periferico'},
  ];

  static const List _paletaColegio = [Color(0xFF0F2942), Color(0xFF1A1438), Color(0xFF0A2E26), Color(0xFF2D162C), Color(0xFF2B2111)];
  static const List _paletaRelajante = [Color(0xFF091E26), Color(0xFF0D262E), Color(0xFF112E36), Color(0xFF0B2229)];

  @override
  void initState() {
    super.initState();
    _generarTableroNuevo(iniciarReloj: false);
  }

  @override
  void dispose() {
    _timerCronometro?.cancel();
    super.dispose();
  }

  void _emitirEfectoSonoro({required bool esAcierto, bool esVictoria = false}) {
    if (_modoSonido == 'SILENCIO') return;
    if (esVictoria) {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.click);
      return;
    }
    if (_modoSonido == 'RELAJANTE') {
      HapticFeedback.selectionClick();
      if (esAcierto) SystemSound.play(SystemSoundType.click);
    } else {
      if (esAcierto) {
        HapticFeedback.lightImpact();
        SystemSound.play(SystemSoundType.click);
      } else {
        HapticFeedback.heavyImpact();
      }
    }
  }

  void _cambiarNivel(int cant, String etiqueta) {
    _timerCronometro?.cancel();
    setState(() {
      _totalNumeros = cant;
      _nombreNivel = etiqueta;
    });
    _generarTableroNuevo(iniciarReloj: false);
  }

  void _generarTableroNuevo({required bool iniciarReloj}) {
    _timerCronometro?.cancel();
    final List lista = List.generate(_totalNumeros, (i) => i + 1)..shuffle(_rng);
    final List cols = List.generate(_totalNumeros, (i) {
      return _modoSonido == 'RELAJANTE'
          ? _paletaRelajante[i % _paletaRelajante.length]
          : _paletaColegio[i % _paletaColegio.length];
    });

    setState(() {
      _numerosTablero = lista;
      _coloresCeldas = cols;
      _siguienteNumero = 1;
      _jugando = iniciarReloj;
      _ocultarChimp = false;
      _esperandoVerificacionMental = false;
      _milisegundosTranscurridos = 0;
      _puntosPartida = 0;
      _erroresPartida = 0;
      _rachaActual = 0;
      _ultimoTiempoTapMs = 0;
      _dudasDetectadas = 0;
    });

    if (iniciarReloj) _iniciarCronometro();
  }

  void _iniciarCronometro() {
    _timerCronometro?.cancel();
    _timerCronometro = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted || !_jugando) return;
      setState(() => _milisegundosTranscurridos += 100);
    });
  }

  String _formatearTiempo(int ms) => '${(ms / 1000.0).toStringAsFixed(1)}s';

  String _clasificarRendimiento(int ms) {
    final double seg = ms / 1000.0;
    final double factor = _totalNumeros / 25.0;
    if (seg <= 15.0 * factor) return '🏆 CLASE MUNDIAL / ELITE';
    if (seg <= 25.0 * factor) return '⚡ EXPERTO LECTURA VELOZ';
    if (seg <= 38.0 * factor) return '🟢 AVANZADO PERIFERICO';
    return '🧠 EN ENTRENAMIENTO ACTIVO';
  }

  void _alTocarCelda(int numeroCelda, int indexCelda) {
    if (_esperandoVerificacionMental) {
      if (indexCelda == _indiceCorrectoMental) {
        _emitirEfectoSonoro(esAcierto: true, esVictoria: true);
        setState(() {
          _esperandoVerificacionMental = false;
          _puntosPartida += (_totalNumeros * 25);
        });
        _finalizarYRegistrarAvance();
      } else {
        _emitirEfectoSonoro(esAcierto: false);
        setState(() => _erroresPartida++);
        (widget as Ms21JuegoSchulteChimp35).onFeedback('⚠️ Casilla incorrecta. Busca donde estaba el $_numeroPreguntaMental.');
      }
      return;
    }

    if (_modoJuego == 'SOLO_MENTAL') {
      if (!_jugando) {
        _generarTableroNuevo(iniciarReloj: true);
      } else {
        (widget as Ms21JuegoSchulteChimp35).onFeedback('🧠 Modo Solo Mental: Recorre del 1 al $_totalNumeros con la vista.');
      }
      return;
    }

    if (!_jugando) {
      if (numeroCelda == 1) {
        _iniciarCronometro();
        setState(() {
          _jugando = true;
          _siguienteNumero = 2;
          _rachaActual = 1;
          _puntosPartida = 25;
          _ultimoTiempoTapMs = 0;
          if (_modoJuego == 'CHIMP_OCULTO') _ocultarChimp = true;
        });
        _emitirEfectoSonoro(esAcierto: true);
      } else {
        (widget as Ms21JuegoSchulteChimp35).onFeedback('👆 Toca primero el numero 1.');
      }
      return;
    }

    if (numeroCelda == _siguienteNumero) {
      final int deltaTap = _milisegundosTranscurridos - _ultimoTiempoTapMs;
      _ultimoTiempoTapMs = _milisegundosTranscurridos;
      if (deltaTap > 2800) _dudasDetectadas++;
      final int bono = deltaTap < 900 ? 15 : 10;
      final int mult = _modoJuego == 'CHIMP_OCULTO' ? 2 : 1;

      setState(() {
        if (_siguienteNumero == 1 && _modoJuego == 'CHIMP_OCULTO') _ocultarChimp = true;
        _siguienteNumero++;
        _rachaActual++;
        _puntosPartida += (20 + bono) * mult;
      });

      if (_siguienteNumero > _totalNumeros) {
        _emitirEfectoSonoro(esAcierto: true, esVictoria: true);
        _finalizarYRegistrarAvance();
      } else {
        _emitirEfectoSonoro(esAcierto: true);
      }
    } else {
      _emitirEfectoSonoro(esAcierto: false);
      setState(() {
        _erroresPartida++;
        _rachaActual = 0;
        _puntosPartida = math.max(0, _puntosPartida - 10);
      });
    }
  }

  void _terminarEscaneoSoloMental() {
    if (!_jugando) return;
    _timerCronometro?.cancel();
    final int objetivo = _totalNumeros;
    final int idxObj = _numerosTablero.indexOf(objetivo);
    setState(() {
      _jugando = false;
      _esperandoVerificacionMental = true;
      _ocultarChimp = true;
      _numeroPreguntaMental = objetivo;
      _indiceCorrectoMental = idxObj;
    });
    (widget as Ms21JuegoSchulteChimp35).onFeedback('🧠 Verificacion Mental: Toca donde estaba el $_numeroPreguntaMental.');
  }

  Future _finalizarYRegistrarAvance() async {
    _timerCronometro?.cancel();
    final int tFinal = math.max(800, _milisegundosTranscurridos);
    final int recAnt = (_mejoresTiemposMs[_totalNumeros] as int?) ?? 999000;
    final bool nuevoRec = tFinal < recAnt;
    final String rango = _clasificarRendimiento(tFinal);
    final int ptsFinal = _puntosPartida + (_erroresPartida == 0 ? 150 : 0) + (nuevoRec ? 250 : 0);

    setState(() {
      _jugando = false;
      _ocultarChimp = false;
      _puntosPartida = ptsFinal;
      _puntosTotalesAcumulados += ptsFinal;
      _partidasCompletadas++;
      if (nuevoRec) _mejoresTiemposMs[_totalNumeros] = tFinal;
      _historialAvance.insert(0, {
        'nivel': _nombreNivel,
        'modo': _modoJuego,
        'tiempo': _formatearTiempo(tFinal),
        'puntos': ptsFinal,
        'rango': rango,
      });
    });

    (widget as Ms21JuegoSchulteChimp35).onFeedback('🏆 Tiempo: ${_formatearTiempo(tFinal)} · +$ptsFinal Pts');
    await PuenteSupabaseSdui.ejecutarRpcUniversal(
      'esq1_rpc_guardar_app_o_usuario',
      {
        'p_operacion': 'GUARDAR_AVANCE_CEREBRAL_35',
        'p_nivel': _nombreNivel,
        'p_total_numeros': _totalNumeros,
        'p_modo_juego': _modoJuego,
        'p_tiempo_ms': tFinal,
        'p_puntos': ptsFinal,
      },
      esquemaOverride: 'esquema1',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool esZen = _modoSonido == 'RELAJANTE';
    final Color cAcento = esZen ? const Color(0xFF00F3FF) : const Color(0xFF00FF66);
    final Color cSec = esZen ? const Color(0xFFA7F3D0) : const Color(0xFFFFD700);
    final int colsGrid = _totalNumeros == 16 ? 4 : 5;
    final int recMs = (_mejoresTiemposMs[_totalNumeros] as int?) ?? 30000;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF070B19),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cAcento, width: 1.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🧠 NEURO-TRAINER (16 A 35 NUMS)', style: TextStyle(color: cSec, fontSize: 13, fontWeight: FontWeight.w900)),
              Text('⭐ $_puntosTotalesAcumulados PTS', style: TextStyle(color: cSec, fontSize: 11, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _cajaMetrica('OBJETIVO', _modoJuego == 'SOLO_MENTAL' ? '1➔$_totalNumeros' : '#$_siguienteNumero', cAcento),
              const SizedBox(width: 6),
              _cajaMetrica('TIEMPO', _formatearTiempo(_milisegundosTranscurridos), const Color(0xFF00F3FF)),
              const SizedBox(width: 6),
              _cajaMetrica('RECORD', _formatearTiempo(recMs), const Color(0xFFFFD700)),
              const SizedBox(width: 6),
              _cajaMetrica('RACHA/PTS', '$_rachaActual·$_puntosPartida', const Color(0xFFFF00FC)),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chipNivel(16, '🟢 BASICO (16)', const Color(0xFF00FF66)),
                _chipNivel(25, '🔵 MEDIO (25)', const Color(0xFF00F3FF)),
                _chipNivel(30, '🟠 DIFICIL (30)', const Color(0xFFFF9800)),
                _chipNivel(35, '👑 GENIO (35)', const Color(0xFFFF00FC)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _btnModo('PRESIONAR', '👆 Presionar', const Color(0xFF00FF66)),
              const SizedBox(width: 6),
              _btnModo('SOLO_MENTAL', '🧠 Solo Mental', const Color(0xFF00F3FF)),
              const SizedBox(width: 6),
              _btnModo('CHIMP_OCULTO', '🐒 Chimp Test', const Color(0xFFFFD700)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _btnSonido('RELAJANTE', '🧘 Zen', const Color(0xFF00F3FF)),
              const SizedBox(width: 6),
              _btnSonido('COLEGIO', '🏫 Colegio', const Color(0xFFFFD700)),
              const SizedBox(width: 6),
              _btnSonido('SILENCIO', '🔇 Silencio', Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: colsGrid,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: _totalNumeros >= 30 ? 1.15 : 1.0,
            ),
            itemCount: _numerosTablero.length,
            itemBuilder: (ctx, idx) {
              final int numVal = (_numerosTablero[idx] as num).toInt();
              final bool hecho = _modoJuego != 'SOLO_MENTAL' && !_esperandoVerificacionMental && numVal < _siguienteNumero;
              return InkWell(
                onTap: () => _alTocarCelda(numVal, idx),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _ocultarChimp && !hecho ? const Color(0xFF1E293B) : (hecho ? const Color(0xFF052E16) : (_coloresCeldas[idx] as Color)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: hecho ? const Color(0xFF00FF66) : cAcento),
                  ),
                  child: Text(
                    _ocultarChimp && !hecho ? '?' : '$numVal',
                    style: TextStyle(
                      color: hecho ? const Color(0xFF00FF66).withAlpha(110) : Colors.white,
                      fontSize: _totalNumeros >= 30 ? 17 : 20,
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
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF66), foregroundColor: Colors.black),
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: Text(_jugando ? 'REINICIAR ($_totalNumeros)' : 'INICIAR PARTIDA (1➔$_totalNumeros)', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                  onPressed: () => _generarTableroNuevo(iniciarReloj: true),
                ),
              ),
              if (_modoJuego == 'SOLO_MENTAL' && _jugando) ...[
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
                  onPressed: _terminarEscaneoSoloMental,
                  child: const Text('TERMINE MENTAL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10.5)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _cajaMetrica(String t, String v, Color c) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8), border: Border.all(color: c.withAlpha(140))),
        child: Column(
          children: [
            Text(t, style: const TextStyle(color: Colors.white60, fontSize: 8, fontWeight: FontWeight.bold)),
            Text(v, style: TextStyle(color: c, fontSize: 11.5, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _chipNivel(int cant, String lbl, Color c) {
    final bool sel = _totalNumeros == cant;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(lbl, style: TextStyle(color: sel ? Colors.black : Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
        selected: sel,
        selectedColor: c,
        backgroundColor: const Color(0xFF142033),
        onSelected: (_) => _cambiarNivel(cant, lbl),
      ),
    );
  }

  Widget _btnModo(String id, String lbl, Color c) {
    final bool sel = _modoJuego == id;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _modoJuego = id);
          _generarTableroNuevo(iniciarReloj: false);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(color: sel ? c : const Color(0xFF142033), borderRadius: BorderRadius.circular(8), border: Border.all(color: c)),
          child: Text(lbl, textAlign: TextAlign.center, style: TextStyle(color: sel ? Colors.black : Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }

  Widget _btnSonido(String id, String lbl, Color c) {
    final bool sel = _modoSonido == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _modoSonido = id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(color: sel ? c.withAlpha(45) : Colors.black54, borderRadius: BorderRadius.circular(8), border: Border.all(color: sel ? c : Colors.white24)),
          child: Text(lbl, textAlign: TextAlign.center, style: TextStyle(color: sel ? c : Colors.white70, fontSize: 9.5, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}