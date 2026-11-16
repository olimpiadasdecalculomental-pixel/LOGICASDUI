import 'package:flutter/material.dart';

class Ms19MotoresImperio extends StatefulWidget {
  final String motorInicial;
  final Map<String, dynamic> argsIniciales;
  final Function(String) onFeedback;
  final VoidCallback onCerrar;

  const Ms19MotoresImperio({
    super.key,
    required this.motorInicial,
    required this.argsIniciales,
    required this.onFeedback,
    required this.onCerrar,
  });

  @override
  State<Ms19MotoresImperio> createState() => _Ms19MotoresImperioState();
}

class _Ms19MotoresImperioState extends State<Ms19MotoresImperio> {
  static const Color cCyan = Color(0xFF00F3FF);
  static const Color cMagenta = Color(0xFFFF00FC);
  static const Color cGreen = Color(0xFF00FF66);
  static const Color cDark = Color(0xFF05050F);
  static const Color cCard = Color(0xFF0A0A1C);
  static const Color cRed = Color(0xFFFF0033);
  static const Color cGold = Color(0xFFFFD700);

  late String _motorActivo;
  int _epCine = 0;
  String _vistaCine = 'CATALOGO';
  bool _modoVr = false;
  bool _modoAr = false;
  String _busquedaMercado = '';
  bool _viendoMiLista = false;

  final String _catPremio = 'COMIDA';
  final TextEditingController _ctrlTituloPremio = TextEditingController(text: 'COMBO ALITAS BBQ');
  final TextEditingController _ctrlEmpresaPremio = TextEditingController(text: 'El Negrito');
  final TextEditingController _ctrlColorPremio = TextEditingController(text: '#ff6600');
  final TextEditingController _ctrlCantPremio = TextEditingController(text: '10');

  double _reservaMto = 12500.0;
  final TextEditingController _ctrlTasaP2p = TextEditingController(text: '1');
  final TextEditingController _ctrlTasaCanje = TextEditingController(text: '3');
  final TextEditingController _ctrlTasaArcade = TextEditingController(text: '20');
  final TextEditingController _ctrlDescMayor = TextEditingController(text: '30');
  final TextEditingController _ctrlDescAdmin = TextEditingController(text: '20');
  final TextEditingController _ctrlDescRecargador = TextEditingController(text: '10');
  final TextEditingController _ctrlPase10 = TextEditingController(text: '100');
  final TextEditingController _ctrlPase20 = TextEditingController(text: '200');
  final TextEditingController _ctrlParental = TextEditingController(text: '40');

  String _subRolM3 = 'PROFESOR';
  final List> _aulasM3 = [
    {'id': 'aula_1', 'nombre_materia': 'Matematicas Avanzadas', 'nivel_grado': '5to Secundaria', 'codigo_acceso': 'MAT-X7B9'},
    {'id': 'aula_2', 'nombre_materia': 'Ciencias y Robotica', 'nivel_grado': '6to Primaria', 'codigo_acceso': 'CIE-K4P2'},
  ];
  final List> _examenesM3 = [
    {'id': 'exam_1', 'titulo': 'Olimpiada Logico-Matematica', 'tiempo_limite_minutos': 15, 'preguntas': 10},
  ];
  final int _puntosBovedaMto = 9999999;
  final List<String> _miPlaylist = ['dig-mock-1'];

