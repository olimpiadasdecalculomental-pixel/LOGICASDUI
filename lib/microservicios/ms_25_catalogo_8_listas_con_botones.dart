import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/puente_supabase_sdui.dart';
import '../nucleo/registro_imports_futuro_sdui.dart';

class Ms25Catalogo8ListasConBotones extends StatefulWidget {
  final Map bloque;
  final Function(String) onFeedback;

  const Ms25Catalogo8ListasConBotones({
    super.key,
    required this.bloque,
    required this.onFeedback,
  });

  @override
  State createState() => _Ms25Catalogo8ListasConBotonesState();
}

class _Ms25Catalogo8ListasConBotonesState extends State {
  int _idxLista = 0;
  int _paginaCursor = 1;
  String _busqueda = '';
  String _radioElegido = 'PLAN_PRO_30_MTO';

  final Map _cantidades = {0: 2, 1: 1, 2: 4, 3: 3};
  final Set _seleccionadosCheck = {0, 2};
  final Map _estadosSwitch = {0: true, 1: true, 2: false, 3: true};

  static const List _metadatos8Listas = [
    {
      'num': 1,
      'ing': '1. ActionButtonListView (ListView.builder + Action Buttons)',
      'esp': 'Lista con Botones de Accion Directa por Fila',
      'uso': 'Ideal para bandejas de aprobacion de pagos, recargas fisicas, pedidos delivery o solicitudes de amistad.',
      'color': 0xFF00FF66,
    },
    {
      'num': 2,
      'ing': '2. StepperQuantityListView (POS Cart & Inventory Stepper)',
      'esp': 'Lista de Carrito / Inventario con Botones [-] y [+]',
      'uso': 'Indispensable para Puntos de Venta (POS), restaurantes, supermercados y control de stock en vivo.',
      'color': 0xFF00F3FF,
    },
    {
      'num': 3,
      'ing': '3. CheckboxBatchListView (Multi-Select Checkbox ListTile)',
      'esp': 'Lista con Casillas Checkbox para Acciones por Lote',
      'uso': 'Permite tiquear varios alumnos, socios o productos al mismo tiempo y procesarlos con un solo boton.',
      'color': 0xFFFFD700,
    },
    {
      'num': 4,
      'ing': '4. SwitchToggleListView (SwitchListTile Real-Time Control)',
      'esp': 'Lista con Interruptores Switch ON/OFF Instantaneos',
      'uso': 'Se usa para encender/apagar permisos de roles, reles IoT Arduino, alertas de voz o reglas de negocio.',
      'color': 0xFFFF00FC,
    },
    {
      'num': 5,
      'ing': '5. RadioExclusiveListView (RadioListTile Single Choice)',
      'esp': 'Lista de Seleccion Unica Exclusiva (RadioButton)',
      'uso': 'Para elegir un unico Plan SaaS B2B, metodo de pago, sucursal o respuesta de examen.',
      'color': 0xFF00FF66,
    },
    {
      'num': 6,
      'ing': '6. AccordionExpansionListView (ExpansionTile Drawer List)',
      'esp': 'Lista Acordeon Desplegable con Cajon de Sub-Botones',
      'uso': 'Muestra filas limpias que al tocarse se abren hacia abajo revelando detalles tecnicos y botones.',
      'color': 0xFF00F3FF,
    },
    {
      'num': 7,
      'ing': '7. QuickToolbarCardList (Social & Financial Card List)',
      'esp': 'Lista de Tarjetas con Barra de Herramientas (Voz, Copiar, QR, Borrar)',
      'uso': 'Cada fila tiene una barra inferior con 4 botones de accion rapida y lectura por voz.',
      'color': 0xFFFFD700,
    },
    {
      'num': 8,
      'ing': '8. CursorPaginatedTop10List (B-Tree LIMIT 10 for 10,000M Rows)',
      'esp': 'Lista Paginada LIMIT 10 con Buscador (Escala 10,000 Millones)',
      'uso': 'Descarga solo 10 filas por pagina en 0.8 ms con botones Anterior/Siguiente y accion por fila.',
      'color': 0xFFFF00FC,
    },
  ];

