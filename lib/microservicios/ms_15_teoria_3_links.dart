import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Ms15Teoria3Links extends StatefulWidget {
  final Function(String) onFeedback;
  const Ms15Teoria3Links({super.key, required this.onFeedback});

  @override
  State createState() => _Ms15Teoria3LinksState();
}

class _Ms15Teoria3LinksState extends State {
  int _idxLink = 0;

  static const List _capitulos3Links = [
    {
      'badge': 'LINK 1 · ATLASSIAN AGILE PRD',
      'url': 'https://www.atlassian.com/agile/product-management/requirements',
      'titulo': '1. Product Requirements Document (PRD Ágil de Atlassian)',
      'color': 0xFFFBB400,
      'teoria_pura':
          'Según la metodología oficial de Atlassian (creadores de Jira y Confluence), un documento de requisitos ágil (PRD) NO es un contrato rígido de 300 páginas, sino una "comprensión compartida" que responde QUÉ vamos a construir, PARA QUIÉN (Roles/Personas) y POR QUÉ.\n\n'
          'En lugar de adivinar código, primero se definen las Personas (Usuarios), luego sus Historias de Usuario y finalmente los Criterios de Aceptación.',
      'pilares': [
        '🎯 1. Propósito y Visión del Producto: Qué problema real resuelve la aplicación y qué métrica define el éxito.',
        '👥 2. Roles de Usuario (Personas): Lista exacta de quiénes entran a la app (Ej. Invitado sin login, Cliente VIP, Cajero, Administrador) y qué permisos tiene cada uno.',
        '📖 3. Fórmula de Historias de Usuario: "Como [Rol de Usuario], quiero [Habilidad / Acción] para [Beneficio / Resultado esperado]".',
        '✅ 4. Fórmula de Criterios de Aceptación (Gherkin): "DADO QUE [Contexto inicial], CUANDO [El usuario toca o ejecuta X], ENTONCES [El sistema valida y muestra Y]".',
        '🎨 5. Diseño UX/UI Conectado: Qué componentes exactos (Botones, Labels, Listas, Mensajes Sí/No) ve el usuario en pantalla.',
        '🚫 6. Fuera de Alcance (Out of Scope): Qué funciones NO se programarán en esta fase para proteger el tiempo del proyecto.',
      ],
      'plantilla_copiable': '''# PRD ÁGIL (ESTÁNDAR ATLASSIAN)
## 1. Visión de la App
- **Nombre de la App:** [Nombre]
- **Objetivo Principal:** [Qué resuelve]

## 2. Roles de Usuario (Personas)
- **Rol 1 (Invitado):** Explora catálogo sin login.
- **Rol 2 (Usuario Registrado):** Compra, transfiere y guarda favoritos.
- **Rol 3 (Administrador):** Audita pagos y exporta reportes PDF.

## 3. Historias de Usuario y Criterios
- **Historia:** Como [Rol], quiero [Acción] para [Beneficio].
- **Criterio:** DADO QUE [Condición], CUANDO [Disparador], ENTONCES [Respuesta].''',
    },
    {
      'badge': 'LINK 2 · MARKDOWN GUIDE SYNTAX',
      'url': 'https://www.markdownguide.org/basic-syntax/',
      'titulo': '2. Sintaxis Básica y Extendida de Markdown (Lenguaje IA y PDF)',
      'color': 0xFF00F3FF,
      'teoria_pura':
          'Según la Guía Oficial de Markdown (markdownguide.org), Markdown es el lenguaje de marcado ligero universal para escribir documentación técnica, PRDs, RFCs, archivos README de GitHub y prompts de Inteligencia Artificial.\n\n'
          'Su ventaja teórica y práctica es que se puede leer como texto plano sin etiquetas pesadas y se transforma automáticamente en libros PDF, páginas web y esquemas de bases de datos.',
      'pilares': [
        '🔠 1. Encabezados Jerárquicos (# H1 a ###### H6): "# Título de la App", "## Módulo o Pantalla", "### Rol de Usuario o Componente".',
        '✨ 2. Énfasis Semántico: "**Negrita**" para nombres de botones y actores obligatorios; "*Cursiva*" para estados y notas.',
        '☑️ 3. Listas y Checklists Interactivas: "- [x] Requisito completado" y "- [ ] Requisito pendiente de programar".',
        '💻 4. Código en Línea y Bloques Cercados: "`GridView`" o "`TextField`" entre comillas invertidas simples, y bloques completos con triple comilla (```sql o ```json).',
        '💬 5. Citas y Alertas (> Blockquote): "> Nota Crítica: Todo buscador masivo debe usar LIMIT 10".',
        '📊 6. Tablas Estructuradas: Columnas separadas por barras verticales (|) para documentar diccionarios de datos y roles.',
      ],
      'plantilla_copiable': '''# Nombre del Proyecto (H1)
## Especificación de Pantalla (H2)
### Componentes y Reglas (H3)

> **Regla de Oro:** Ninguna consulta debe descargar más de 10 filas sin paginación.

- [x] Definir Roles de Usuario
- [x] Diseñar Botones y Mensajes Sí/No
- [ ] Conectar Función RPC en Supabase

```json
{
  "componente": "ListView_Top10",
  "limite_filas": 10,
  "confirmar_accion": true
}
```''',
    },
    {
      'badge': 'LINK 3 · IETF RFC EDITOR',
      'url': 'https://www.rfc-editor.org/',
      'titulo': '3. Request for Comments (RFC Editor · Ingeniería y Protocolos)',
      'color': 0xFF00C853,
      'teoria_pura':
          'El RFC Editor (rfc-editor.org) es la institución oficial que publica los estándares técnicos de Internet (como HTTP, TCP/IP, JSON RFC 8259 y las palabras clave de exigencia RFC 2119).\n\n'
          'Mientras el PRD (Link 1) explica QUÉ quiere el usuario desde el punto de vista de negocio, el RFC (Link 3) define CÓMO funciona la lógica técnica por dentro: qué tablas se crean, qué condiciones IF se validan, cómo viaja el JSON y cómo resiste 10,000 millones de usuarios.',
      'pilares': [
        '⚖️ 1. Palabras Clave Normativas (RFC 2119): "MUST" (Debe hacerlo obligatoriamente), "MUST NOT" (Está prohibido), "SHOULD" (Recomendado) y "MAY" (Opcional).',
        '🔄 2. Máquina de Estados y Transacciones: Qué ocurre paso a paso desde que el usuario toca un botón hasta que Supabase confirma el guardado.',
        '⚡ 3. Escalabilidad Masiva (10,000M de Usuarios): El protocolo MUST usar paginación por cursor indexado (LIMIT 10) en lugar de recorrer tablas completas.',
        '🛡️ 4. Consideraciones de Seguridad (Security Considerations): Todo RFC incluye una sección obligatoria de permisos por rol (RLS), encriptación de PIN y prevención de errores.',
        '📦 5. Contratos de Payload y Respuesta: Definición exacta de las llaves JSON de entrada (Request) y de salida (Response).',
        '🧯 6. Casos Borde e Idempotencia: Si el usuario presiona 2 veces seguidas el botón "Pagar", el servidor MUST procesar el cobro una sola vez.',
      ],
      'plantilla_copiable': '''RFC-2026: PROTOCOLO TÉCNICO DE APLICACIÓN
Estado: Estándar de Ingeniería Activo

1. RESUMEN (ABSTRACT)
Especificación técnica de lógica, tablas y seguridad para la aplicación.

2. REGLAS NORMATIVAS (RFC 2119)
- El sistema MUST validar la sesión o PIN antes de modificar saldos.
- Las listas de búsqueda MUST NOT retornar más de 10 registros por página (LIMIT 10).
- Toda acción destructiva MUST mostrar un diálogo de confirmación [Sí / No].

3. CONTRATO DE DATOS (JSON / SQL)
Entrada: {"id_usuario": "USR_01", "accion": "REGISTRAR", "confirmado": true}
Salida:  {"exito": true, "codigo": 200, "mensaje": "Transacción completada"}''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Map cap = Map.from(_capitulos3Links[_idxLink] as Map);
    final Color colAcento = Color((cap['color'] as num).toInt());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00509D), Color(0xFF142033), Color(0xFF071326)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFBB400), width: 1.8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '📚 PANTALLA 1/8 · TEORÍA PURA DE LOS 3 LINKS (PRD + MARKDOWN + RFC)',
                      style: TextStyle(color: Color(0xFFFBB400), fontSize: 13, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Text('Desliza 👉', style: TextStyle(color: Color(0xFF00FF66), fontSize: 11, fontWeight: FontWeight.w900)),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Base teórica de ingeniería para crear múltiples aplicaciones profesionales. Desliza hacia la derecha para ir a la Fábrica de Apps y al Diccionario UX/UI.',
                style: TextStyle(color: Color(0xFFD7E3FD), fontSize: 11),
              ),
            ],
          ),
        ),
        Row(
          children: List.generate(_capitulos3Links.length, (i) {
            final bool sel = _idxLink == i;
            final List nombresCortos = ['📘 1. Atlassian PRD', '📝 2. Markdown Guide', '⚙️ 3. RFC Editor'];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i == 2 ? 0 : 6),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _idxLink = i);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    decoration: BoxDecoration(
                      color: sel ? const Color(0xFFFBB400) : const Color(0xFF142033),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: sel ? Colors.white : const Color(0xFF295186)),
                    ),
                    child: Text(
                      nombresCortos[i].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: sel ? const Color(0xFF071326) : Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF142033),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colAcento, width: 1.6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: colAcento, borderRadius: BorderRadius.circular(999)),
                child: Text(
                  cap['badge'].toString(),
                  style: const TextStyle(color: Color(0xFF071326), fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cap['titulo'].toString(),
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              SelectableText(
                'Fuente oficial: ${cap['url']}',
                style: const TextStyle(color: Color(0xFFA9C7FF), fontSize: 10.5, fontFamily: 'monospace'),
              ),
              const Divider(color: Color(0xFF2A3549), height: 18),
              const Text(
                '🧠 FUNDAMENTO TEÓRICO Y LÓGICO:',
                style: TextStyle(color: Color(0xFFFBB400), fontSize: 11.5, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                cap['teoria_pura'].toString(),
                style: const TextStyle(color: Color(0xFFD7E3FD), fontSize: 12, height: 1.4),
              ),
              const Divider(color: Color(0xFF2A3549), height: 18),
              const Text(
                '🏛️ LOS 6 PILARES OBLIGATORIOS DE ESTE ESTÁNDAR:',
                style: TextStyle(color: Color(0xFF00FF66), fontSize: 11.5, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              ...((cap['pilares'] as List?) ?? []).map((p) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF030E21),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colAcento.withAlpha(80)),
                    ),
                    child: Text(
                      p.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 11.5, height: 1.35),
                    ),
                  )),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '📋 PLANTILLA OFICIAL LISTA PARA USAR:',
                    style: TextStyle(color: Color(0xFFA9C7FF), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: cap['plantilla_copiable'].toString()));
                      (widget as Ms15Teoria3Links).onFeedback('📋 Plantilla oficial de ${cap['badge']} copiada al portapapeles.');
                    },
                    icon: const Icon(Icons.copy, size: 15, color: Color(0xFFFBB400)),
                    label: const Text('COPIAR PLANTILLA', style: TextStyle(color: Color(0xFFFBB400), fontSize: 10.5, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF030E21),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF295186)),
                ),
                child: SelectableText(
                  cap['plantilla_copiable'].toString(),
                  style: const TextStyle(color: Color(0xFF00FF66), fontFamily: 'monospace', fontSize: 11, height: 1.35),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}