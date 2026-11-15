import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Ms17DiccionarioUxUiInteractivo extends StatefulWidget {
  final String modoPantalla; // 'P3_BOTONES', 'P4_TEXTOS', 'P5_MENSAJES', 'P6_LISTAS_10B', 'P7_RADIOS_MARGENES'
  final Function(String) onFeedback;

  const Ms17DiccionarioUxUiInteractivo({
    super.key,
    required this.modoPantalla,
    required this.onFeedback,
  });

  @override
  State createState() => _Ms17DiccionarioUxUiInteractivoState();
}

class _Ms17DiccionarioUxUiInteractivoState extends State {
  final Set _checksLista = {0, 2};
  final Map _cantidadesLista = {0: 2, 1: 1, 2: 5};
  final Map _switchesLista = {0: true, 1: false, 2: true};
  String _radioSeleccionado = 'opcion_1';
  bool _switchGlobal = true;
  bool _checkGlobal = true;
  double _sliderValor = 50.0;
  double _margenDemo = 12.0;
  double _paddingDemo = 14.0;
  double _radioDemo = 14.0;
  String _busquedaTop10 = '';
  int _paginaCursor = 1;

  void _mostrarFichaComponente({
    required String nombreTecnico,
    required String nombreEspanol,
    required String queEs,
    required String paraQueSirve,
    required String promptEjemplo,
  }) {
    HapticFeedback.mediumImpact();
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
            const Icon(Icons.auto_awesome, color: Color(0xFFFBB400), size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$nombreTecnico ($nombreEspanol)',
                style: const TextStyle(color: Color(0xFFFBB400), fontSize: 13.5, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('📘 ¿QUÉ ES ESTE COMPONENTE?:', style: TextStyle(color: Color(0xFF00F3FF), fontSize: 11, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(queEs, style: const TextStyle(color: Color(0xFFD7E3FD), fontSize: 12, height: 1.35)),
              const Divider(color: Color(0xFF2A3549), height: 18),
              const Text('🎯 ¿PARA QUÉ SIRVE EN UX/UI Y LÓGICA?:', style: TextStyle(color: Color(0xFF00FF66), fontSize: 11, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(paraQueSirve, style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.35)),
              const Divider(color: Color(0xFF2A3549), height: 18),
              const Text('🤖 CÓMO PEDIRLO EN TUS PROMPTS O EN EL PRD/RFC:', style: TextStyle(color: Color(0xFFFFD795), fontSize: 11, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF030E21),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF295186)),
                ),
                child: SelectableText(
                  promptEjemplo,
                  style: const TextStyle(color: Color(0xFF00FF66), fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFBB400), foregroundColor: const Color(0xFF071326)),
            icon: const Icon(Icons.copy, size: 15),
            label: const Text('COPIAR NOMBRE Y PROMPT', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: '$nombreTecnico: $promptEjemplo'));
              (widget as Ms17DiccionarioUxUiInteractivo).onFeedback('📋 Copiado: $nombreTecnico');
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

  void _lanzarModalConfirmacionSiNo({
    required String titulo,
    required String pregunta,
    required bool esDestructivo,
  }) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF101C2F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: esDestructivo ? const Color(0xFFFFB4AB) : const Color(0xFF00FF66), width: 2),
        ),
        title: Row(
          children: [
            Icon(
              esDestructivo ? Icons.warning_amber_rounded : Icons.help_outline,
              color: esDestructivo ? const Color(0xFFFFB4AB) : const Color(0xFFFBB400),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        content: Text(
          pregunta,
          style: const TextStyle(color: Color(0xFFD7E3FD), fontSize: 13, height: 1.4),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white54)),
            onPressed: () {
              Navigator.pop(ctx);
              (widget as Ms17DiccionarioUxUiInteractivo).onFeedback('❌ El usuario eligió: NO (Operación cancelada de forma segura).');
            },
            child: const Text('NO, CANCELAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: esDestructivo ? const Color(0xFF93000A) : const Color(0xFF00C853),
              foregroundColor: Colors.white,
            ),
            icon: Icon(esDestructivo ? Icons.delete_forever : Icons.check_circle, size: 16),
            label: Text(
              esDestructivo ? 'SÍ, ELIMINAR' : 'SÍ, REGISTRAR AHORA',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              (widget as Ms17DiccionarioUxUiInteractivo).onFeedback(
                esDestructivo
                    ? '🗑️ Confirmado SÍ: Registro eliminado en Supabase.'
                    : '✅ Confirmado SÍ: Registro guardado en Supabase con éxito.',
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String modo = (widget as Ms17DiccionarioUxUiInteractivo).modoPantalla;
    if (modo == 'P3_BOTONES') return _construirPantalla3Botones();
    if (modo == 'P4_TEXTOS') return _construirPantalla4TextosLabels();
    if (modo == 'P5_MENSAJES') return _construirPantalla5MensajesSiNo();
    if (modo == 'P6_LISTAS_10B') return _construirPantalla6ListasY10MilMillones();
    return _construirPantalla7RadiosYMargenes();
  }

  Widget _construirPantalla3Botones() {
    final List botonesInfo = [
      {
        'ing': '1. ElevatedButton (Primary CTA)',
        'esp': 'Botón Elevado Principal',
        'color': 0xFFFBB400,
        'fg': 0xFF071326,
        'icono': Icons.rocket_launch,
        'queEs': 'Es el botón principal con relieve, sombra y color de alto contraste.',
        'sirve': 'Se usa para la acción más importante de toda la pantalla (Ej: Guardar Registro, Pagar, Blindar Bóveda, Lanzar Dado). Regla UX: Solo debe haber 1 botón principal por tarjeta.',
        'prompt': 'Coloca un ElevatedButton dorado (#FBB400) que al tocar ejecute el registro en Supabase.',
      },
      {
        'ing': '2. FilledButton (Tonal Button)',
        'esp': 'Botón Relleno Secundario',
        'color': 0xFF00509D,
        'fg': 0xFFFFFFFF,
        'icono': Icons.save_alt,
        'queEs': 'Botón sólido sin sombra pesada, con el color secundario o institucional de la app.',
        'sirve': 'Ideal para acciones importantes secundarias como "Mostrar en Tienda", "Ver Historial" o "Subir Comprobante".',
        'prompt': 'Agrega un FilledButton azul (#00509D) para abrir el comprobante.',
      },
      {
        'ing': '3. OutlinedButton (Ghost / Border Button)',
        'esp': 'Botón con Borde Transparente',
        'color': 0xFF142033,
        'fg': 0xFF00F3FF,
        'icono': Icons.tune,
        'queEs': 'Botón de fondo transparente o neutro rodeado por un borde fino de color.',
        'sirve': 'Se usa para acciones opcionales como "Cancelar", "Filtrar", "Transferir a Hincha" o "Ver Bases" sin competir con el botón principal.',
        'prompt': 'Coloca un OutlinedButton con borde cian (#00F3FF) para cancelar o filtrar.',
      },
      {
        'ing': '4. TextButton (Link Action Button)',
        'esp': 'Botón de Solo Texto',
        'color': 0xFF030E21,
        'fg': 0xFFA9C7FF,
        'icono': Icons.open_in_new,
        'queEs': 'Botón limpio sin caja ni borde exterior; solo muestra el texto interactivo.',
        'sirve': 'Se usa dentro de diálogos ("CERRAR", "OMITIR", "Olvidé mi PIN") o al pie de formularios.',
        'prompt': 'Pon un TextButton discreto para "Olvidé mi contraseña".',
      },
      {
        'ing': '5. IconButton (Circular Action)',
        'esp': 'Botón Redondo de Solo Ícono',
        'color': 0xFF1F2A3E,
        'fg': 0xFFFFB4AB,
        'icono': Icons.favorite,
        'queEs': 'Botón compacto circular que contiene únicamente un ícono vectorial.',
        'sirve': 'Se usa en barras superiores (Escudo, Cerrar, Buscar) o rieles estilo TikTok (Corazón Like, Comentarios, Compartir, Copiar QR).',
        'prompt': 'Agrega un IconButton circular con ícono de corazón que incremente el contador.',
      },
      {
        'ing': '6. FloatingActionButton (FAB)',
        'esp': 'Botón Flotante de Esquina',
        'color': 0xFF00C853,
        'fg': 0xFF071326,
        'icono': Icons.add,
        'queEs': 'Botón circular o extendido que flota sobre la esquina inferior derecha de la pantalla.',
        'sirve': 'Se usa para crear un elemento nuevo en cualquier momento (Ej: "+ Nuevo Cliente", "+ Nueva Venta", "+ Escáner Rápido").',
        'prompt': 'Coloca un FloatingActionButton verde en la esquina inferior derecha para crear un nuevo registro.',
      },
      {
        'ing': '7. Destructive Button (Danger CTA)',
        'esp': 'Botón Rojo de Eliminación / Rechazo',
        'color': 0xFF93000A,
        'fg': 0xFFFFDAD6,
        'icono': Icons.delete_forever,
        'queEs': 'Botón pintado en rojo semántico de peligro o rechazo.',
        'sirve': 'Exclusivo para acciones irreversibles como "Eliminar Cuenta", "Quemar Cupón", "Rechazar Comprobante" o "Anular Factura". Siempre debe abrir un diálogo Sí/No.',
        'prompt': 'Agrega un Destructive Button rojo (#93000A) que pregunte ¿Seguro Sí/No? antes de borrar.',
      },
      {
        'ing': '8. SegmentedButton / Toggle Pill',
        'esp': 'Botón Segmentado de Múltiples Opciones',
        'color': 0xFF295186,
        'fg': 0xFFFFD795,
        'icono': Icons.view_week,
        'queEs': 'Barra horizontal dividida en 2, 3 o 4 botones unidos donde solo uno queda iluminado.',
        'sirve': 'Perfecto para cambiar de vista o modo (Ej: "Admin Central | Tienda Aliada" o "1 Hora | 6 Horas | 24 Horas | Siempre").',
        'prompt': 'Usa un SegmentedButton de 2 opciones para alternar entre Modo Admin y Modo Tienda.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _cabeceraDiccionario(
          numeroPantalla: 'PANTALLA 3/8',
          titulo: '🔘 DICCIONARIO VISUAL DE BOTONES (TOCA CUALQUIERA)',
          subtitulo: 'Presiona cualquier botón para ver cómo se llama en inglés y español, para qué sirve y cómo pedírmelo.',
        ),
        ...botonesInfo.map((b) {
          final Map mb = Map.from(b as Map);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF142033),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF295186)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        mb['ing'].toString(),
                        style: const TextStyle(color: Color(0xFFFBB400), fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text(
                      mb['esp'].toString(),
                      style: const TextStyle(color: Color(0xFFA9C7FF), fontSize: 10.5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color((mb['color'] as num).toInt()),
                      foregroundColor: Color((mb['fg'] as num).toInt()),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFFFBB400), width: 1),
                      ),
                    ),
                    icon: Icon(mb['icono'] as IconData, size: 18),
                    label: Text(
                      'TOCAR PARA VER QUÉ ES: ${mb['esp']}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5),
                    ),
                    onPressed: () => _mostrarFichaComponente(
                      nombreTecnico: mb['ing'].toString(),
                      nombreEspanol: mb['esp'].toString(),
                      queEs: mb['queEs'].toString(),
                      paraQueSirve: mb['sirve'].toString(),
                      promptEjemplo: mb['prompt'].toString(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _construirPantalla4TextosLabels() {
    final List textosInfo = [
      {
        'ing': '1. Label / Input Field Label',
        'esp': 'Etiqueta de Campo (Label)',
        'muestra': 'NOMBRE COMPLETO DEL CLIENTE *',
        'estilo': const TextStyle(color: Color(0xFFA9C7FF), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8),
        'queEs': 'En inglés se llama "Label" (Etiqueta). Es el texto corto fijo que va arriba o dentro de una caja de texto.',
        'sirve': 'Le indica al usuario exactamente qué dato debe escribir en el campo (Ej: "Correo Electrónico", "PIN de 4 Dígitos", "Monto en Bs").',
        'prompt': 'Coloca un Label que diga "PIN DE 4 DÍGITOS" arriba del TextField.',
      },
      {
        'ing': '2. Hyperlink / Interactive Text Link',
        'esp': 'Texto Tipo Link (Enlace Clicable)',
        'muestra': '🔗 Ver términos, bases del sorteo o recuperar contraseña ↗',
        'estilo': const TextStyle(color: Color(0xFF00F3FF), fontSize: 13, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        'queEs': 'Es un texto subrayado y coloreado que funciona como un enlace al tocarlo.',
        'sirve': 'Sirve para abrir otra pantalla, abrir una página web externa o descargar un documento sin ocupar el espacio de un botón grande.',
        'prompt': 'Agrega un Text Link subrayado que al tocar abra las bases del sorteo.',
      },
      {
        'ing': '3. Display / Hero Title (H1)',
        'esp': 'Título Gigante de Impacto (H1)',
        'muestra': '480 PTS · SAN JOSÉ 1942',
        'estilo': const TextStyle(color: Color(0xFFFBB400), fontSize: 22, fontWeight: FontWeight.w900),
        'queEs': 'Es el texto de mayor tamaño y grosor de toda la pantalla (Encabezado H1 en Markdown).',
        'sirve': 'Se usa para mostrar saldos bancarios, contadores de reloj (05:42:18) o el título principal de la aplicación.',
        'prompt': 'Muestra el saldo del usuario en un Display H1 grande color oro (#FBB400).',
      },
      {
        'ing': '4. Section Headline (H2 / H3)',
        'esp': 'Subtítulo de Sección o Tarjeta',
        'muestra': 'Parlamento Santo · Asamblea en Vivo',
        'estilo': const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
        'queEs': 'Texto mediano en negrita que encabeza cada bloque o tarjeta.',
        'sirve': 'Separa visualmente los módulos de una pantalla para que el usuario escanee el contenido en segundos.',
        'prompt': 'Pon un Section Headline H2 que titule la tarjeta como "Mis Cupones Diarios".',
      },
      {
        'ing': '5. Body Text (Paragraph)',
        'esp': 'Texto de Párrafo o Descripción',
        'muestra': 'Sube tus comprobantes de aporte. Cada 10 Bs equivale a 1 tirada de dado cuántico para la tómbola.',
        'estilo': const TextStyle(color: Color(0xFFD7E3FD), fontSize: 12.5, height: 1.4),
        'queEs': 'Texto de lectura cómoda (12 a 14 px) con interlineado suave.',
        'sirve': 'Explica instrucciones, reglas de negocio o contenido de mensajes.',
        'prompt': 'Agrega un Body Text explicando las reglas del sorteo.',
      },
      {
        'ing': '6. Caption / Helper & Timestamp Text',
        'esp': 'Texto Pequeño de Ayuda o Fecha/Hora',
        'muestra': 'Expira: Hoy 23:59 • Auditado a las 06:01 AM',
        'estilo': const TextStyle(color: Color(0xFF8C919C), fontSize: 10.5),
        'queEs': 'Texto pequeño y grisáceo de baja prioridad visual.',
        'sirve': 'Muestra fechas, horas ("hace 5 min"), notas al pie o pistas debajo de una caja de texto.',
        'prompt': 'Debajo del nombre coloca un Caption gris con la hora del registro.',
      },
      {
        'ing': '7. Monospace / Token & Hash Text',
        'esp': 'Texto Técnico Monoespaciado (Códigos/QR)',
        'muestra': 'TOKEN: SJ-8821-QR  |  HASH: 0x9b42...1942SJ',
        'estilo': const TextStyle(color: Color(0xFF00FF66), fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold),
        'queEs': 'Texto donde cada letra y número ocupa exactamente el mismo ancho (fuente tipo consola).',
        'sirve': 'Indispensable para mostrar códigos de canje QR, números de serie de cupones, hashes criptográficos o código SQL/JSON.',
        'prompt': 'Muestra el número de serie del cupón en fuente Monospace verde.',
      },
      {
        'ing': '8. Badge / Status Pill Text',
        'esp': 'Etiqueta Flotante de Estado (Píldora)',
        'muestra': '[ 🟢 ACREDITADO ACTIVO · AL DÍA ]',
        'estilo': const TextStyle(color: Color(0xFF00FF66), fontSize: 10.5, fontWeight: FontWeight.w900),
        'queEs': 'Texto corto en mayúsculas encerrado dentro de una cápsula redondeada de color.',
        'sirve': 'Resalta el estado de un registro en una lista: "PAGADO", "PENDIENTE", "EN VIVO", "VIP" o "STOCK: 14/50".',
        'prompt': 'Al lado derecho del socio coloca un Badge verde que diga "AL DÍA".',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _cabeceraDiccionario(
          numeroPantalla: 'PANTALLA 4/8',
          titulo: '🔤 DICCIONARIO DE TEXTOS, LABELS Y LINKS',
          subtitulo: 'Toca cualquier tipo de texto para conocer su nombre técnico en inglés (Label, Link, Caption, Badge) y su función.',
        ),
        ...textosInfo.map((t) {
          final Map mt = Map.from(t as Map);
          return InkWell(
            onTap: () => _mostrarFichaComponente(
              nombreTecnico: mt['ing'].toString(),
              nombreEspanol: mt['esp'].toString(),
              queEs: mt['queEs'].toString(),
              paraQueSirve: mt['sirve'].toString(),
              promptEjemplo: mt['prompt'].toString(),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF142033),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF295186)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(mt['ing'].toString(), style: const TextStyle(color: Color(0xFFFBB400), fontSize: 11.5, fontWeight: FontWeight.w900)),
                      const Text('TOCAR INFO ℹ️', style: TextStyle(color: Color(0xFF00F3FF), fontSize: 9.5, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFF030E21), borderRadius: BorderRadius.circular(8)),
                    child: Text(mt['muestra'].toString(), style: mt['estilo'] as TextStyle),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _construirPantalla5MensajesSiNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _cabeceraDiccionario(
          numeroPantalla: 'PANTALLA 5/8',
          titulo: '💬 DICCIONARIO DE MENSAJES Y PREGUNTAS (SÍ / NO)',
          subtitulo: 'Presiona cada botón para ver en vivo cómo aparece el mensaje de confirmación y cómo se llama técnicamente.',
        ),
        _tarjetaMensajeInteractivo(
          nombreIngles: '1. Confirmation AlertDialog (Yes / No Dialog)',
          nombreEspanol: 'Ventana Modal de Confirmación ¿Registrar Sí o No?',
          descripcion: 'Bloquea el fondo y pregunta al usuario "¿Quieres registrar estos datos? [Sí / No]" antes de ejecutar un INSERT o cobro en Supabase.',
          colorBorde: const Color(0xFF00C853),
          textoBoton: '🟢 PROBAR DIÁLOGO: "¿QUIERES REGISTRAR? [SÍ / NO]"',
          onProbar: () => _lanzarModalConfirmacionSiNo(
            titulo: 'Confirmar Registro en Sistema',
            pregunta: '¿Estás seguro de que quieres registrar estos datos en la base de datos?\n\nSelecciona SÍ para guardar o NO para revisar.',
            esDestructivo: false,
          ),
        ),
        _tarjetaMensajeInteractivo(
          nombreIngles: '2. Destructive Confirm Dialog (Delete Warning)',
          nombreEspanol: 'Alerta Roja ¿Seguro que deseas Eliminar / Quemar?',
          descripcion: 'Estándar RFC obligatorio antes de borrar un cliente, anular una venta o quemar un premio QR de la Bóveda.',
          colorBorde: const Color(0xFFFFB4AB),
          textoBoton: '🔴 PROBAR ALERTA ROJA: "¿ELIMINAR REGISTRO? [SÍ / NO]"',
          onProbar: () => _lanzarModalConfirmacionSiNo(
            titulo: '⚠️ Advertencia de Eliminación',
            pregunta: '¿Estás seguro de que deseas ELIMINAR o QUEMAR este registro?\n\nEsta operación descontará el stock de forma permanente.',
            esDestructivo: true,
          ),
        ),
        _tarjetaMensajeInteractivo(
          nombreIngles: '3. ModalBottomSheet (Slide-Up Panel)',
          nombreEspanol: 'Panel Deslizable Inferior (Hoja Modal)',
          descripcion: 'Se desliza suavemente desde la parte inferior del celular para mostrar formularios rápidos, filtros o el Inspector de Diseño.',
          colorBorde: const Color(0xFF00F3FF),
          textoBoton: '🔵 PROBAR PANEL INFERIOR (BOTTOM SHEET)',
          onProbar: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF071326),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              builder: (ctx) => Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📱 ModalBottomSheet Activo', style: TextStyle(color: Color(0xFFFBB400), fontSize: 16, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    const Text('Este panel sube desde abajo sin perder de vista el contexto de la pantalla.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFBB400), foregroundColor: Colors.black),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('ENTENDIDO, CERRAR PANEL', style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        _tarjetaMensajeInteractivo(
          nombreIngles: '4. Toast / Floating Pill Notification',
          nombreEspanol: 'Mensaje Flotante Rápido (Toast Dorado)',
          descripcion: 'Aparece durante 2.5 segundos y desaparece solo sin obligar al usuario a tocar ningún botón (Ej: "Código QR copiado").',
          colorBorde: const Color(0xFFFBB400),
          textoBoton: '🟡 PROBAR MENSAJE FLOTANTE (TOAST)',
          onProbar: () => (widget as Ms17DiccionarioUxUiInteractivo).onFeedback('🔔 [TOAST ACTIVO]: ¡Operación guardada en 0.2 segundos!'),
        ),
        _tarjetaMensajeInteractivo(
          nombreIngles: '5. SnackBar with Undo Action',
          nombreEspanol: 'Barra Inferior con Botón "DESHACER"',
          descripcion: 'Muy usada en Gmail y WhatsApp: ejecuta la acción de inmediato pero le da 4 segundos al usuario para tocar "DESHACER".',
          colorBorde: const Color(0xFFA9C7FF),
          textoBoton: '🟣 PROBAR SNACKBAR CON BOTÓN "DESHACER"',
          onProbar: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF00509D),
                content: const Text('🗑️ Elemento archivado temporalmente.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                action: SnackBarAction(
                  label: 'DESHACER',
                  textColor: const Color(0xFFFBB400),
                  onPressed: () => (widget as Ms17DiccionarioUxUiInteractivo).onFeedback('↩️ Acción revertida con éxito (Undo).'),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _tarjetaMensajeInteractivo({
    required String nombreIngles,
    required String nombreEspanol,
    required String descripcion,
    required Color colorBorde,
    required String textoBoton,
    required VoidCallback onProbar,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF142033),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorBorde, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nombreIngles, style: TextStyle(color: colorBorde, fontSize: 12, fontWeight: FontWeight.w900)),
          Text(nombreEspanol, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(descripcion, style: const TextStyle(color: Color(0xFFC2C6D3), fontSize: 11.5, height: 1.35)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF030E21),
                foregroundColor: colorBorde,
                side: BorderSide(color: colorBorde),
                padding: const EdgeInsets.symmetric(vertical: 11),
              ),
              onPressed: onProbar,
              child: Text(textoBoton, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirPantalla6ListasY10MilMillones() {
    final int inicioRango = ((_paginaCursor - 1) * 10) + 1;
    final int finRango = _paginaCursor * 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _cabeceraDiccionario(
          numeroPantalla: 'PANTALLA 6/8',
          titulo: '🗂️ LISTAS, GRIDVIEW Y BUSCADOR TOP-10 (10,000M USUARIOS)',
          subtitulo: 'Conoce todos los tipos de contenedores y listas por su nombre real y prueba cómo buscar solo 10 registros entre 10 mil millones.',
        ),

        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF101C2F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00FF66), width: 1.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '⚡ 1. CURSOR PAGINATION LIST (TOP-10 PARA 10,000 MILLONES DE USUARIOS)',
                style: TextStyle(color: Color(0xFF00FF66), fontSize: 12, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              const Text(
                '¿Por qué nunca se congela? Porque jamás hace SELECT * de los 10,000,000,000 de filas (lo cual pesaría 1,862 GB). Usa un índice B-Tree y trae SOLO 10 FILAS (LIMIT 10 = 2.0 KB en 0.8 ms):',
                style: TextStyle(color: Color(0xFFD7E3FD), fontSize: 11, height: 1.35),
              ),
              const SizedBox(height: 8),
              TextField(
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFFBB400), size: 18),
                  hintText: 'Buscar entre 10,000,000,000 de usuarios (Trae solo Top 10)...',
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 11),
                  filled: true,
                  fillColor: const Color(0xFF030E21),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (v) => setState(() {
                  _busquedaTop10 = v.trim();
                  _paginaCursor = 1;
                }),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF030E21), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📊 Mostrando únicamente filas #$inicioRango al #$finRango de 10,000,000,000 (RAM usada: 2.0 KB):',
                      style: const TextStyle(color: Color(0xFFFBB400), fontSize: 10.5, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    ...List.generate(3, (i) {
                      final int idSim = inicioRango + i;
                      final String filtro = _busquedaTop10.isEmpty ? 'Usuario_Global' : _busquedaTop10;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• Cursor #$idSim ➔ ${filtro}_$idSim | Estado: ACTIVO | Consulta SQL: 0.8 ms',
                          style: const TextStyle(color: Color(0xFF00F3FF), fontSize: 10.5, fontFamily: 'monospace'),
                        ),
                      );
                    }),
                    const Text('  ... (+7 registros más de este bloque de 10)', style: TextStyle(color: Colors.white54, fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: _paginaCursor > 1 ? () => setState(() => _paginaCursor--) : null,
                    icon: const Icon(Icons.chevron_left, size: 16),
                    label: const Text('10 ANTERIORES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  Text('Bloque Cursor #$_paginaCursor', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFBB400), foregroundColor: Colors.black),
                    onPressed: () => setState(() => _paginaCursor++),
                    icon: const Icon(Icons.chevron_right, size: 16),
                    label: const Text('SIGUIENTES 10 (LIMIT 10)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF142033),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFBB400)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🔘 2. ACTION LISTVIEW (LISTA CON BOTONES INCLUIDOS EN CADA FILA)', style: TextStyle(color: Color(0xFFFBB400), fontSize: 11.5, fontWeight: FontWeight.w900)),
              const Text('Nombre técnico: ListView.builder + Row of Action Buttons. Cada fila tiene sus propios botones para cobrar, aprobar, sumar o borrar:', style: TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 8),
              ...List.generate(2, (i) {
                final int cant = (_cantidadesLista[i] as int?) ?? 1;
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFF030E21), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Producto #${i + 1} · Polera Oficial ($cant uds)',
                          style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => setState(() => _cantidadesLista[i] = (cant > 1 ? cant - 1 : 1)),
                            icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFFFB4AB), size: 18),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => setState(() => _cantidadesLista[i] = cant + 1),
                            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF00FF66), size: 18),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFBB400),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                            onPressed: () => _lanzarModalConfirmacionSiNo(
                              titulo: 'Confirmar Cobro de Fila #${i + 1}',
                              pregunta: '¿Quieres registrar el cobro de $cant unidades de Producto #${i + 1}?',
                              esDestructivo: false,
                            ),
                            child: const Text('COBRAR', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF142033),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF00F3FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('⌨️ 3. INLINE INPUT LISTVIEW (LISTA CON TEXTO EDITABLE INCLUIDO)', style: TextStyle(color: Color(0xFF00F3FF), fontSize: 11.5, fontWeight: FontWeight.w900)),
              const Text('Nombre técnico: ListView + Inline TextField. Permite escribir precios, notas o calificaciones directamente dentro de cada fila sin abrir otra pantalla:', style: TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 8),
              ...['Socio #1942 · Cuota Bs:', 'Socio #1842 · Observación:'].map((lbl) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(lbl, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold))),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 34,
                            child: TextField(
                              style: const TextStyle(color: Color(0xFFFBB400), fontSize: 11.5),
                              decoration: InputDecoration(
                                hintText: 'Escribe aquí directo en la lista...',
                                hintStyle: const TextStyle(color: Colors.white38, fontSize: 10),
                                filled: true,
                                fillColor: const Color(0xFF030E21),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF142033),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFA9C7FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('☑️ 4. CHECKBOX & SWITCH LISTTILE (LISTA CON TIQUEO E INTERRUPTOR)', style: TextStyle(color: Color(0xFFA9C7FF), fontSize: 11.5, fontWeight: FontWeight.w900)),
              const Text('Nombre técnico: CheckboxListTile & SwitchListTile. Permite marcar múltiples filas para procesarlas en lote o encender/apagar permisos:', style: TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 6),
              ...List.generate(3, (i) {
                final bool chk = _checksLista.contains(i);
                final bool sw = (_switchesLista[i] as bool?) ?? false;
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(color: const Color(0xFF030E21), borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    dense: true,
                    leading: Checkbox(
                      value: chk,
                      activeColor: const Color(0xFFFBB400),
                      checkColor: Colors.black,
                      onChanged: (_) => setState(() => chk ? _checksLista.remove(i) : _checksLista.add(i)),
                    ),
                    title: Text('Permiso Módulo #${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
                    trailing: Switch(
                      value: sw,
                      activeColor: const Color(0xFF00FF66),
                      onChanged: (v) => setState(() => _switchesLista[i] = v),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF142033),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFBB400)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('💡 5. ¿QUÉ MÁS SE PUEDE INTRODUCIR EN LAS LISTAS Y EN UN GRIDVIEW?', style: TextStyle(color: Color(0xFFFBB400), fontSize: 11.5, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.75,
                children: [
                  _itemGridExplicativo('GridView (Mosaico)', 'Tarjetas en 2, 3 o 4 columnas con foto, precio y botón.'),
                  _itemGridExplicativo('ExpansionTile', 'Fila acordeón que al tocar se abre y muestra sub-detalles.'),
                  _itemGridExplicativo('Dismissible (Swipe)', 'Deslizar la fila con el dedo para borrar o archivar.'),
                  _itemGridExplicativo('Progress ListTile', 'Barra de porcentaje (0% a 100%) dentro de cada fila.'),
                  _itemGridExplicativo('ReorderableListView', 'Mantener presionado y arrastrar para cambiar el orden.'),
                  _itemGridExplicativo('Avatar + Badge List', 'Foto redonda con punto verde online y contador de mensajes.'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _itemGridExplicativo(String titulo, String desc) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF030E21),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF295186)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(titulo, style: const TextStyle(color: Color(0xFF00F3FF), fontSize: 10.5, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(desc, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 9.5)),
        ],
      ),
    );
  }

  Widget _construirPantalla7RadiosYMargenes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _cabeceraDiccionario(
          numeroPantalla: 'PANTALLA 7/8',
          titulo: '📐 RADIO BUTTONS, CONTROLES Y MÁRGENES DE PANTALLA',
          subtitulo: 'Prueba la diferencia entre RadioButton, Checkbox, Switch y mueve los deslizadores para ver cómo actúan Margin, Padding y BorderRadius.',
        ),

        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF142033),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFBB400)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🔘 1. RADIO BUTTON (SELECCIÓN EXCLUSIVA: SOLO 1 OPCIÓN A LA VEZ)', style: TextStyle(color: Color(0xFFFBB400), fontSize: 11.5, fontWeight: FontWeight.w900)),
              const Text('A diferencia del Checkbox (donde puedes marcar varios), el RadioButton obliga a elegir una sola opción del grupo (Ej: "A Favor" o "En Contra"):', style: TextStyle(color: Colors.white70, fontSize: 11)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Opción A (A Favor)', style: TextStyle(color: Colors.white, fontSize: 11.5)),
                      value: 'opcion_1',
                      groupValue: _radioSeleccionado,
                      activeColor: const Color(0xFFFBB400),
                      onChanged: (v) => setState(() => _radioSeleccionado = v.toString()),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Opción B (En Contra)', style: TextStyle(color: Colors.white, fontSize: 11.5)),
                      value: 'opcion_2',
                      groupValue: _radioSeleccionado,
                      activeColor: const Color(0xFFFFB4AB),
                      onChanged: (v) => setState(() => _radioSeleccionado = v.toString()),
                    ),
                  ),
                ],
              ),
              const Divider(color: Color(0xFF2A3549)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _checkGlobal,
                        activeColor: const Color(0xFF00C853),
                        onChanged: (v) => setState(() => _checkGlobal = v ?? true),
                      ),
                      const Text('Checkbox (Casilla)', style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Switch (Interruptor)', style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
                      Switch(
                        value: _switchGlobal,
                        activeColor: const Color(0xFF00F3FF),
                        onChanged: (v) => setState(() => _switchGlobal = v),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: Color(0xFF2A3549)),
              Text('🎚️ Slider (Barra Deslizante de Rango): ${_sliderValor.round()}%', style: const TextStyle(color: Color(0xFFA9C7FF), fontSize: 11, fontWeight: FontWeight.bold)),
              Slider(
                value: _sliderValor,
                min: 0,
                max: 100,
                activeColor: const Color(0xFFFBB400),
                onChanged: (v) => setState(() => _sliderValor = v),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF142033),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF00F3FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📐 2. LABORATORIO EN VIVO: MARGIN (AFUERA) vs PADDING (ADENTRO) vs BORDER RADIUS', style: TextStyle(color: Color(0xFF00F3FF), fontSize: 11.5, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Container(
                color: const Color(0xFF030E21),
                child: Container(
                  margin: EdgeInsets.all(_margenDemo),
                  padding: EdgeInsets.all(_paddingDemo),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00509D),
                    borderRadius: BorderRadius.circular(_radioDemo),
                    border: Border.all(color: const Color(0xFFFBB400), width: 2),
                  ),
                  child: Text(
                    'CAJA DE PRUEBA UX/UI\n• Margin (Espacio exterior): ${_margenDemo.round()} px\n• Padding (Relleno interior): ${_paddingDemo.round()} px\n• BorderRadius (Esquinas): ${_radioDemo.round()} px',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('↔️ Margin (Espacio por fuera del borde): ${_margenDemo.round()} px', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Slider(value: _margenDemo, min: 0, max: 36, activeColor: const Color(0xFFFBB400), onChanged: (v) => setState(() => _margenDemo = v)),
              Text('📦 Padding (Espacio por dentro del borde): ${_paddingDemo.round()} px', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Slider(value: _paddingDemo, min: 4, max: 36, activeColor: const Color(0xFF00FF66), onChanged: (v) => setState(() => _paddingDemo = v)),
              Text('🔲 BorderRadius (Redondeo de las 4 esquinas): ${_radioDemo.round()} px', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Slider(value: _radioDemo, min: 0, max: 36, activeColor: const Color(0xFF00F3FF), onChanged: (v) => setState(() => _radioDemo = v)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cabeceraDiccionario({
    required String numeroPantalla,
    required String titulo,
    required String subtitulo,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF00509D), Color(0xFF142033), Color(0xFF071326)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFBB400), width: 1.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(numeroPantalla, style: const TextStyle(color: Color(0xFF00FF66), fontSize: 10.5, fontWeight: FontWeight.w900)),
              const Text('👈 Desliza 👉', style: TextStyle(color: Color(0xFFFFD795), fontSize: 10.5, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 4),
          Text(titulo, style: const TextStyle(color: Color(0xFFFBB400), fontSize: 13, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(subtitulo, style: const TextStyle(color: Color(0xFFD7E3FD), fontSize: 11)),
        ],
      ),
    );
  }
}