  Future _ejecutarAccionLista(String op, String detalle) async {
    HapticFeedback.mediumImpact();
    await RegistroImportsFuturoSdui.hablarVozNativa(texto: detalle);
    (widget as Ms25Catalogo8ListasConBotones).onFeedback('✅ $detalle');
    await PuenteSupabaseSdui.ejecutarRpcUniversal(
      'esq1_rpc_guardar_app_o_usuario',
      {'p_operacion': op, 'p_detalle': detalle},
      esquemaOverride: 'esquema1',
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map meta = Map.from(_metadatos8Listas[_idxLista] as Map);
    final Color colAcento = Color((meta['color'] as num).toInt());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF070D1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colAcento, width: 1.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '🗂️ CATALOGO INTERACTIVO: LOS 8 TIPOS DE LISTAS CON BOTONES Y DATOS REALES',
            style: TextStyle(color: Color(0xFFFFD700), fontSize: 12.5, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Text(
            'Toca cualquiera de los 8 tipos de listas abajo para ver su nombre tecnico en ingles/español y probar sus botones con voz:',
            style: TextStyle(color: Colors.white70, fontSize: 10.5),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_metadatos8Listas.length, (i) {
                final Map m = Map.from(_metadatos8Listas[i] as Map);
                final bool sel = _idxLista == i;
                final Color c = Color((m['color'] as num).toInt());
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(
                      'Lista #${m['num']}',
                      style: TextStyle(color: sel ? Colors.black : Colors.white, fontSize: 10.5, fontWeight: FontWeight.w900),
                    ),
                    selected: sel,
                    selectedColor: c,
                    backgroundColor: const Color(0xFF142033),
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setState(() => _idxLista = i);
                      RegistroImportsFuturoSdui.hablarVozNativa(texto: m['esp'].toString());
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colAcento),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        meta['ing'].toString(),
                        style: TextStyle(color: colAcento, fontSize: 11.5, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: meta['ing'].toString()));
                        (widget as Ms25Catalogo8ListasConBotones).onFeedback('📋 Nombre copiado: ${meta['ing']}');
                      },
                      child: const Icon(Icons.copy, color: Color(0xFFFFD700), size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(meta['esp'].toString(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text('💡 ¿Para que sirve?: ${meta['uso']}', style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          if (_idxLista == 0) _buildLista1AccionDirecta(),
          if (_idxLista == 1) _buildLista2StepperCantidad(),
          if (_idxLista == 2) _buildLista3CheckboxLote(),
          if (_idxLista == 3) _buildLista4SwitchToggle(),
          if (_idxLista == 4) _buildLista5RadioExclusivo(),
          if (_idxLista == 5) _buildLista6AcordeonDesplegable(),
          if (_idxLista == 6) _buildLista7ToolbarTarjetas(),
          if (_idxLista == 7) _buildLista8CursorTop10(),
        ],
      ),
    );
  }

  Widget _buildLista1AccionDirecta() {
    final List datos = [
      {'socio': 'Cliente Final (Fam 1)', 'detalle': 'Recarga ENTEL 50 Bs · PIN 8492', 'mto': '+728.86 MTO'},
      {'socio': 'Pollos El Negrito B2B', 'detalle': 'Liquidacion Escrow QR #B2B-849', 'mto': '+495.00 MTO'},
      {'socio': 'Colegio Simon Bolivar', 'detalle': 'Premio Olimpiada Calculo Mental', 'mto': '+100.00 MTO'},
      {'socio': 'Recargador Zona Norte', 'detalle': 'Compra Lote 20 Tarjetas TIGO', 'mto': '+2,500.00 MTO'},
    ];
    return Column(
      children: datos.map((d) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFF142033), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF00FF66).withAlpha(120))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d['socio']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
                  Text(d['detalle']!, style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
                  Text(d['mto']!, style: const TextStyle(color: Color(0xFF00FF66), fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.volume_up, color: Color(0xFF00F3FF), size: 20),
              onPressed: () => RegistroImportsFuturoSdui.hablarVozNativa(texto: '${d['socio']}, ${d['detalle']}'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF66), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
              onPressed: () => _ejecutarAccionLista('APROBAR_FILA_LISTA_1', 'Aprobado: ${d['socio']} (${d['mto']})'),
              child: const Text('APROBAR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildLista2StepperCantidad() {
    final List prods = [
      {'nom': '🍗 Combo Alitas BBQ Imperial', 'precio': 500},
      {'nom': '🍔 Hamburguesa Doble Queso Orbe', 'precio': 350},
      {'nom': '🎫 Tarjeta Fisica ENTEL 50 Bs', 'precio': 729},
      {'nom': '🍿 Pase VIP Streaming 10 Dias', 'precio': 100},
    ];
    int totalMto = 0;
    for (int i = 0; i < prods.length; i++) {
      totalMto += ((prods[i]['precio'] as int) * ((_cantidades[i] as int?) ?? 0));
    }
    return Column(
      children: [
        ...List.generate(prods.length, (i) {
          final int cant = (_cantidades[i] as int?) ?? 0;
          final int pr = prods[i]['precio'] as int;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF142033), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF00F3FF))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prods[i]['nom'].toString(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      Text('$pr MTO c/u · Subtotal: ${pr * cant} MTO', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 10.5)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                      onPressed: () => setState(() => _cantidades[i] = cant > 0 ? cant - 1 : 0),
                    ),
                    Text('$cant', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900)),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Color(0xFF00FF66)),
                      onPressed: () => setState(() => _cantidades[i] = cant + 1),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00F3FF), foregroundColor: Colors.black),
          icon: const Icon(Icons.shopping_cart_checkout, size: 18),
          label: Text('CONFIRMAR PEDIDO STEPPER ($totalMto MTO)', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
          onPressed: () => _ejecutarAccionLista('GUARDAR_CARRITO_STEPPER', 'Pedido confirmado por $totalMto puntos MTO.'),
        ),
      ],
    );
  }

  Widget _buildLista3CheckboxLote() {
    final List items = [
      '🎒 Alumno #1: Matematicas Avanzadas (Nota: 100/100)',
      '🎒 Alumno #2: Robotica e IoT (Nota: 95/100)',
      '🎒 Alumno #3: Olimpiada Tabla Schulte 35 Nums (Record 18s)',
      '🎒 Alumno #4: Calculo Mental Vedico (Racha x12)',
    ];
    return Column(
      children: [
        ...List.generate(items.length, (i) {
          final bool marcado = _seleccionadosCheck.contains(i);
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(color: const Color(0xFF142033), borderRadius: BorderRadius.circular(10), border: Border.all(color: marcado ? const Color(0xFFFFD700) : Colors.white24)),
            child: CheckboxListTile(
              value: marcado,
              activeColor: const Color(0xFFFFD700),
              checkColor: Colors.black,
              title: Text(items[i], style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
              onChanged: (v) => setState(() => v == true ? _seleccionadosCheck.add(i) : _seleccionadosCheck.remove(i)),
            ),
          );
        }),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
          icon: const Icon(Icons.done_all, size: 18),
          label: Text('PREMIAR LOTE SELECCIONADO (${_seleccionadosCheck.length} ALUMNOS)', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
          onPressed: () => _ejecutarAccionLista('PREMIAR_LOTE_CHECKBOX', 'Premiados ${_seleccionadosCheck.length} alumnos seleccionados.'),
        ),
      ],
    );
  }

  Widget _buildLista4SwitchToggle() {
    final List reglas = [
      '🔊 Activar Voz del Avatar IA con el Celular en el Bolsillo',
      '🛡️ Escudo Anti-Trampas en Examenes Kahoot y Schulte 35',
      '🔒 Regenerar Codigo QR de Boveda Automaticamente cada 45s',
      '🤖 Encender Rele IoT Pin 13 (Placa Arduino / ESP32)',
    ];
    return Column(
      children: List.generate(reglas.length, (i) {
        final bool act = (_estadosSwitch[i] as bool?) ?? false;
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(color: const Color(0xFF142033), borderRadius: BorderRadius.circular(10), border: Border.all(color: act ? const Color(0xFFFF00FC) : Colors.white24)),
          child: SwitchListTile(
            value: act,
            activeColor: const Color(0xFF00FF66),
            title: Text(reglas[i], style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
            onChanged: (v) {
              setState(() => _estadosSwitch[i] = v);
              _ejecutarAccionLista('TOGGLE_SWITCH_LISTA', '${reglas[i]}: ${v ? "ACTIVADO" : "DESACTIVADO"}');
            },
          ),
        );
      }),
    );
  }

  Widget _buildLista5RadioExclusivo() {
    final List planes = [
      {'id': 'PLAN_BASICO_20_MTO', 't': '🏪 Plan Basico B2B (Cupo: 3 Productos · 20 MTO/Mes)'},
      {'id': 'PLAN_PRO_30_MTO', 't': '🚀 Plan Pro B2B (Cupo: 5 Productos + QR Escrow · 30 MTO/Mes)'},
      {'id': 'PLAN_ELITE_100_MTO', 't': '👑 Plan Elite Imperio (Cupo: 20 Productos + Destacado · 100 MTO/Mes)'},
      {'id': 'PLAN_COLEGIO_SIE', 't': '🎓 Licencia Institucional Colegio Mundo 3 (Aulas Ilimitadas)'},
    ];
    return Column(
      children: [
        ...planes.map((p) => Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(color: const Color(0xFF142033), borderRadius: BorderRadius.circular(10), border: Border.all(color: _radioElegido == p['id'] ? const Color(0xFF00FF66) : Colors.white24)),
          child: RadioListTile(
            value: p['id']!,
            groupValue: _radioElegido,
            activeColor: const Color(0xFF00FF66),
            title: Text(p['t']!, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
            onChanged: (v) => setState(() => _radioElegido = v.toString()),
          ),
        )),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF66), foregroundColor: Colors.black),
          onPressed: () => _ejecutarAccionLista('ACTIVAR_RADIO_PLAN', 'Plan seleccionado: $_radioElegido'),
          child: Text('ACTIVAR $_radioElegido', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
        ),
      ],
    );
  }

  Widget _buildLista6AcordeonDesplegable() {
    final List familias = [
      {'tit': '👑 Escalones 1 y 2: MayorAdmins y Admins de Zona', 'sub': 'Comision del 30% y 20% + Mesa de Verificacion con Lupa Fotografica.'},
      {'tit': '🛡️ Escalones 3 y 4: SubAdmins y Tiendas Recargadoras', 'sub': 'Auditoria de campo B2B (+100 MTO de bono) y Cajero P2P con Escaner QR.'},
      {'tit': '🎮 Escalon 5: Ciudadanos, Alumnos y Creadores VIP', 'sub': 'Acceso a 15 botones de ecosistema, Cine 4D, Mercado AR/VR y Juegos.'},
    ];
    return Column(
      children: familias.map((f) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: const Color(0xFF142033), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF00F3FF))),
        child: ExpansionTile(
          collapsedIconColor: const Color(0xFF00F3FF),
          iconColor: const Color(0xFF00FF66),
          title: Text(f['tit']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f['sub']!, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => RegistroImportsFuturoSdui.hablarVozNativa(texto: '${f['tit']}. ${f['sub']}'),
                        icon: const Icon(Icons.volume_up, color: Color(0xFFFFD700), size: 16),
                        label: const Text('ESCUCHAR', style: TextStyle(color: Color(0xFFFFD700), fontSize: 10.5)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00F3FF), foregroundColor: Colors.black),
                        onPressed: () => _ejecutarAccionLista('ABRIR_NODO_ACORDEON', 'Nodo activado: ${f['tit']}'),
                        child: const Text('EJECUTAR RPC', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildLista7ToolbarTarjetas() {
    final List cupones = [
      {'cod': 'ORBE-VIP-9942', 'nom': 'Polera Conmemorativa 1942 + Pase VR'},
      {'cod': 'B2B-8492019', 'nom': 'Combo Alitas BBQ (Escrow 500 MTO)'},
      {'cod': 'EXA-84920-M3', 'nom': 'Olimpiada 8 Inteligencias y Matematicas'},
    ];
    return Column(
      children: cupones.map((c) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFF142033), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFFFD700))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${c['nom']} · [${c['cod']}]', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
            const Divider(color: Colors.white24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () => RegistroImportsFuturoSdui.hablarVozNativa(texto: 'Cupon ${c['nom']}, codigo ${c['cod']}'),
                  icon: const Icon(Icons.volume_up, color: Color(0xFF00FF66), size: 16),
                  label: const Text('Voz', style: TextStyle(color: Color(0xFF00FF66), fontSize: 10.5)),
                ),
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: c['cod']!));
                    (widget as Ms25Catalogo8ListasConBotones).onFeedback('📋 Copiado: ${c['cod']}');
                  },
                  icon: const Icon(Icons.copy, color: Color(0xFF00F3FF), size: 16),
                  label: const Text('Copiar', style: TextStyle(color: Color(0xFF00F3FF), fontSize: 10.5)),
                ),
                TextButton.icon(
                  onPressed: () => _ejecutarAccionLista('CANJEAR_TOOLBAR_QR', 'Canjeado: ${c['cod']}'),
                  icon: const Icon(Icons.qr_code, color: Color(0xFFFFD700), size: 16),
                  label: const Text('Canjear', style: TextStyle(color: Color(0xFFFFD700), fontSize: 10.5)),
                ),
              ],
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildLista8CursorTop10() {
    final int ini = ((_paginaCursor - 1) * 10) + 1;
    return Column(
      children: [
        TextField(
          style: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Color(0xFFFF00FC), size: 18),
            hintText: 'Buscar en 10,000,000,000 de registros con LIMIT 10...',
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 11),
            filled: true,
            fillColor: Colors.black,
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (v) => setState(() => _busqueda = v),
        ),
        const SizedBox(height: 8),
        ...List.generate(5, (i) {
          final int nFila = ini + i;
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFF142033), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFF00FC).withAlpha(120))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '⚡ Cursor #$nFila · Socio ${_busqueda.isEmpty ? "ORBE-$nFila" : _busqueda.toUpperCase()} (0.8 ms)',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF00FC), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                  onPressed: () => _ejecutarAccionLista('SELECCIONAR_CURSOR_10', 'Registro #$nFila procesado.'),
                  child: const Text('VERIFICAR', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => _paginaCursor = _paginaCursor > 1 ? _paginaCursor - 1 : 1),
              child: const Text('◀ ANTERIOR 10', style: TextStyle(color: Color(0xFF00F3FF), fontSize: 10.5)),
            ),
            Text('Pagina #$_paginaCursor (LIMIT 10)', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold)),
            OutlinedButton(
              onPressed: () => setState(() => _paginaCursor++),
              child: const Text('SIGUIENTE 10 ▶', style: TextStyle(color: Color(0xFF00FF66), fontSize: 10.5)),
            ),
          ],
        ),
      ],
    );
  }
}