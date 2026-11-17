import sys
import struct
import shutil
import pathlib
import subprocess

LT = chr(60)
GT = chr(62)

PUBSPEC_BLINDADO_18 = '''name: logica_sdui_fabrica_multiapp
description: Super-APK Definitivo Esquema 1 - 25 Microservicios y Voz Nativa Android
publish_to: 'none'
version: 2.2.0+1

environment:
  sdk: ^3.5.0

dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.2
  path: ^1.9.0
  crypto: ^3.0.6
  latlong2: ^0.9.1
  math_expressions: ^2.6.0
  units_converter: ^3.0.2
  confetti: ^0.8.0
  flutter_riverpod: ^2.6.1
  drag_and_drop_lists: ^0.4.2
  pdf: ^3.11.1
  ionicons: ^0.2.2
  qr_flutter: ^4.1.0
  expressions: ^0.2.5+2
  uuid: ^4.5.1
  fl_chart: ^0.69.0
  table_calendar: ^3.1.2
  screenshot: ^3.0.0

dependency_overrides:
  petitparser: ^6.0.2
  intl: ^0.19.0
  meta: ^1.15.0
  collection: ^1.18.0
  web: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - logo.png
'''

def es_png_rgba_valido(data: bytes) -> bool:
    if len(data) >= 33 and data[:8] == b'\x89PNG\r\n\x1a\n':
        w, h = struct.unpack('>II', data[16:24])
        color_type = data[25]
        return 16 <= w <= 1024 and 16 <= h <= 1024 and color_type in (2, 6)
    return False

def inyectar_tts_nativo_en_main_activity():
    main_dir = pathlib.Path('android/app/src/main')
    if not main_dir.exists():
        return
    for kt in main_dir.rglob('MainActivity.kt'):
        txt = kt.read_text(encoding='utf-8')
        lineas = [l.strip() for l in txt.splitlines() if l.strip().startswith('package ')]
        if not lineas:
            continue
        pkg_line = lineas[0]
        nuevo_kt = f'''{pkg_line}

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.ToneGenerator
import android.os.Bundle
import android.os.PowerManager
import android.speech.tts.TextToSpeech
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity: FlutterActivity(), TextToSpeech.OnInitListener {{
    private var tts: TextToSpeech? = null
    private var ttsListo: Boolean = false
    private var textoPendiente: String? = null
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onCreate(savedInstanceState: Bundle?) {{
        super.onCreate(savedInstanceState)
        try {{
            val pm = getSystemService(Context.POWER_SERVICE) as? PowerManager
            wakeLock = pm?.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "LogicaSdui::AvatarBolsilloLock")
            wakeLock?.acquire(30 * 60 * 1000L)
        }} catch (_: Exception) {{}}
        tts = TextToSpeech(applicationContext, this)
    }}

    override fun onInit(status: Int) {{
        if (status == TextToSpeech.SUCCESS) {{
            val attrs = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ALARM)
                .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                .build()
            tts?.setAudioAttributes(attrs)

            val rBo = tts?.setLanguage(Locale("es", "BO")) ?: TextToSpeech.LANG_NOT_SUPPORTED
            if (rBo == TextToSpeech.LANG_MISSING_DATA || rBo == TextToSpeech.LANG_NOT_SUPPORTED) {{
                val rEs = tts?.setLanguage(Locale("es", "ES")) ?: TextToSpeech.LANG_NOT_SUPPORTED
                if (rEs == TextToSpeech.LANG_MISSING_DATA || rEs == TextToSpeech.LANG_NOT_SUPPORTED) {{
                    tts?.setLanguage(Locale("es"))
                }}
            }}
            ttsListo = true
            val pend = textoPendiente
            if (pend != null && pend.isNotEmpty()) {{
                textoPendiente = null
                hablarAhora(pend, 1.0f, 0.95f)
            }}
        }}
    }}

    private fun hablarAhora(texto: String, pitch: Float, rate: Float) {{
        try {{
            val am = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
            if (am != null) {{
                val maxMusic = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
                val curMusic = am.getStreamVolume(AudioManager.STREAM_MUSIC)
                if (curMusic <= 1) {{
                    am.setStreamVolume(AudioManager.STREAM_MUSIC, (maxMusic * 0.75).toInt(), 0)
                }}
                val maxAlarm = am.getStreamMaxVolume(AudioManager.STREAM_ALARM)
                val curAlarm = am.getStreamVolume(AudioManager.STREAM_ALARM)
                if (curAlarm <= 1) {{
                    am.setStreamVolume(AudioManager.STREAM_ALARM, (maxAlarm * 0.80).toInt(), 0)
                }}
            }}
            ToneGenerator(AudioManager.STREAM_ALARM, 85).startTone(ToneGenerator.TONE_PROP_BEEP, 140)
        }} catch (_: Exception) {{}}

        if (!ttsListo) {{
            textoPendiente = texto
            return
        }}
        tts?.setPitch(pitch)
        tts?.setSpeechRate(rate)
        val params = Bundle()
        params.putFloat(TextToSpeech.Engine.KEY_PARAM_VOLUME, 1.0f)
        tts?.speak(texto, TextToSpeech.QUEUE_FLUSH, params, "sdui_utt_" + System.currentTimeMillis())
    }}

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {{
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.logicasdui/tts_nativo").setMethodCallHandler {{ call, result ->
            if (call.method == "speak") {{
                val text: String = call.argument("text") ?: ""
                val pitchNum: Number? = call.argument("pitch")
                val rateNum: Number? = call.argument("rate")
                val pitch = pitchNum?.toFloat() ?: 1.0f
                val rate = rateNum?.toFloat() ?: 0.95f
                hablarAhora(text, pitch, rate)
                result.success(true)
            }} else if (call.method == "stop") {{
                tts?.stop()
                result.success(true)
            }} else {{
                result.notImplemented()
            }}
        }}
    }}

    override fun onDestroy() {{
        try {{
            if (wakeLock?.isHeld == true) {{
                wakeLock?.release()
            }}
        }} catch (_: Exception) {{}}
        tts?.stop()
        tts?.shutdown()
        super.onDestroy()
    }}
}}
'''
        kt.write_text(nuevo_kt, encoding='utf-8')

