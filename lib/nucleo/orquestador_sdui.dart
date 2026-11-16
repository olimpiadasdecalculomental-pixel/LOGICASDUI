import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'escudo_aislamiento.dart';
import 'puente_supabase_sdui.dart';
import 'despachador_acciones.dart';

class LienzoMaestroSdui extends StatefulWidget {
  const LienzoMaestroSdui({super.key});
  @override
  State createState() => _LienzoMaestroSduiState();
}

class _LienzoMaestroSduiState extends State with WidgetsBindingObserver {
  final PageController _pageCtrl = PageController();
  int _indicePantallaActiva = 0;
  bool _sincronizando = false;
  String _feedback = '';

  List _pantallasSduiJson = [
    {
      'id_pantalla': 'PANTALLA_01_LIENZO_BASE',
      'orden_pantalla': 1,
      'titulo_pestana': 'LIENZO SDUI EN VACIO (100% PANTALLA COMPLETA)',
      'rol_permitido': 'TODOS',
      'color_primario_pantalla': '#05050F',
      'ux_ui_diseno_texto': 'Pantalla 100% completa sin barra superior de botones. Fondo Cyber-Neon #05050F.',
      'logica_negocio_texto': 'Cada registro en esquema1.sdui_pantallas es 1 pantalla JSON independiente conectada a RPC + JSON Logic + Offline Sync.',
      'componentes_json': [
        {
          'id': 'card_base_limpia',
          'tipo': 'TARJETA_CYBER_NEON',
          'titulo': '🦁 ESQUEMA 1 EN LIMPIO · 100% PANTALLA COMPLETA',
          'subtitulo': 'Base reiniciada de cero con 88 Librerias activas y sin barra superior de botones. Lista para programar el Clon 1:1 de Mis Talentos Orbe.',
          'color_borde': '#00F3FF',
          'botones': [
            {
              'texto': '🔄 SINCRONIZAR PANTALLAS JSON DESDE SUPABASE (ESQUEMA 1)',
              'accion': 'EJECUTAR_RPC',
              'color': '#00FF66',
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
    setState(() => _sincronizando = true);
    final res = await PuenteSupabaseSdui.ejecutarRpcUniversal(
      'esq1_rpc_obtener_pantallas_json',
      {'p_id_admin': PuenteSupabaseSdui.idAdmin},
      esquemaOverride: 'esquema1',
    );
    if (!mounted) return;
    setState(() {
      _sincronizando = false;
      if (res['exito'] == true && res['pantallas'] is List && (res['pantallas'] as List).isNotEmpty) {
        _pantallasSduiJson = List.from(res['pantallas'] as List);
      }
    });
  }

  Widget _renderizarComponenteJson(Map comp, Map pantallaPadre) {
    final String titulo = comp['titulo']?.toString() ?? 'Bloque SDUI';
    final String subtitulo = comp['subtitulo']?.toString() ?? '';
    final List botones = (comp['botones'] is List) ? List.from(comp['botones'] as List) : [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A1C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00F3FF), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Color(0x3300F3FF), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Color(0xFF00F3FF),
              fontSize: 15,
              fontWeight: FontWeight.w900,
              shadows: [Shadow(color: Color(0xFF00F3FF), blurRadius: 8)],
            ),
          ),
          if (subtitulo.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subtitulo,
              style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
            ),
          ],
          if (botones.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: botones.map((b) {
                final Map mb = Map.from(b as Map);
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF66),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    DespachadorAccionesSdui.dispararAccion(
                      context: context,
                      btn: mb,
                      bloquePadre: comp,
                      estadoForm: {'id_pantalla': pantallaPadre['id_pantalla']},
                      xpDuolingoActual: 100,
                      modo4DXActual: true,
                      onFeedback: _mostrarFeedback,
                      onXpChanged: (_) {},
                      on4DXChanged: (_) {},
                      onAbrirEditorJson: () {},
                      onSincronizar: _cargarPantallasDesdeSupabase,
                    );
                  },
                  child: Text(
                    mb['texto']?.toString() ?? 'EJECUTAR RPC',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _construirPantallaDesdeRegistroJson(Map registroPantalla, int idx) {
    return ejecutarConEscudoMicroservicio('SDUI_PANTALLA_${idx + 1}', () {
      final List bloques = (registroPantalla['componentes_json'] is List)
          ? List.from(registroPantalla['componentes_json'] as List)
          : [];

      return Container(
        color: const Color(0xFF05050F),
        child: SafeArea(
          child: RefreshIndicator(
            color: const Color(0xFF00F3FF),
            backgroundColor: const Color(0xFF0A0A1C),
            onRefresh: _cargarPantallasDesdeSupabase,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A1C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF00FF66), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'REGISTRO JSON #${registroPantalla['orden_pantalla'] ?? (idx + 1)} · ${registroPantalla['id_pantalla']}',
                            style: const TextStyle(color: Color(0xFF00FF66), fontSize: 11, fontWeight: FontWeight.w900),
                          ),
                          InkWell(
                            onTap: _cargarPantallasDesdeSupabase,
                            child: Text(
                              _sincronizando ? 'SINCRONIZANDO...' : '🔄 SYNC SUPABASE',
                              style: const TextStyle(color: Color(0xFF00F3FF), fontSize: 10.5, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        registroPantalla['titulo_pestana']?.toString() ?? 'Pantalla SDUI',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rol: ${registroPantalla['rol_permitido'] ?? 'TODOS'} | Pantallas JSON en Esquema 1: ${_pantallasSduiJson.length} (Pantalla ${idx + 1})',
                        style: const TextStyle(color: Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      if ((registroPantalla['ux_ui_diseno_texto']?.toString() ?? '').isNotEmpty) ...[
                        const Divider(color: Color(0xFF222233), height: 18),
                        Text(
                          '🎨 UX/UI (PRD): ${registroPantalla['ux_ui_diseno_texto']}',
                          style: const TextStyle(color: Colors.white70, fontSize: 11.5),
                        ),
                      ],
                      if ((registroPantalla['logica_negocio_texto']?.toString() ?? '').isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          '⚙️ LOGICA (RFC/RPC): ${registroPantalla['logica_negocio_texto']}',
                          style: const TextStyle(color: Color(0xFFA9C7FF), fontSize: 11.5),
                        ),
                      ],
                    ],
                  ),
                ),
                ...bloques.map((b) => _renderizarComponenteJson(Map.from(b as Map), registroPantalla)),
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
                return _construirPantallaDesdeRegistroJson(reg, idx);
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