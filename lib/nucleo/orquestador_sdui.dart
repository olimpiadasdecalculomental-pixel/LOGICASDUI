import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'escudo_aislamiento.dart';
import 'puente_supabase_sdui.dart';
import 'despachador_acciones.dart';
import '../microservicios/ms_11_stitch_diseno_1_muro.dart';
import '../microservicios/ms_15_teoria_3_links.dart';
import '../microservicios/ms_16_fabrica_multi_app_usuarios.dart';
import '../microservicios/ms_17_diccionario_uxui_interactivo.dart';

class LienzoMaestroSdui extends StatefulWidget {
  const LienzoMaestroSdui({super.key});
  @override
  State createState() => _LienzoMaestroSduiState();
}

class _LienzoMaestroSduiState extends State with WidgetsBindingObserver {
  static const int _totalPantallasReales = 8;
  static const int _paginaInicialInfinita = 800; // 800 % 8 == 0 (Inicia en Pantalla 1)
  late final PageController _pageCtrl;
  int _indiceActual = 0;
  String _feedback = '';

  static const List _titulos8Pantallas = [
    '📚 1/8 · Teoría 3 Links (PRD + MD + RFC)',
    '🏭 2/8 · Creador Multi-App y Usuarios',
    '🔘 3/8 · Diccionario de Botones',
    '🔤 4/8 · Textos, Labels y Links',
    '💬 5/8 · Mensajes Sí / No y Modales',
    '🗂️ 6/8 · Listas, GridView y Top-10 (10,000M)',
    '📐 7/8 · RadioButton y Márgenes',
    '🎨 8/8 · Simulador Stitch 1:1 y PDF',
  ];

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: _paginaInicialInfinita);
    WidgetsBinding.instance.addObserver(this);
    PuenteSupabaseSdui.sincronizarConNube();
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

  void _irAPantalla(int idxDestino) {
    HapticFeedback.selectionClick();
    final int paginaActual = _pageCtrl.hasClients ? (_pageCtrl.page?.round() ?? _paginaInicialInfinita) : _paginaInicialInfinita;
    final int base = paginaActual - (paginaActual % _totalPantallasReales);
    _pageCtrl.animateToPage(
      base + idxDestino,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _construirPantallaPorIndice(int idxReal) {
    return ejecutarConEscudoMicroservicio('PANTALLA_${idxReal + 1}', () {
      switch (idxReal) {
        case 0:
          return Ms15Teoria3Links(onFeedback: _mostrarFeedback);
        case 1:
          return Ms16FabricaMultiAppUsuarios(onFeedback: _mostrarFeedback);
        case 2:
          return Ms17DiccionarioUxUiInteractivo(
            modoPantalla: 'P3_BOTONES',
            onFeedback: _mostrarFeedback,
          );
        case 3:
          return Ms17DiccionarioUxUiInteractivo(
            modoPantalla: 'P4_TEXTOS',
            onFeedback: _mostrarFeedback,
          );
        case 4:
          return Ms17DiccionarioUxUiInteractivo(
            modoPantalla: 'P5_MENSAJES',
            onFeedback: _mostrarFeedback,
          );
        case 5:
          return Ms17DiccionarioUxUiInteractivo(
            modoPantalla: 'P6_LISTAS_10B',
            onFeedback: _mostrarFeedback,
          );
        case 6:
          return Ms17DiccionarioUxUiInteractivo(
            modoPantalla: 'P7_RADIOS_MARGENES',
            onFeedback: _mostrarFeedback,
          );
        default:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF142033),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFBB400), width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        '🎨 PANTALLA 8/8 · VISTA STITCH 1:1 + LIBRO PDF MAESTRO',
                        style: TextStyle(color: Color(0xFFFBB400), fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853),
                        foregroundColor: const Color(0xFF071326),
                      ),
                      icon: const Icon(Icons.picture_as_pdf, size: 15),
                      label: const Text('DESCARGAR PDF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                      onPressed: () {
                        DespachadorAccionesSdui.generarYMostrarLibroPdfMultiApp(
                          context: context,
                          tituloPdf: 'Libro Maestro Multi-App: PRD + RFC + Usuarios + Diccionario UX/UI',
                          appsRegistradas: const [],
                          rolesRegistrados: const [],
                          onFeedback: _mostrarFeedback,
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 780,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: const Ms11StitchDiseno1Muro(
                    bloque: {
                      'id': 'logica_preview_stitch',
                      'tipo': 'STITCH_DISENO_1_EXACTO',
                      'header_titulo': 'SAN JOSÉ',
                      'header_anio': '1942',
                      'header_rango': 'ESQUEMA 1 ACTIVO',
                      'header_puntos': '350',
                    },
                  ),
                ),
              ),
            ],
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topPad = MediaQuery.of(context).padding.top;
    final double botPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF071326),
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: 10000,
              onPageChanged: (virtualIdx) {
                HapticFeedback.selectionClick();
                setState(() => _indiceActual = virtualIdx % _totalPantallasReales);
              },
              itemBuilder: (ctx, virtualIdx) {
                final int idxReal = virtualIdx % _totalPantallasReales;
                return ListView(
                  padding: EdgeInsets.only(
                    top: topPad + 38,
                    bottom: botPad + 28,
                    left: 12,
                    right: 12,
                  ),
                  children: [
                    _construirPantallaPorIndice(idxReal),
                  ],
                );
              },
            ),
          ),

          Positioned(
            top: topPad + 4,
            left: 8,
            right: 8,
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF030E21).withAlpha(225),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFF295186)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_totalPantallasReales, (i) {
                          final bool act = _indiceActual == i;
                          return GestureDetector(
                            onTap: () => _irAPantalla(i),
                            child: Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: act ? const Color(0xFFFBB400) : Colors.transparent,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                act ? _titulos8Pantallas[i].toString() : '${i + 1}',
                                style: TextStyle(
                                  color: act ? const Color(0xFF071326) : Colors.white70,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      DespachadorAccionesSdui.generarYMostrarLibroPdfMultiApp(
                        context: context,
                        tituloPdf: 'Libro Maestro Multi-App: PRD + RFC + Usuarios + UX/UI',
                        appsRegistradas: const [],
                        rolesRegistrados: const [],
                        onFeedback: _mostrarFeedback,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C853),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '📄 PDF',
                        style: TextStyle(color: Color(0xFF071326), fontSize: 9.5, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_feedback.isNotEmpty)
            Positioned(
              bottom: botPad + 20,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF142033).withAlpha(245),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFBB400), width: 1.5),
                ),
                child: Text(
                  _feedback,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFFFD795), fontWeight: FontWeight.bold, fontSize: 11.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}