def configurar_android():
    logo = pathlib.Path('logo.png')
    res_dir = pathlib.Path('android/app/src/main/res')
    if logo.exists() and res_dir.exists():
        icono_limpio = pathlib.Path('/tmp/ic_launcher_clean.png')
        convert_ok = False
        try:
            r = subprocess.run(['convert', 'logo.png', '-resize', '192x192', 'PNG32:/tmp/ic_launcher_clean.png'], capture_output=True)
            if r.returncode == 0 and icono_limpio.exists():
                convert_ok = True
        except Exception:
            pass

        origen_icono = icono_limpio if convert_ok else (logo if es_png_rgba_valido(logo.read_bytes()) else None)
        if origen_icono is not None:
            for mipmap in res_dir.glob('mipmap-*'):
                if mipmap.is_dir():
                    for nombre in ['ic_launcher.png', 'ic_launcher_round.png']:
                        destino = mipmap / nombre
                        if destino.exists() or nombre == 'ic_launcher.png':
                            shutil.copyfile(origen_icono, destino)

    manifest = pathlib.Path('android/app/src/main/AndroidManifest.xml')
    if manifest.exists():
        txt = manifest.read_text(encoding='utf-8')
        permisos = [
            'android.permission.INTERNET',
            'android.permission.ACCESS_NETWORK_STATE',
            'android.permission.ACCESS_WIFI_STATE',
            'android.permission.CAMERA',
            'android.permission.RECORD_AUDIO',
            'android.permission.MODIFY_AUDIO_SETTINGS',
            'android.permission.VIBRATE',
            'android.permission.ACCESS_FINE_LOCATION',
            'android.permission.ACCESS_COARSE_LOCATION',
            'android.permission.BLUETOOTH',
            'android.permission.BLUETOOTH_ADMIN',
            'android.permission.BLUETOOTH_SCAN',
            'android.permission.BLUETOOTH_CONNECT',
            'android.permission.WAKE_LOCK',
            'android.permission.FOREGROUND_SERVICE',
            'android.permission.SCHEDULE_EXACT_ALARM',
            'android.permission.USE_EXACT_ALARM',
            'android.permission.POST_NOTIFICATIONS',
            'android.permission.RECEIVE_BOOT_COMPLETED',
            'android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
            'android.permission.ACTIVITY_RECOGNITION',
            'android.permission.USE_BIOMETRIC',
        ]
        lineas_xml = ''
        for p in permisos:
            if p not in txt:
                lineas_xml += f'    {LT}uses-permission android:name="{p}"/{GT}\n'
        tag_app = f'{LT}application'
        if lineas_xml and tag_app in txt:
            txt = txt.replace(tag_app, lineas_xml + '    ' + tag_app, 1)
            manifest.write_text(txt, encoding='utf-8')

    inyectar_tts_nativo_en_main_activity()

    for ruta_g in ['android/app/build.gradle', 'android/app/build.gradle.kts']:
        gp = pathlib.Path(ruta_g)
        if gp.exists():
            gtxt = gp.read_text(encoding='utf-8')
            gtxt = gtxt.replace('minSdk = flutter.minSdkVersion', 'minSdk = 24')
            gtxt = gtxt.replace('minSdkVersion flutter.minSdkVersion', 'minSdkVersion 24')
            gtxt = gtxt.replace('compileSdk = flutter.compileSdkVersion', 'compileSdk = 34')
            gp.write_text(gtxt, encoding='utf-8')

def resolver_pubspec():
    pathlib.Path('pubspec.yaml').write_text(PUBSPEC_BLINDADO_18, encoding='utf-8')
    subprocess.run(['flutter', 'pub', 'get'], check=True)

def compilar_apk():
    inyectar_tts_nativo_en_main_activity()
    pathlib.Path('pubspec.yaml').write_text(PUBSPEC_BLINDADO_18, encoding='utf-8')
    subprocess.run(['flutter', 'pub', 'get'], check=True)
    subprocess.run(['flutter', 'build', 'apk', '--release', '--no-tree-shake-icons'], check=True)

if __name__ == '__main__':
    accion = sys.argv[1] if len(sys.argv) != 1 else 'android'
    if accion == 'android':
        configurar_android()
    elif accion == 'pub':
        resolver_pubspec()
    elif accion == 'apk':
        compilar_apk()