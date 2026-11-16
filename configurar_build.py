import sys
import struct
import shutil
import pathlib
import subprocess

LT = chr(60)
GT = chr(62)

def es_png_rgba_valido(data: bytes) -> bool:
    if len(data) >= 33 and data[:8] == b'\x89PNG\r\n\x1a\n':
        w, h = struct.unpack('>II', data[16:24])
        color_type = data[25]
        return 16 <= w <= 1024 and 16 <= h <= 1024 and color_type in (2, 6)
    return False

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
            'android.permission.VIBRATE',
        ]
        lineas_xml = ''
        for p in permisos:
            lineas_xml += f'    {LT}uses-permission android:name="{p}"/{GT}\n'
        tag_app = f'{LT}application'
        if 'android.permission.CAMERA' not in txt and tag_app in txt:
            txt = txt.replace(tag_app, lineas_xml + '    ' + tag_app, 1)
            manifest.write_text(txt, encoding='utf-8')

    for ruta_g in ['android/app/build.gradle', 'android/app/build.gradle.kts']:
        gp = pathlib.Path(ruta_g)
        if gp.exists():
            gtxt = gp.read_text(encoding='utf-8')
            gtxt = gtxt.replace('minSdk = flutter.minSdkVersion', 'minSdk = 24')
            gtxt = gtxt.replace('minSdkVersion flutter.minSdkVersion', 'minSdkVersion 24')
            gtxt = gtxt.replace('compileSdk = flutter.compileSdkVersion', 'compileSdk = 34')
            gp.write_text(gtxt, encoding='utf-8')

def resolver_pubspec():
    # Primero intenta resolver el pubspec.yaml intacto con las 88 librerias
    res = subprocess.run(['flutter', 'pub', 'get'])
    if res.returncode == 0:
        return
    # Respaldo seguro solo si algun paquete externo tiene conflicto de version en el runner
    res_up = subprocess.run(['flutter', 'pub', 'get', '--up'])
    if res_up.returncode != 0:
        contenido_seguro = '''name: logica_sdui_fabrica_multiapp
description: APK Esquema 1 - Laboratorio SDUI Pantalla Completa
publish_to: 'none'
version: 1.0.0+1

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

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - logo.png
'''
        pathlib.Path('pubspec.yaml').write_text(contenido_seguro, encoding='utf-8')
        subprocess.run(['flutter', 'pub', 'get'], check=True)

def compilar_apk():
    res = subprocess.run(['flutter', 'build', 'apk', '--release', '--no-tree-shake-icons'])
    if res.returncode != 0:
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