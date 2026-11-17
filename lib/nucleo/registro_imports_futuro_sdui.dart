import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart' as crypto_pkg;
import 'package:latlong2/latlong.dart' as latlong_pkg;
import 'package:math_expressions/math_expressions.dart' as math_exp;
import 'package:units_converter/units_converter.dart' as units_pkg;
import 'package:confetti/confetti.dart' as confetti_pkg;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod_pkg;
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart' as dnd_pkg;
import 'package:pdf/widgets.dart' as pw;
import 'package:ionicons/ionicons.dart' as ion_pkg;
import 'package:qr_flutter/qr_flutter.dart' as qr_pkg;
import 'package:expressions/expressions.dart' as expr_pkg;
import 'package:uuid/uuid.dart' as uuid_pkg;
import 'package:fl_chart/fl_chart.dart' as fl_pkg;
import 'package:table_calendar/table_calendar.dart' as cal_pkg;
import 'package:screenshot/screenshot.dart' as shot_pkg;
import 'package:flutter_tts/flutter_tts.dart';

class RegistroImportsFuturoSdui {
  static final uuid_pkg.Uuid _generadorUuid = const uuid_pkg.Uuid();
  static final FlutterTts _flutterTts = FlutterTts();
  static const MethodChannel _canalTtsNativo = MethodChannel('com.logicasdui/tts_nativo');
  static bool _ttsInicializado = false;

  static String generarUuidNativo() {
    return _generadorUuid.v4();
  }

  static String encriptarSha256Nativo(String texto) {
    final bytes = texto.codeUnits;
    return crypto_pkg.sha256.convert(bytes).toString();
  }

  static Future inicializarMotorVoz() async {
    if (_ttsInicializado) return;
    _ttsInicializado = true;
    try {
      await _flutterTts.setLanguage('es-ES');
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setSpeechRate(0.52);
      await _flutterTts.setPitch(1.0);
    } catch (_) {}
  }

  static Future hablarVozNativa({
    required String texto,
    double pitch = 1.0,
    double rate = 0.52,
  }) async {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    await inicializarMotorVoz();

    try {
      await _flutterTts.setLanguage('es-ES');
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(pitch);
      await _flutterTts.setSpeechRate(rate > 0.7 ? 0.52 : rate);
      await _flutterTts.speak(texto);
    } catch (_) {}

    try {
      await _canalTtsNativo.invokeMethod('speak', {
        'text': texto,
        'pitch': pitch,
        'rate': 0.95,
      });
    } catch (_) {}
  }

  static Future detenerVozNativa() async {
    try {
      await _flutterTts.stop();
    } catch (_) {}
    try {
      await _canalTtsNativo.invokeMethod('stop');
    } catch (_) {}
  }

  static double evaluarFormulaMatematicaJson(String formula, double valorX) {
    try {
      final parser = math_exp.Parser();
      final exp = parser.parse(formula);
      final cm = math_exp.ContextModel();
      cm.bindVariable(math_exp.Variable('x'), math_exp.Number(valorX));
      final eval = exp.evaluate(math_exp.EvaluationType.REAL, cm);
      return double.tryParse(eval.toString()) ?? 0.0;
    } catch (_) {
      return 0.0;
    }
  }

  static bool evaluarReglaExpresionJson(String expresionStr, Map contexto) {
    try {
      final expression = expr_pkg.Expression.parse(expresionStr);
      const evaluator = expr_pkg.ExpressionEvaluator();
      final r = evaluator.eval(expression, contexto.map((k, v) => MapEntry(k.toString(), v)));
      return r == true;
    } catch (_) {
      return false;
    }
  }

  static Map verificarMotoresCompiladosEnApk() {
    final coordOruro = const latlong_pkg.LatLng(-17.9647, -67.1060);
    final rutaDemo = p.join('esquema1', 'sdui_pantallas');
    final clienteHttp = http.Client();
    clienteHttp.close();

    return {
      'uuid_ejemplo': generarUuidNativo(),
      'hash_sha256': encriptarSha256Nativo('SUPER_APK_SDUI_107').substring(0, 16),
      'coordenadas_gps_oruro': '${coordOruro.latitude}, ${coordOruro.longitude}',
      'ruta_sdui': rutaDemo,
      'riverpod_activo': riverpod_pkg.ProviderContainer.new.toString().isNotEmpty,
      'dnd_activo': dnd_pkg.DragAndDropList.new.toString().isNotEmpty,
      'pdf_activo': pw.Document.new.toString().isNotEmpty,
      'confetti_activo': confetti_pkg.ConfettiController.new.toString().isNotEmpty,
      'unidades_activo': units_pkg.LENGTH.meters.toString().isNotEmpty,
      'ionicons_activo': ion_pkg.Ionicons.planet_outline.codePoint != 0,
      'qr_real_activo': qr_pkg.QrImageView.new.toString().isNotEmpty,
      'flchart_activo': fl_pkg.FlSpot.new.toString().isNotEmpty,
      'calendar_activo': cal_pkg.CalendarFormat.month.name.isNotEmpty,
      'latex_activo': evaluarFormulaMatematicaJson('x^2 + 2*x + 1', 3) == 16.0,
      'screenshot_activo': shot_pkg.ScreenshotController.new.toString().isNotEmpty,
      'tts_real_activo': _flutterTts.toString().isNotEmpty,
    };
  }

  static Widget construirQrVectorialReal({
    required String dataQr,
    double tamano = 165,
    Color colorFondo = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00F3FF), width: 2.5),
      ),
      child: qr_pkg.QrImageView(
        data: dataQr.isEmpty ? 'ORBE-SDUI-QR' : dataQr,
        version: qr_pkg.QrVersions.auto,
        size: tamano,
        backgroundColor: colorFondo,
      ),
    );
  }
}