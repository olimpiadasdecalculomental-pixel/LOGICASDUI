import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'escudo_aislamiento.dart';
import 'puente_supabase_sdui.dart';
import 'despachador_acciones.dart';
import 'inspector_stitch.dart';
import 'modales_candado_y_editor.dart';
import 'registro_imports_futuro_sdui.dart';
import '../microservicios/ms_01_header_y_grids.dart';
import '../microservicios/ms_02_catalogo_y_drag_drop.dart';
import '../microservicios/ms_03_wechat_y_ciencias.dart';
import '../microservicios/ms_04_cine_4dx_y_ar_vr.dart';
import '../microservicios/ms_05_uber_gps_y_binance.dart';
import '../microservicios/ms_06_pizarra_qr_optico.dart';
import '../microservicios/ms_07_kahoot_lumosity_iot.dart';
import '../microservicios/ms_08_cine_cristal_html5.dart';
import '../microservicios/ms_09_tarjeta_neon_base.dart';
import '../microservicios/ms_10_motores_stac_y_jdw.dart';
import '../microservicios/ms_11_stitch_diseno_1_muro.dart';
import '../microservicios/ms_14_studio_prd_rfc_pdf.dart';
import '../microservicios/ms_15_teoria_3_links.dart';
import '../microservicios/ms_16_fabrica_multi_app_usuarios.dart';
import '../microservicios/ms_17_diccionario_uxui_interactivo.dart';
import '../microservicios/ms_18_app_imperio_clon.dart';
import '../microservicios/ms_19_motores_imperio.dart';
import '../microservicios/ms_20_motor_atomico_universal_sdui.dart';
import '../microservicios/ms_21_juego_schulte_chimp_35.dart';
import '../microservicios/ms_22_avatar_ia_bolsillo_voz.dart';
import '../microservicios/ms_23_motores_reales_hardware_negocio.dart';
import '../microservicios/ms_24_consola_universal_juegos_sdui.dart';

class LienzoMaestroSdui extends StatefulWidget {
  const LienzoMaestroSdui({super.key});
  @override
  State createState() => _LienzoMaestroSduiState();
}

class _LienzoMaestroSduiState extends State with WidgetsBindingObserver {
  final PageController _pageCtrl = PageController();
  int _indicePantallaActiva = 0;
  String _feedback = '';
  int _toquesCandado = 0;
  bool _modoAdminDesbloqueado = false;

  final Map _estadoForm = {};
  String _modoRealidad = 'VR';
  double _offsetVrX = 0.0;
  final List _trazosPizarra = [];
  Color _colorLapiz = const Color(0xFF00FF66);
  final Set _celdasLumosity = {0, 4, 8};
  bool _arduinoLed1 = true;
  bool _arduinoRele2 = false;
  int _episodioCine = 0;
  int _xpDuolingo = 350;
  bool _modo4DX = true;
  String _motorImperioActivo = 'CINETV';
  Map _argsMotorImperio = {};

