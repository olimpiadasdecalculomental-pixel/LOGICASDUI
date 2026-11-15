import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'puente_supabase_sdui.dart';

class DespachadorAccionesSdui {
  static Future dispararAccion({
    required BuildContext context,
    required Map btn,
    required Map bloquePadre,
    required Map estadoForm,
    required int xpDuolingoActual,
    required bool modo4DXActual,
    required Function(String) onFeedback,
    required Function(int) onXpChanged,
    required Function(bool) on4DXChanged,
    required Function() onAbrirEditorJson,
    required Future Function() onSincronizar,
  }) async {
    final String accion = btn['accion']?.toString() ?? 'EJECUTAR_RPC';

    if (accion == 'ABRIR_EDITOR_JSON_CALIENTE') {
      onAbrirEditorJson();
      return;
    }

    if (accion == 'EXPORTAR_PDF_CONTABILIDAD') {
      final tituloPdf = btn['titulo_pdf']?.toString() ?? 'Libro Maestro Multi-App: PRD + RFC + Usuarios + UX/UI (Esquema 1)';
      await generarYMostrarLibroPdfMultiApp(
        context: context,
        tituloPdf: tituloPdf,
        appsRegistradas: const [],
        rolesRegistrados: const [],
        onFeedback: onFeedback,
      );
      return;
    }

    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    final Map paramsFijos = Map.from((btn['parametros_fijos'] as Map?) ?? {});
    final Map payloadFinal = {...estadoForm, ...paramsFijos};
    onFeedback('⏳ Ejecutando en ${PuenteSupabaseSdui.esquemaActivo}...');
    final r = await PuenteSupabaseSdui.ejecutarRpcUniversal('esq1_rpc_guardar_app_o_usuario', {'p_payload': payloadFinal});
    onFeedback(r['mensaje']?.toString() ?? '✅ Operación completada en Esquema 1.');
    await onSincronizar();
  }

  static Future generarYMostrarLibroPdfMaestro({
    required BuildContext context,
    required String tituloPdf,
    required List itemsExtra,
    required Function(String) onFeedback,
  }) async {
    await generarYMostrarLibroPdfMultiApp(
      context: context,
      tituloPdf: tituloPdf,
      appsRegistradas: const [],
      rolesRegistrados: const [],
      onFeedback: onFeedback,
    );
  }

