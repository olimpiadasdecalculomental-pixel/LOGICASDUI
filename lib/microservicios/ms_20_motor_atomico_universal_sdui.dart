import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/escudo_aislamiento.dart';
import '../nucleo/registro_imports_futuro_sdui.dart';


class Ms20MotorAtomicoUniversalSdui {
  static Widget construirHeaderOrbeJson({
    required Map b,
    required Map estadoForm,
    required Function(String) onNavegarPantalla,
    required Function(Map, Map) onDispararBoton,
  }) {
    final String logoTxt = b['logo_texto']?.toString() ?? 'ORBE';
    final String logoEmoji = b['logo_emoji']?.toString() ?? ' 🌍';
    final String colLogo = b['color_logo']?.toString() ?? '#00f3ff';
    final String socio = estadoForm['session_nombre']?.toString() ??
        b['socio_nombre']?.toString() ??
        'JEFE SUPREMO';
    final String rango = estadoForm['session_rango']?.toString() ??
        b['socio_rango']?.toString() ??
        'SUPERADMIN';
    final String online = b['online_txt']?.toString() ?? '5420';
    final String recomp = b['recompensas_txt']?.toString() ?? '315';
    final String puntos = estadoForm['session_saldo']?.toString() ??
        b['puntos_mto']?.toString() ??
        '9999999.00';
    final String tasaBs = b['tasa_bs']?.toString() ?? '6.86';
    final String tasaMto = b['tasa_mto']?.toString() ?? '100';
    final String destinoSalir = b['pantalla_salir']?.toString() ?? 'ORBE_01_LOGIN';

    final Color cLogo = hexAColor(colLogo, const Color(0xFF00F3FF));

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFF05050C),
        border: Border(bottom: BorderSide(color: Color(0xFF1A1A2E), width: 1.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    logoTxt,
                    style: TextStyle(
                      color: cLogo,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: cLogo, blurRadius: 10)],
                    ),
                  ),
                  Text(logoEmoji, style: const TextStyle(fontSize: 20)),
                ],
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onNavegarPantalla(destinoSalir);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0x1AFF0000),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFF0000), width: 1.5),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.power_settings_new, size: 16, color: Color(0xFFFF0000)),
                      SizedBox(width: 5),
                      Text(
                        'SALIR',
                        style: TextStyle(
                          color: Color(0xFFFF0000),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Socio: $socio',
                      style: const TextStyle(color: Color(0xFF00FFFF), fontSize: 11),
                    ),
                    Text(
                      rango,
                      style: const TextStyle(
                        color: Color(0xFF00FFFF),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '$online On line | ',
                          style: const TextStyle(
                            color: Color(0xFF00FF00),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '$recomp Recompensas',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFFFFF00),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'INVENTARIO:',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$puntos MTO',
                      style: const TextStyle(
                        color: Color(0xFF00FFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '1\$ = $tasaBs Bs | 1\$ = $tasaMto MTO',
                      style: const TextStyle(color: Color(0xFF00FFFF), fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget construirHeroNeonJson(Map b) {
    final String iconoEmoji = b['icono_emoji']?.toString() ?? '🦁';
    final String colorResplandorIcono = b['color_resplandor_icono']?.toString() ?? '#FFD700';
    final String titulo = b['titulo']?.toString() ?? 'MIS TALENTOS ORBE';
    final String colorTitulo = b['color_titulo']?.toString() ?? '#FF0033';
    final String subtitulo = b['subtitulo']?.toString() ?? 'M E J O R A   T U S   T A L E N T O S';

    final Color cGlowIcon = hexAColor(colorResplandorIcono, const Color(0xFFFFD700));
    final Color cTit = hexAColor(colorTitulo, const Color(0xFFFF0033));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            iconoEmoji,
            style: TextStyle(
              fontSize: 58,
              shadows: [Shadow(color: cGlowIcon, blurRadius: 16)],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cTit,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              shadows: [Shadow(color: cTit, blurRadius: 12)],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  static Widget construirBarraSubTabsJson({
    required Map b,
    required Map estadoForm,
    required Function(String, String) onActualizarCampo,
  }) {
    final String claveEstado = b['campo_estado_tab']?.toString() ?? 'tab_activa_default';
    final List pestanas = (b['pestanas'] as List?) ?? [];
    final String valorActual = estadoForm[claveEstado]?.toString() ??
        (pestanas.isNotEmpty ? (pestanas.first as Map)['id'].toString() : '');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A1C),
        border: Border(bottom: BorderSide(color: Color(0xFF333333))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: pestanas.map((raw) {
            final Map t = Map.from(raw as Map);
            final String idTab = t['id']?.toString() ?? '';
            final String label = t['texto']?.toString() ?? idTab;
            final Color col = hexAColor(t['color']?.toString(), const Color(0xFF00F3FF));
            final bool activa = valorActual == idTab;

            return InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onActualizarCampo(claveEstado, idTab);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: activa ? col : Colors.transparent,
                      width: 3.0,
                    ),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: activa ? col : const Color(0xFF666666),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  static void abrirModalUniversalDesdeJson({
    required BuildContext context,
    required Map configModal,
    required double anchoPantalla,
    required Map estadoForm,
    required Function(String, String) onActualizarCampo,
    required Function(Map, Map) onDispararBoton,
    required Function(String) onNavegarPantalla,
  }) {
    final String titulo = configModal['titulo']?.toString() ?? 'MODAL ORBE NEON';
    final String subtitulo = configModal['subtitulo']?.toString() ?? '';
    final Color colorNeon = hexAColor(configModal['color_borde']?.toString(), const Color(0xFF00FF66));
    final List inputs = (configModal['campos_input'] as List?) ?? [];
    final List chips = (configModal['selector_chips'] as List?) ?? [];
    final List itemsLista = (configModal['items_lista'] as List?) ?? [];
    final List botones = (configModal['botones'] as List?) ?? [];
    final String? imagenUrl = configModal['imagen_url']?.toString();
    final String? qrValor = configModal['valor_qr']?.toString();

    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(220),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctxModal, setModalState) {
            return Dialog(
              backgroundColor: const Color(0xFF0A0A1C),
              insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorNeon, width: 2),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxHeight: 620),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        titulo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorNeon,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: colorNeon, blurRadius: 10)],
                        ),
                      ),
                      if (subtitulo.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          subtitulo,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                      const SizedBox(height: 14),
                      if (qrValor != null && qrValor.isNotEmpty)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: colorNeon, width: 3),
                            ),
                            child: SizedBox(
                              width: 170,
                              height: 170,
                              child: RegistroImportsFuturoSdui.construirQrVectorialReal(dataQr: qrValor, tamano: 150),
                            ),
                          ),
                        ),
                      if (imagenUrl != null && imagenUrl.isNotEmpty)
                        Container(
                          height: 240,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colorNeon, width: 1.5),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InteractiveViewer(
                            child: Image.network(
                              imagenUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(Icons.image, color: Colors.white54, size: 48),
                              ),
                            ),
                          ),
                        ),
                      if (chips.isNotEmpty) ...[
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: chips.map((c) {
                            final String txt = c.toString();
                            final String campo = configModal['campo_selector']?.toString() ?? 'p_modal_chip';
                            final bool sel = estadoForm[campo] == txt;
                            return ChoiceChip(
                              label: Text(
                                txt,
                                style: TextStyle(
                                  color: sel ? Colors.black : Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              selected: sel,
                              selectedColor: colorNeon,
                              backgroundColor: const Color(0xFF111111),
                              onSelected: (_) {
                                onActualizarCampo(campo, txt);
                                setModalState(() {});
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                      ],
                      ...inputs.map((rawInp) {
                        final Map m = Map.from(rawInp as Map);
                        final String campo = m['campo']?.toString() ?? 'p_input_modal';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextField(
                            obscureText: m['es_password'] == true,
                            keyboardType: m['teclado'] == 'numeric' ? TextInputType.number : TextInputType.text,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              labelText: m['titulo']?.toString(),
                              labelStyle: const TextStyle(color: Colors.white70, fontSize: 11),
                              hintText: m['placeholder']?.toString() ?? '',
                              hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                              filled: true,
                              fillColor: Colors.black,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: colorNeon),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: colorNeon, width: 2),
                              ),
                            ),
                            onChanged: (v) => onActualizarCampo(campo, v),
                          ),
                        );
                      }),
                      ...itemsLista.map((it) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111111),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF333333)),
                            ),
                            child: Text(
                              it.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
                            ),
                          )),
                      const SizedBox(height: 10),
                      ...botones.map((rawBtn) {
                        final Map mb = Map.from(rawBtn as Map);
                        final Color bg = hexAColor(mb['color']?.toString(), colorNeon);
                        final Color fg = hexAColor(mb['color_texto']?.toString(), Colors.black);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: bg,
                              foregroundColor: fg,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              Navigator.pop(ctx);
                              if (mb['pantalla_destino'] != null) {
                                if (mb['set_session_nombre'] != null) {
                                  onActualizarCampo('session_nombre', mb['set_session_nombre'].toString());
                                }
                                if (mb['set_session_rango'] != null) {
                                  onActualizarCampo('session_rango', mb['set_session_rango'].toString());
                                }
                                if (mb['set_session_saldo'] != null) {
                                  onActualizarCampo('session_saldo', mb['set_session_saldo'].toString());
                                }
                                onNavegarPantalla(mb['pantalla_destino'].toString());
                              } else {
                                onDispararBoton(mb, configModal);
                              }
                            },
                            child: Text(
                              mb['texto']?.toString() ?? 'CONFIRMAR',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        );
                      }),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          '❌ CERRAR MODAL',
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}