  final List> _catalogoObras = [
    {
      'id': 'dig-mock-1',
      'titulo': 'Pista Epica (Aura Fuego)',
      'autor': 'DJ Orbe',
      'tipo': 'COMPOSITOR',
      'precio_mto': 5000,
      'likes': 1240,
      'portada': 'https://img.youtube.com/vi/tvNxjH4Yjy4/maxresdefault.jpg',
    },
    {
      'id': 'dig-mock-2',
      'titulo': 'Corto: Big Buck Bunny',
      'autor': 'Indie Films',
      'tipo': 'CINEASTA',
      'precio_mto': 10000,
      'likes': 3400,
      'portada': 'https://img.youtube.com/vi/eOrNdBpGMv8/maxresdefault.jpg',
    },
    {
      'id': 'dig-mock-3',
      'titulo': 'Naturaleza VR (Aura Hielo)',
      'autor': 'Dev Master',
      'tipo': 'CURSOS',
      'precio_mto': 50,
      'likes': 500,
      'portada': 'https://img.youtube.com/vi/h7Fysrwj8oA/maxresdefault.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _motorActivo = widget.motorInicial;
    if (widget.argsIniciales['cat'] != null) {
      _busquedaMercado = '';
    }
  }

  @override
  void dispose() {
    _ctrlTituloPremio.dispose();
    _ctrlEmpresaPremio.dispose();
    _ctrlColorPremio.dispose();
    _ctrlCantPremio.dispose();
    _ctrlTasaP2p.dispose();
    _ctrlTasaCanje.dispose();
    _ctrlTasaArcade.dispose();
    _ctrlDescMayor.dispose();
    _ctrlDescAdmin.dispose();
    _ctrlDescRecargador.dispose();
    _ctrlPase10.dispose();
    _ctrlPase20.dispose();
    _ctrlParental.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cDark,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cCyan, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'MOTOR IMPERIO: $_motorActivo | SALDO: $_puntosBovedaMto MTO',
                    style: const TextStyle(color: cCyan, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: cRed, foregroundColor: Colors.white),
                  onPressed: widget.onCerrar,
                  child: const Text('VOLVER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chipMotor('CINETV', 'ORBE CINE 4D/TV', cMagenta),
                _chipMotor('MERCADO', 'MERCADO AR/VR', cCyan),
                _chipMotor('PREMIOS', 'FABRICA PREMIOS', cGold),
                _chipMotor('REGLAS', 'REGLAS Y RESERVA', cGreen),
                _chipMotor('MUNDO3_PROFESOR', 'MUNDO 3 EDUCACION', cCyan),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_motorActivo == 'CINETV') _buildMotorCineTV(),
          if (_motorActivo == 'MERCADO') _buildMotorMercadoIntelectual(),
          if (_motorActivo == 'PREMIOS') _buildMotorFabricaPremios(),
          if (_motorActivo == 'REGLAS') _buildMotorReglasGlobales(),
          if (_motorActivo.startsWith('MUNDO3')) _buildMotorMundo3Educacion(),
        ],
      ),
    );
  }

  Widget _chipMotor(String id, String label, Color col) {
    final bool act = _motorActivo == id;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(color: act ? Colors.black : Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        selected: act,
        selectedColor: col,
        backgroundColor: cCard,
        onSelected: (_) => setState(() => _motorActivo = id),
      ),
    );
  }

  Widget _buildMotorCineTV() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: cMagenta)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ORBE CINE 4D / TV', style: TextStyle(color: cMagenta, fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _vistaCine == 'CATALOGO' ? cMagenta : Colors.black),
                    onPressed: () => setState(() => _vistaCine = 'CATALOGO'),
                    child: const Text('GLOBAL', style: TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _vistaCine == 'BOVEDA' ? cCyan : Colors.black),
                    onPressed: () => setState(() => _vistaCine = 'BOVEDA'),
                    child: const Text('BOVEDA VIP', style: TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 210,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0x660096FF)),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://img.youtube.com/vi/tvNxjH4Yjy4/maxresdefault.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.black),
                    ),
                  ),
                ),
                const Positioned(
                  top: 8,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ORBE IMPERIO', style: TextStyle(color: cGold, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('TV GLOBAL / CINE 4D', style: TextStyle(color: Colors.white, fontSize: 8)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 10,
                  right: 10,
                  child: Text(
                    'Nuera del Billonario - Ep. ${_epCine + 1} (Quedan 7 Dias VIP)',
                    style: const TextStyle(color: cCyan, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [0, 1, 2].map((idx) {
              final bool sel = _epCine == idx;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: sel ? cCyan : Colors.black),
                onPressed: () {
                  setState(() => _epCine = idx);
                  widget.onFeedback('Reproduciendo Ep. ${idx + 1} en ORBE CINE');
                },
                child: Text('Ep. ${idx + 1}', style: TextStyle(color: sel ? Colors.black : Colors.white, fontSize: 11)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorMercadoIntelectual() {
    final List> lista = _viendoMiLista
        ? _catalogoObras.where((o) => _miPlaylist.contains(o['id'])).toList()
        : _catalogoObras.where((o) {
            if (_busquedaMercado.trim().isEmpty) return true;
            final q = _busquedaMercado.toLowerCase();
            return o['titulo'].toString().toLowerCase().contains(q) ||
                o['autor'].toString().toLowerCase().contains(q);
          }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: cCyan)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MERCADO INTELECTUAL (AR / VR / DERECHOS)', style: TextStyle(color: cCyan, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: cCyan),
              hintText: 'Buscar obra o autor...',
              hintStyle: TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.black,
            ),
            onChanged: (v) => setState(() => _busquedaMercado = v),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _viendoMiLista ? cMagenta : Colors.black),
                onPressed: () => setState(() => _viendoMiLista = !_viendoMiLista),
                child: Text(_viendoMiLista ? 'Ver Orbe Global' : 'Mi Coleccion', style: const TextStyle(fontSize: 10, color: Colors.white)),
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _modoAr ? cGreen : Colors.black),
                    onPressed: () => setState(() {
                      _modoAr = !_modoAr;
                      _modoVr = false;
                    }),
                    child: const Text('CINE AR', style: TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _modoVr ? cCyan : Colors.black),
                    onPressed: () => setState(() {
                      _modoVr = !_modoVr;
                      _modoAr = false;
                    }),
                    child: const Text('MODO VR', style: TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...lista.map((obra) {
            final String idObra = obra['id'].toString();
            final bool enLista = _miPlaylist.contains(idObra);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8), border: Border.all(color: cMagenta)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('@${obra['autor']} - ${obra['titulo']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('Tipo: ${obra['tipo']} | Precio: ${obra['precio_mto']} MTO | Likes: ${obra['likes']}', style: const TextStyle(color: cCyan, fontSize: 11)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: cCyan, foregroundColor: Colors.black),
                        onPressed: () {
                          setState(() {
                            if (!enLista) _miPlaylist.add(idObra);
                          });
                          widget.onFeedback('Agregado a Mi Lista (1 MTO)');
                        },
                        child: Text(enLista ? 'En Coleccion' : 'Mi Lista 1(MTO)', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: cGold, foregroundColor: Colors.black),
                        onPressed: () => _confirmarCompraDerechos(obra['titulo'].toString()),
                        child: const Text('DERECHOS (5000 MTO)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _confirmarCompraDerechos(String tituloObra) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cCard,
        title: const Text('ATENCION INVERSOR', style: TextStyle(color: cGold, fontWeight: FontWeight.bold, fontSize: 13)),
        content: Text(
          'Comprar Derechos Comerciales de "$tituloObra"?\n1. Costo: 5,000 MTO.\n2. Ganaras el 80% de ventas futuras.\n3. El 15% ira como regalia al creador original y 5% reserva.',
          style: const TextStyle(color: Colors.white, fontSize: 11.5),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR', style: TextStyle(color: Colors.white70))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cGold, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              widget.onFeedback('Derechos adquiridos de "$tituloObra" (80% inversor / 15% creador / 5% reserva).');
            },
            child: const Text('COMPRAR'),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorFabricaPremios() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: cGold)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CREADOR DE PREMIOS FISICOS (CODIGO_MTO_PREMIO)', style: TextStyle(color: cGold, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _inputOscuro('Categoria (COMIDA, ROPA, TECNO):', _ctrlTituloPremio),
          _inputOscuro('Empresa Aliada:', _ctrlEmpresaPremio),
          _inputOscuro('Color HEX:', _ctrlColorPremio),
          _inputOscuro('Cantidad a crear:', _ctrlCantPremio),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cMagenta, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(44)),
            onPressed: () => widget.onFeedback('Lote de ${_ctrlCantPremio.text} premios "$_catPremio" creado en inventario.'),
            child: const Text('CREAR LOTE DE PREMIOS', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorReglasGlobales() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: cGreen)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RESERVA DEL SISTEMA: ${_reservaMto.toStringAsFixed(2)} MTO', style: const TextStyle(color: cGold, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cGreen, foregroundColor: Colors.black),
            onPressed: () {
              setState(() => _reservaMto = 0);
              widget.onFeedback('Reserva transferida a cuenta personal del SuperAdmin.');
            },
            child: const Text('RETIRAR A MI CUENTA', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Divider(color: Colors.white24, height: 24),
          _inputOscuro('Tasa Mantenimiento P2P (%):', _ctrlTasaP2p),
          _inputOscuro('Tasa por Canje (%):', _ctrlTasaCanje),
          _inputOscuro('Mantenimiento Arcade (%):', _ctrlTasaArcade),
          _inputOscuro('Descuento MayorAdmin (%):', _ctrlDescMayor),
          _inputOscuro('Descuento Admin (%):', _ctrlDescAdmin),
          _inputOscuro('Descuento Recargador (%):', _ctrlDescRecargador),
          _inputOscuro('Pase Streaming 10 Dias (MTO):', _ctrlPase10),
          _inputOscuro('Pase Streaming 20 Dias (MTO):', _ctrlPase20),
          _inputOscuro('Suscripcion Parental Mensual (MTO):', _ctrlParental),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.black, minimumSize: const Size.fromHeight(44)),
            onPressed: () => widget.onFeedback('Reglas economicas y de mantenimiento guardadas.'),
            child: const Text('GUARDAR REGLAS', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorMundo3Educacion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: cCyan)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MUNDO 3: EDUCACION Y VALORES', style: TextStyle(color: cCyan, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: ['PROFESOR', 'ALUMNO', 'PADRE', 'DIRECTOR'].map((r) {
              final bool sel = _subRolM3 == r;
              return ChoiceChip(
                label: Text(r, style: TextStyle(color: sel ? Colors.black : Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                selected: sel,
                selectedColor: cGreen,
                backgroundColor: Colors.black,
                onSelected: (_) => setState(() => _subRolM3 = r),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          if (_subRolM3 == 'PROFESOR') ...[
            const Text('Aulas Virtuales Activas:', style: TextStyle(color: cGreen, fontWeight: FontWeight.bold)),
            ..._aulasM3.map((a) => ListTile(
                  dense: true,
                  title: Text('${a['nombre_materia']} (${a['nivel_grado']})', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  subtitle: Text('Codigo: ${a['codigo_acceso']}', style: const TextStyle(color: cCyan, fontSize: 11)),
                )),
          ],
          if (_subRolM3 == 'ALUMNO') ...[
            const Text('Misiones / Examenes Pendientes:', style: TextStyle(color: cRed, fontWeight: FontWeight.bold)),
            ..._examenesM3.map((ex) => ListTile(
                  dense: true,
                  title: Text(ex['titulo'].toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                  subtitle: Text('Tiempo: ${ex['tiempo_limite_minutos']} min | ${ex['preguntas']} preguntas', style: const TextStyle(color: Colors.orange, fontSize: 11)),
                )),
          ],
          if (_subRolM3 == 'PADRE') ...[
            const Text('Panel de Padres: Escuadron, Boveda de Notas y Puntos Orbe-Edu', style: TextStyle(color: cGold, fontSize: 12)),
          ],
          if (_subRolM3 == 'DIRECTOR') ...[
            const Text('Oficina del Director: Institucion, Radar de Docentes y Alertas', style: TextStyle(color: cMagenta, fontSize: 12)),
          ],
        ],
      ),
    );
  }

  Widget _inputOscuro(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
          const SizedBox(height: 3),
          TextField(
            controller: ctrl,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.black,
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}