  List _pantallasSduiJson = [
    {
      'id_pantalla': 'ORBE_01_LOGIN',
      'orden_pantalla': 1,
      'titulo_pestana': '🦁 1. LOGIN ORBE',
      'rol_permitido': 'TODOS',
      'color_primario_pantalla': '#05050F',
      'componentes_json': [
        {
          'id': 'hero_login_espera',
          'tipo': 'HERO_NEON_JSON',
          'icono_emoji': '🦁',
          'color_resplandor_icono': '#FFD700',
          'titulo': 'MIS TALENTOS ORBE',
          'color_titulo': '#FF0033',
          'subtitulo': 'M E J O R A   T U S   T A L E N T O S',
        },
        {
          'id': 'card_sync_inicial',
          'tipo': 'TARJETA_NEON',
          'titulo': '🔄 CONECTANDO CON SUPABASE ESQUEMA 1 (24 MICROSERVICIOS + 107 LIBRERIAS)',
          'subtitulo': 'Toca el boton abajo para sincronizar las 10 Pantallas en Puro JSON (incluyendo Avatar de Bolsillo, Suite de Motores Reales y Consola de Juegos 16 a 50 Numeros).',
          'color_borde': '#00F3FF',
          'botones': [
            {
              'texto': '🔄 DESCARGAR PANTALLAS JSON DE SUPABASE',
              'accion': 'SINCRONIZAR_AHORA',
              'color': '#00FF66',
              'color_texto': '#000000',
            }
          ],
        }
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    RegistroImportsFuturoSdui.verificarMotoresCompiladosEnApk();
    _cargarPantallasDesdeSupabase();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageCtrl.dispose();
    super.dispose();
  }

  void _mostrarFeedback(String msg) {
    if (!mounted) return;
    setState(() => _feedback = msg);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _feedback == msg) {
        setState(() => _feedback = '');
      }
    });
  }

  Future _cargarPantallasDesdeSupabase() async {
    final res = await PuenteSupabaseSdui.ejecutarRpcUniversal(
      'esq1_rpc_obtener_pantallas_json',
      {'p_id_admin': PuenteSupabaseSdui.idAdmin},
      esquemaOverride: 'esquema1',
    );
    if (!mounted) return;
    if (res['exito'] == true && res['pantallas'] is List && (res['pantallas'] as List).isNotEmpty) {
      setState(() {
        _pantallasSduiJson = List.from(res['pantallas'] as List);
        _indicePantallaActiva = _indicePantallaActiva.clamp(0, _pantallasSduiJson.length - 1);
      });
    }
  }

  void _navegarAPantallaPorId(String idPantallaDestino) {
    final int idx = _pantallasSduiJson.indexWhere(
      (p) => (p as Map)['id_pantalla']?.toString() == idPantallaDestino,
    );
    if (idx >= 0 && _pageCtrl.hasClients) {
      HapticFeedback.mediumImpact();
      _pageCtrl.animateToPage(
        idx,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
      setState(() => _indicePantallaActiva = idx);
    } else {
      _mostrarFeedback('Pantalla destino: $idPantallaDestino');
    }
  }

  void _dispararBotonSdui(Map btn, Map bloquePadre) {
    final String accion = btn['accion']?.toString() ?? 'EJECUTAR_RPC';

    if (accion == 'SINCRONIZAR_AHORA') {
      _cargarPantallasDesdeSupabase();
      return;
    }

    if (btn['set_session_nombre'] != null) {
      _estadoForm['session_nombre'] = btn['set_session_nombre'].toString();
    }
    if (btn['set_session_rango'] != null) {
      _estadoForm['session_rango'] = btn['set_session_rango'].toString();
    }
    if (btn['set_session_saldo'] != null) {
      _estadoForm['session_saldo'] = btn['set_session_saldo'].toString();
    }

    if (accion == 'ABRIR_MODAL_JSON' && btn['modal_json'] is Map) {
      Ms20MotorAtomicoUniversalSdui.abrirModalUniversalDesdeJson(
        context: context,
        configModal: Map.from(btn['modal_json'] as Map),
        anchoPantalla: MediaQuery.of(context).size.width,
        estadoForm: _estadoForm,
        onActualizarCampo: (k, v) => setState(() => _estadoForm[k] = v),
        onDispararBoton: _dispararBotonSdui,
        onNavegarPantalla: _navegarAPantallaPorId,
      );
      return;
    }

    if (accion == 'NAVEGAR_PANTALLA_JSON' || btn['pantalla_destino'] != null) {
      final String dest = btn['pantalla_destino']?.toString() ?? 'ORBE_01_LOGIN';
      _navegarAPantallaPorId(dest);
      if (btn['mensaje_toast'] != null) {
        _mostrarFeedback(btn['mensaje_toast'].toString());
      }
      return;
    }

    DespachadorAccionesSdui.dispararAccion(
      context: context,
      btn: btn,
      bloquePadre: bloquePadre,
      estadoForm: _estadoForm,
      xpDuolingoActual: _xpDuolingo,
      modo4DXActual: _modo4DX,
      onFeedback: _mostrarFeedback,
      onXpChanged: (nuevoXp) => setState(() => _xpDuolingo = nuevoXp),
      on4DXChanged: (nuevo4dx) => setState(() => _modo4DX = nuevo4dx),
      onAbrirEditorJson: _abrirEditorJsonPantallaActual,
      onSincronizar: _cargarPantallasDesdeSupabase,
    );
  }

  void _abrirEditorJsonPantallaActual() {
    if (_pantallasSduiJson.isEmpty) return;
    final Map regActual = Map.from(_pantallasSduiJson[_indicePantallaActiva] as Map);
    ModalesCandadoYEditor.abrirModalEditorJson(
      context: context,
      contratoActual: regActual,
      alActualizarContrato: (nuevoReg) {
        setState(() {
          _pantallasSduiJson[_indicePantallaActiva] = nuevoReg;
        });
        _mostrarFeedback('✅ JSON actualizado en caliente.');
      },
      alMostrarFeedback: _mostrarFeedback,
    );
  }

  Widget _renderizarBloqueCon24Microservicios(Map comp, double anchoPantalla) {
    if (comp['pertenece_a_tab'] != null && comp['campo_estado_tab'] != null) {
      final String campoTab = comp['campo_estado_tab'].toString();
      final String tabRequerida = comp['pertenece_a_tab'].toString();
      final String tabPorDefecto = comp['tab_por_defecto']?.toString() ?? tabRequerida;
      final String tabActual = _estadoForm[campoTab]?.toString() ?? tabPorDefecto;
      if (tabActual != tabRequerida) {
        return const SizedBox.shrink();
      }
    }

    final String tipo = (comp['tipo']?.toString() ?? 'TARJETA_NEON').toUpperCase();

    return ejecutarConEscudoMicroservicio(tipo, () {
      switch (tipo) {
        case 'AVATAR_IA_BOLSILLO_VOZ':
        case 'RECORDATORIO_HABLADO_BOLSILLO':
          return Ms22AvatarIaBolsilloVoz(
            bloque: comp,
            onFeedback: _mostrarFeedback,
          );

        case 'SUITE_MOTORES_REALES_107':
        case 'ESCANER_QR_REAL':
        case 'MAPA_UBER_REAL':
        case 'VISOR_3D_AR_REAL':
        case 'CALENDARIO_CITAS_REAL':
        case 'POS_TERMICO_STRIPE_OCR':
          return Ms23MotoresRealesHardwareNegocio(
            bloque: comp,
            onFeedback: _mostrarFeedback,
          );

        case 'CONSOLA_JUEGOS_SDUI_24':
        case 'JUEGO_SDUI_UNIVERSAL':
          return Ms24ConsolaUniversalJuegosSdui(
            bloque: comp,
            onFeedback: _mostrarFeedback,
          );

        case 'MOTOR_SCHULTE_CHIMP_35':
          return Ms21JuegoSchulteChimp35(
            bloque: comp,
            onFeedback: _mostrarFeedback,
          );

        case 'HEADER_ORBE_JSON':
          return Ms20MotorAtomicoUniversalSdui.construirHeaderOrbeJson(
            b: comp,
            estadoForm: _estadoForm,
            onNavegarPantalla: _navegarAPantallaPorId,
            onDispararBoton: _dispararBotonSdui,
          );

        case 'HERO_NEON_JSON':
          return Ms20MotorAtomicoUniversalSdui.construirHeroNeonJson(comp);

        case 'TABS_SUBPANTALLAS_JSON':
          return Ms20MotorAtomicoUniversalSdui.construirBarraSubTabsJson(
            b: comp,
            estadoForm: _estadoForm,
            onActualizarCampo: (k, v) => setState(() => _estadoForm[k] = v),
          );

        case 'HEADER_IMPERIO':
          return Ms01HeaderYGrids.construirHeaderImperio(comp);

        case 'GRID_ICONOS_4_COL':
          return Ms01HeaderYGrids.construirGridIconos4Col(
            b: comp,
            anchoPantalla: anchoPantalla,
            onDispararBoton: _dispararBotonSdui,
            onFeedback: _mostrarFeedback,
          );

        case 'GRID_TARJETAS_2_COL':
          return Ms02CatalogoYDragDrop.construirGridTarjetas2Col(
            b: comp,
            anchoPantalla: anchoPantalla,
            onFeedback: _mostrarFeedback,
          );

        case 'DRAG_AND_DROP_LISTA':
          return Ms02CatalogoYDragDrop.construirDragAndDropLista(
            b: comp,
            onFeedback: _mostrarFeedback,
            onRefrescarUi: () => setState(() {}),
          );

        case 'CHAT_WECHAT_P2P':
          return Ms03WechatYCiencias.construirChatWechatP2P(
            b: comp,
            estadoForm: _estadoForm,
            onDispararBoton: _dispararBotonSdui,
          );

        case 'LAB_CIENCIAS':
          return Ms03WechatYCiencias.construirLabCiencias(
            b: comp,
            onFeedback: _mostrarFeedback,
          );

        case 'VISOR_AR_VR_360':
          return Ms04Cine4dxYArVr.construirVisorArVr360(
            b: comp,
            modoRealidad: _modoRealidad,
            offsetVrX: _offsetVrX,
            onDragVrX: (dx) => setState(() => _offsetVrX = (_offsetVrX + dx).clamp(-120.0, 120.0)),
            onCambiarModo: (m) => setState(() => _modoRealidad = m),
            onGuardarOffline: () => _mostrarFeedback('📥 Escena VR/AR guardada en Bunker Offline.'),
          );

        case 'UBER_MAPA_RADAR_GPS':
          return Ms05UberGpsYBinance.construirUberMapaRadarGps(comp);

        case 'BINANCE_CRIPTO_TRADING':
          return Ms05UberGpsYBinance.construirBinanceCriptoTrading(comp);

        case 'PIZARRA_TACTIL':
          return Ms06PizarraQrOptico.construirPizarraTactil(
            b: comp,
            trazosPizarra: _trazosPizarra,
            colorLapizActual: _colorLapiz,
            onCambiarColor: (c) => setState(() => _colorLapiz = c),
            onLimpiar: () => setState(() => _trazosPizarra.clear()),
            onIniciarTrazo: (pos) => setState(() => _trazosPizarra.add([pos])),
            onActualizarTrazo: (pos) => setState(() {
              if (_trazosPizarra.isNotEmpty) {
                (_trazosPizarra.last as List).add(pos);
              }
            }),
          );

        case 'MOTOR_JUEGO_COGNITIVO':
          return Ms07KahootLumosityIot.construirMotorJuegoCognitivo(
            b: comp,
            anchoPantalla: anchoPantalla,
            celdasLumosity: _celdasLumosity,
            arduinoLed1: _arduinoLed1,
            arduinoRele2: _arduinoRele2,
            onFeedback: _mostrarFeedback,
            onToggleLumosity: (idx) => setState(() {
              if (_celdasLumosity.contains(idx)) {
                _celdasLumosity.remove(idx);
              } else {
                _celdasLumosity.add(idx);
              }
            }),
            onToggleArduinoLed: (v) => setState(() => _arduinoLed1 = v),
            onToggleArduinoRele: (v) => setState(() => _arduinoRele2 = v),
            onDispararBoton: _dispararBotonSdui,
          );

        case 'LIENZO_WEBAR_HTML5':
        case 'CINE_CRISTAL_HTML5':
          return Ms08CineCristalHtml5.construirCineCristalHtml5(
            b: comp,
            episodioActual: _episodioCine,
            anchoPantalla: anchoPantalla,
            onCambiarEpisodio: (ep) => setState(() => _episodioCine = ep),
            onDispararBoton: _dispararBotonSdui,
          );

        case 'MOTOR_STAC_STITCH':
          return Ms10MotoresStacYJdw.construirMotorStacStitch(
            b: comp,
            anchoPantalla: anchoPantalla,
            onDispararBoton: _dispararBotonSdui,
          );

        case 'MOTOR_JSON_DYNAMIC_HIBRIDO':
          return Ms10MotoresStacYJdw.construirMotorJsonDynamicHibrido(
            b: comp,
            constructorMotorNativoPorNombre: (cfgMotor) =>
                _renderizarBloqueCon24Microservicios(cfgMotor, anchoPantalla),
            onDispararBoton: _dispararBotonSdui,
          );

        case 'STITCH_DISENO_1_EXACTO':
          return SizedBox(
            height: 780,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Ms11StitchDiseno1Muro(bloque: comp),
            ),
          );

        case 'STUDIO_PRD_RFC_45_NUBES':
          return Ms14StudioPrdRfcPdf(
            bloque: comp,
            onFeedback: _mostrarFeedback,
            onSincronizar: _cargarPantallasDesdeSupabase,
          );

        case 'TEORIA_3_LINKS':
          return Ms15Teoria3Links(onFeedback: _mostrarFeedback);

        case 'FABRICA_MULTI_APP':
          return Ms16FabricaMultiAppUsuarios(onFeedback: _mostrarFeedback);

        case 'DICCIONARIO_UXUI':
          return Ms17DiccionarioUxUiInteractivo(
            modoPantalla: comp['modo_diccionario']?.toString() ?? 'P3_BOTONES',
            onFeedback: _mostrarFeedback,
          );

        case 'APP_IMPERIO_CLON':
          return SizedBox(
            height: 760,
            child: Ms18AppImperioClon(
              onFeedback: _mostrarFeedback,
              onAbrirMotorAvanzado: (m, a) {
                setState(() {
                  _motorImperioActivo = m;
                  _argsMotorImperio = a;
                });
              },
            ),
          );

        case 'MOTORES_IMPERIO':
          return Ms19MotoresImperio(
            motorInicial: _motorImperioActivo,
            argsIniciales: _argsMotorImperio,
            onFeedback: _mostrarFeedback,
            onCerrar: () => _mostrarFeedback('Motor Imperio listo.'),
          );

        default:
          return InspectorStitchSdui.envolverConMarcoStitch(
            modoEditActivo: _modoAdminDesbloqueado,
            bloque: comp,
            indice: 0,
            totalBloques: 1,
            onZoomInspeccionar: () {},
            onSubirLugar: () {},
            onBajarLugar: () {},
            onQuitarComponente: () {},
            child: Ms09TarjetaNeonBase.construirTarjetaNeonBase(
              b: comp,
              anchoPantalla: anchoPantalla,
              estadoForm: _estadoForm,
              onActualizarCampo: (k, v) => setState(() => _estadoForm[k] = v),
              onDispararBoton: _dispararBotonSdui,
            ),
          );
      }
    });
  }

  Widget _construirPantallaDesdeRegistroJson(Map registroPantalla, int idx, double anchoPantalla) {
    return ejecutarConEscudoMicroservicio('SDUI_PANTALLA_${idx + 1}', () {
      final List bloques = (registroPantalla['componentes_json'] is List)
          ? List.from(registroPantalla['componentes_json'] as List)
          : [];

      return Container(
        color: hexAColor(registroPantalla['color_primario_pantalla']?.toString(), const Color(0xFF05050F)),
        child: SafeArea(
          child: RefreshIndicator(
            color: const Color(0xFF00F3FF),
            backgroundColor: const Color(0xFF0A0A1C),
            onRefresh: _cargarPantallasDesdeSupabase,
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                ...bloques.map((b) => _renderizarBloqueCon24Microservicios(Map.from(b as Map), anchoPantalla)),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double botPad = MediaQuery.of(context).padding.bottom;
    final double anchoPantalla = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF05050F),
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: _pantallasSduiJson.length,
              onPageChanged: (idx) {
                HapticFeedback.selectionClick();
                setState(() => _indicePantallaActiva = idx);
              },
              itemBuilder: (ctx, idx) {
                final Map reg = Map.from(_pantallasSduiJson[idx] as Map);
                return _construirPantallaDesdeRegistroJson(reg, idx, anchoPantalla);
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            width: 68,
            height: 68,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _toquesCandado++;
                if (_toquesCandado >= 5) {
                  _toquesCandado = 0;
                  ModalesCandadoYEditor.abrirCandadoNegroCamuflado(
                    context: context,
                    alDesbloquearAdmin: () {
                      setState(() => _modoAdminDesbloqueado = true);
                      _abrirEditorJsonPantallaActual();
                    },
                  );
                }
              },
            ),
          ),
          if (_feedback.isNotEmpty)
            Positioned(
              bottom: botPad + 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A1C),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF00FF66), width: 1.5),
                ),
                child: Text(
                  _feedback,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold, fontSize: 11.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}