  static Future generarYMostrarLibroPdfMultiApp({
    required BuildContext context,
    required String tituloPdf,
    required List appsRegistradas,
    required List rolesRegistrados,
    required Function(String) onFeedback,
  }) async {
    onFeedback('⏳ Compilando Libro PDF Maestro (Apps + Roles de Usuario + PRD/RFC + Diccionario UX/UI)...');

    List listaApps = List.from(appsRegistradas);
    List listaRoles = List.from(rolesRegistrados);

    if (listaApps.isEmpty || listaRoles.isEmpty) {
      final resNube = await PuenteSupabaseSdui.ejecutarRpcUniversal(
        'esq1_rpc_obtener_todo_logicasdui',
        {},
        esquemaOverride: 'esquema1',
      );
      if (resNube['apps'] is List && (resNube['apps'] as List).isNotEmpty) {
        listaApps = List.from(resNube['apps'] as List);
      }
      if (resNube['roles_usuarios'] is List && (resNube['roles_usuarios'] as List).isNotEmpty) {
        listaRoles = List.from(resNube['roles_usuarios'] as List);
      }
    }

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(26),
        build: (pw.Context ctx) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              tituloPdf,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Paragraph(
            text: 'ESPECIFICACION COMPLETA BASADA EN: 1) Atlassian Agile PRD, 2) Markdown Guide Basic Syntax, 3) IETF RFC Editor (RFC 2119 MUST / MUST NOT).',
          ),
          pw.Header(level: 1, child: pw.Text('PARTE 1: APLICACIONES REGISTRADAS (${listaApps.length})')),
          ...listaApps.map((a) {
            final Map ma = Map.from(a as Map);
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey700)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('APP: ${ma['nombre_app'] ?? ma['id_app']}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  pw.Text('Industria: ${ma['categoria_industria'] ?? ''}', style: const pw.TextStyle(fontSize: 10)),
                  pw.Text('Objetivo PRD: ${ma['objetivo_vision_prd'] ?? ''}', style: const pw.TextStyle(fontSize: 10)),
                  pw.Text('Arquitectura RFC: ${ma['arquitectura_rfc_resumen'] ?? ''}', style: const pw.TextStyle(fontSize: 10)),
                  pw.Text('Escala Meta: ${ma['escala_usuarios_meta'] ?? '10,000M usuarios LIMIT 10'}', style: const pw.TextStyle(fontSize: 10)),
                  pw.Text('Notas: ${ma['notas_generales_app'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                ],
              ),
            );
          }),
          pw.Header(level: 1, child: pw.Text('PARTE 2: ROLES DE USUARIO Y ENTREVISTA EXHAUSTIVA (${listaRoles.length})')),
          ...listaRoles.map((r) {
            final Map mr = Map.from(r as Map);
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.blueGrey700)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('ROL: ${mr['nombre_rol']} (App: ${mr['id_app']})', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11.5)),
                  pw.Text('1. Login y Acceso: ${mr['metodo_login_acceso'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                  pw.Text('2. Habilidades Generales: ${mr['habilidades_que_hace'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                  pw.Text('3. Que Registra (INSERT): ${mr['que_registra_insert'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                  pw.Text('4. Que Consulta (SELECT Top-10): ${mr['que_consulta_select'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                  pw.Text('5. Que Modifica o Elimina: ${mr['que_modifica_elimina'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                  pw.Text('6. Transacciones y Pagos: ${mr['transacciones_y_pagos'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                  pw.Text('7. Impresiones y PDF: ${mr['impresiones_y_reportes'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                  pw.Text('8. Como Actua (Logica IF/THEN): ${mr['como_actua_logica_negocio'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                  pw.Text('9. Reglas RFC (MUST / MUST NOT): ${mr['reglas_rfc_must_mustnot'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                  pw.Text('10. Componentes UX/UI: ${mr['componentes_uxui_usados'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                  pw.Text('11. Notas Libres Extra: ${mr['notas_libres_extra'] ?? ''}', style: const pw.TextStyle(fontSize: 9.5)),
                ],
              ),
            );
          }),
          pw.Header(level: 1, child: pw.Text('PARTE 3: ARQUITECTURA DE LISTAS PARA 10,000 MILLONES DE USUARIOS')),
          pw.Bullet(text: 'Regla RFC de Paginacion: Jamas ejecutar SELECT * sin limite. Usar siempre Cursor Pagination con LIMIT 10 indexado por (created_at DESC, id_usuario DESC).'),
          pw.Bullet(text: 'Componentes de Lista: 1) ListView Simple, 2) ListView con Botones de Accion, 3) ListView con TextField en linea, 4) ListView con Checkbox, 5) ListView con Switch + Avatar + Badge, 6) GridView 2 a 4 columnas.'),
        ],
      ),
    );

    String rutaPdf = '';
    int bytesLen = 0;
    try {
      final bytes = await doc.save();
      bytesLen = bytes.length;
      final f = File('${Directory.systemTemp.path}/libro_maestro_multiapp_esquema1.pdf');
      await f.writeAsBytes(bytes);
      rutaPdf = f.path;
    } catch (_) {}

    final List lineasTexto = [
      '====================================================================',
      '📚 $tituloPdf',
      'Archivo PDF Binario Real (${(bytesLen / 1024).toStringAsFixed(1)} KB): $rutaPdf',
      '====================================================================',
      '',
      '--- 1. SÍNTESIS TEÓRICA DE LOS 3 LINKS OFICIALES ---',
      '• LINK 1 (Atlassian Agile PRD): Visión, Roles (Personas), Historias (Como [Rol] quiero [Acción] para [Beneficio]) y Criterios (Dado/Cuando/Entonces).',
      '• LINK 2 (Markdown Guide): # H1, ## H2, **Negrita**, `Código`, - [x] Checklists y bloques ```sql / ```json.',
      '• LINK 3 (IETF RFC Editor): Palabras normativas MUST, MUST NOT, SHOULD, MAY, Transacciones Atómicas y Seguridad RLS.',
      '',
      '--- 2. APLICACIONES REGISTRADAS (${listaApps.length}) ---',
      ...listaApps.map((a) {
        final Map ma = Map.from(a as Map);
        return '📱 APP: ${ma['nombre_app']}\n   • Industria: ${ma['categoria_industria']}\n   • Objetivo PRD: ${ma['objetivo_vision_prd']}\n   • Arquitectura RFC: ${ma['arquitectura_rfc_resumen']}\n   • Notas: ${ma['notas_generales_app']}\n';
      }),
      '--- 3. ENTREVISTA COMPLETA DE ROLES DE USUARIO (${listaRoles.length}) ---',
      ...listaRoles.map((r) {
        final Map mr = Map.from(r as Map);
        return '👤 ROL: ${mr['nombre_rol']} [App: ${mr['id_app']}]\n'
            '   1) Login/Acceso: ${mr['metodo_login_acceso']}\n'
            '   2) Habilidades: ${mr['habilidades_que_hace']}\n'
            '   3) Qué Registra (INSERT): ${mr['que_registra_insert']}\n'
            '   4) Qué Consulta (SELECT Top-10): ${mr['que_consulta_select']}\n'
            '   5) Qué Modifica/Elimina: ${mr['que_modifica_elimina']}\n'
            '   6) Transacciones/Pagos: ${mr['transacciones_y_pagos']}\n'
            '   7) Impresiones/PDF: ${mr['impresiones_y_reportes']}\n'
            '   8) Cómo Actúa (Lógica): ${mr['como_actua_logica_negocio']}\n'
            '   9) Reglas RFC (MUST/MUST NOT): ${mr['reglas_rfc_must_mustnot']}\n'
            '  10) Componentes UX/UI: ${mr['componentes_uxui_usados']}\n'
            '  11) Notas Libres: ${mr['notas_libres_extra']}\n';
      }),
    ];

    final String textoCopiable = lineasTexto.join('\n');
    onFeedback('📄 Libro PDF Multi-App compilado (${(bytesLen / 1024).toStringAsFixed(1)} KB).');

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF071326),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFFBB400), width: 2),
        ),
        title: Row(
          children: [
            const Icon(Icons.picture_as_pdf, color: Color(0xFFFBB400)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                tituloPdf,
                style: const TextStyle(color: Color(0xFFFBB400), fontSize: 13, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          height: 430,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF00509D), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '✅ Archivo PDF Generado (${(bytesLen / 1024).toStringAsFixed(1)} KB) · ${listaApps.length} Apps y ${listaRoles.length} Roles\nRuta: $rutaPdf',
                  style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF030E21),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF295186)),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      textoCopiable,
                      style: const TextStyle(color: Color(0xFFD7E3FD), fontSize: 11, fontFamily: 'monospace', height: 1.35),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFBB400), foregroundColor: const Color(0xFF071326)),
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('COPIAR LIBRO COMPLETO (APPS + ROLES + PRD/RFC)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: textoCopiable));
              onFeedback('📋 Especificación completa copiada al portapapeles.');
              Navigator.pop(ctx);
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CERRAR', style: TextStyle(color: Color(0xFFA9C7FF), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}