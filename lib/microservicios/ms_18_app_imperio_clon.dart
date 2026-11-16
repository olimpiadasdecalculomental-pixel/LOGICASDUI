import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Ms18AppImperioClon extends StatefulWidget {
  final Function(String) onFeedback;
  final Function(String, Map) onAbrirMotorAvanzado;

  const Ms18AppImperioClon({
    super.key,
    required this.onFeedback,
    required this.onAbrirMotorAvanzado,
  });

  @override
  State createState() => _Ms18AppImperioClonState();
}

class _Ms18AppImperioClonState extends State {
  static const String _supabaseUrl = 'https://cvueferyoyzayjlyjsmk.supabase.co';
  static const String _supabaseKey = 'sb_publishable_0XXkthm3dwy3osX2A4PUEg_UHVDl-lZ';

  static const Color cCyan = Color(0xFF00F3FF);
  static const Color cMagenta = Color(0xFFFF00FC);
  static const Color cGreen = Color(0xFF00FF66);
  static const Color cDark = Color(0xFF05050F);
  static const Color cCard = Color(0xFF0A0A1C);
  static const Color cRed = Color(0xFFFF0033);
  static const Color cGold = Color(0xFFFFD700);

  Map? _user;
  String _screen = 'login';
  bool _loading = false;

  final List _botonesPin = const [
    {'pin': '9999', 'label': 'SUPERADMIN (9999)', 'color': cRed},
    {'pin': '1111', 'label': 'ADMIN (1111)', 'color': cMagenta},
    {'pin': '2222', 'label': 'RECARGADOR (2222)', 'color': cGold},
    {'pin': '3333', 'label': 'USUARIO (3333)', 'color': cGreen},
  ];

  final List _solicitudes = [
    {
      'id': 'sol-101',
      'empresa': 'ENTEL',
      'monto_bs': 50,
      'codigo_tarjeta': '8841 9023 1140',
      'foto_url': 'https://i.imgur.com/3Z1HkYm.jpeg',
      'estado': 'PENDIENTE',
      'perfiles': {'nombre': 'CLIENTE FINAL (Fam 1)'},
    },
    {
      'id': 'sol-102',
      'empresa': 'TIGO',
      'monto_bs': 30,
      'codigo_tarjeta': '5521 7730 9901',
      'foto_url': 'https://i.imgur.com/3Z1HkYm.jpeg',
      'estado': 'PENDIENTE',
      'perfiles': {'nombre': 'USUARIO IMPERIO (Fam 2)'},
    },
  ];

  final List _inventarioResumen = [
    {'tipo': 'TARJETA', 'detalle': 'ENTEL - 10 Bs', 'cantidad': 25},
    {'tipo': 'CODIGO', 'detalle': 'CODIGO MTO - USD 5', 'cantidad': 40},
    {'tipo': 'TARJETA', 'detalle': 'TIGO - 30 Bs', 'cantidad': 15},
  ];

  Map _estadisticas = {
    'aprobadas': 1204,
    'recargadas': 850,
    'fallidas': 12,
  };

  final Map _edicionesTemp = {};
  bool _modalFotoVisible = false;
  String? _fotoSeleccionada;
  Map? _usuarioDestino;
  final TextEditingController _ctrlBusquedaId = TextEditingController();
  String _busquedaId = '';

  int _valorUsdSeleccionado = 1;
  final TextEditingController _ctrlCantidadImpresion = TextEditingController();
  final TextEditingController _ctrlIdDestino = TextEditingController();
  final TextEditingController _ctrlCantTarjetas = TextEditingController();
  final TextEditingController _ctrlCantCodigos = TextEditingController();

  static const Map _perfilesPin = {
    '9999': {
      'id': 'usr-0001',
      'nombre': 'JEFE SUPREMO',
      'rango': 'SUPERADMIN',
      'pin_id': '9999',
      'saldo_ic': 9999999,
    },
    '1111': {
      'id': 'usr-admin-1',
      'nombre': 'LIDER DE ZONA ADMIN',
      'rango': 'ADMIN',
      'pin_id': '1111',
      'saldo_ic': 25000,
    },
    '2222': {
      'id': 'usr-rec-1',
      'nombre': 'TIENDA RECARGADORA ORURO',
      'rango': 'RECARGADOR',
      'pin_id': '2222',
      'saldo_ic': 10000,
    },
    '3333': {
      'id': 'usr-cli-1',
      'nombre': 'JORGE REX (USUARIO FINAL)',
      'rango': 'USUARIO_FINAL',
      'pin_id': '3333',
      'saldo_ic': 1500,
    },
  };

  @override
  void dispose() {
    _ctrlBusquedaId.dispose();
    _ctrlCantidadImpresion.dispose();
    _ctrlIdDestino.dispose();
    _ctrlCantTarjetas.dispose();
    _ctrlCantCodigos.dispose();
    super.dispose();
  }

  Future _handleLogin(String testPin) async {
    HapticFeedback.mediumImpact();
    setState(() => _loading = true);
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 4);
      final uri = Uri.parse('$_supabaseUrl/rest/v1/perfiles?pin_id=eq.$testPin&select=*');
      final req = await client.getUrl(uri);
      req.headers.set('apikey', _supabaseKey);
      req.headers.set('Authorization', 'Bearer $_supabaseKey');
      final res = await req.close().timeout(const Duration(seconds: 4));
      final body = await res.transform(utf8.decoder).join();
      client.close();

      if (res.statusCode >= 200 && res.statusCode < 300 && body.isNotEmpty) {
        final decoded = jsonDecode(body);
        if (decoded is List && decoded.isNotEmpty) {
          final Map remoto = Map.from(decoded.first as Map);
          setState(() {
            _user = remoto;
            _screen = 'home';
            _loading = false;
          });
          (widget as Ms18AppImperioClon).onFeedback('Acceso concedido via Supabase: ${remoto['nombre']} (${remoto['rango']})');
          return;
        }
      }
    } catch (_) {}

    final dynamic rawPerfil = _perfilesPin[testPin];
    if (rawPerfil is Map) {
      final Map perfilLocal = Map.from(rawPerfil);
      setState(() {
        _user = perfilLocal;
        _screen = 'home';
        _loading = false;
      });
      (widget as Ms18AppImperioClon).onFeedback('Sesion iniciada: ${perfilLocal['nombre']} | PIN $testPin');
    } else {
      setState(() => _loading = false);
      _mostrarAlerta('AVISO', 'PIN $testPin no encontrado.');
    }
  }

  void _mostrarAlerta(String titulo, String mensaje) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: cCyan, width: 1.5),
        ),
        title: Text(titulo, style: const TextStyle(color: cCyan, fontWeight: FontWeight.bold, fontSize: 14)),
        content: Text(mensaje, style: const TextStyle(color: Colors.white, fontSize: 12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ENTENDIDO', style: TextStyle(color: cGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future _imprimirCodigos() async {
    final cantTxt = _ctrlCantidadImpresion.text.trim();
    if (cantTxt.isEmpty) {
      _mostrarAlerta('AVISO', 'Ingresa la cantidad.');
      return;
    }
    final int cant = int.tryParse(cantTxt) ?? 0;
    if (cant <= 0) {
      _mostrarAlerta('AVISO', 'Cantidad invalida.');
      return;
    }
    HapticFeedback.heavyImpact();
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 350));
    setState(() {
      _loading = false;
      _inventarioResumen.insert(0, {
        'tipo': 'CODIGO',
        'detalle': 'CODIGO MTO - USD $_valorUsdSeleccionado',
        'cantidad': cant,
      });
      _estadisticas = {
        ..._estadisticas,
        'recargadas': ((_estadisticas['recargadas'] as int?) ?? 0) + cant,
      };
      _ctrlCantidadImpresion.clear();
    });
    _mostrarAlerta('IMPRESION EXITOSA', 'Se crearon $cant codigos de USD $_valorUsdSeleccionado.');
  }

  void _manejarEdicion(String id, String campo, String valor) {
    setState(() {
      final actual = Map.from((_edicionesTemp[id] as Map?) ?? {});
      actual[campo] = valor;
      _edicionesTemp[id] = actual;
    });
  }

  void _aprobarConEdicionFull(Map s) {
    final String id = s['id'].toString();
    final Map edit = Map.from((_edicionesTemp[id] as Map?) ?? {});
    final String empFinal = (edit['empresa'] ?? s['empresa']).toString();
    final String montoFinal = (edit['monto'] ?? s['monto_bs']).toString();
    final String codFinal = (edit['codigo'] ?? s['codigo_tarjeta']).toString();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: cGreen, width: 1.5),
        ),
        title: const Text('APROBAR', style: TextStyle(color: cGreen, fontWeight: FontWeight.bold)),
        content: Text(
          'Validar datos?\nEmpresa: $empFinal\nMonto: $montoFinal\nCodigo: $codFinal',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cGreen, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _solicitudes.removeWhere((item) => (item as Map)['id'].toString() == id);
                _estadisticas = {
                  ..._estadisticas,
                  'aprobadas': ((_estadisticas['aprobadas'] as int?) ?? 0) + 1,
                };
              });
              _mostrarAlerta('EXITO', 'Saldo enviado.');
            },
            child: const Text('SI, APROBAR', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _verFotoGrande(String url) {
    setState(() {
      _fotoSeleccionada = url;
      _modalFotoVisible = true;
    });
  }

  void _despacharMixto() {
    _mostrarAlerta(
      'DESPACHO',
      'Funcion en mantenimiento (Requiere actualizar logica de seleccion multiple). Usar inventario detallado como referencia.',
    );
  }

  Future _buscarUsuario() async {
    if (_busquedaId.trim().isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 300));
    final String pinBuscado = _busquedaId.trim();
    final dynamic raw = _perfilesPin[pinBuscado];
    final Map encontrado = raw is Map
        ? Map.from(raw)
        : {
            'id': 'usr-$pinBuscado',
            'nombre': 'SOCIO IMPERIO ($pinBuscado)',
            'rango': 'USUARIO_FINAL',
            'pin_id': pinBuscado,
            'saldo_ic': 0,
          };
    setState(() {
      _loading = false;
      _usuarioDestino = encontrado;
    });
  }

  void _transferirCodigo(String detalleCodigo) {
    if (_usuarioDestino == null) {
      _mostrarAlerta('AVISO', 'Primero busca un usuario destino.');
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cCard,
        title: const Text('CONFIRMAR TRANSFERENCIA', style: TextStyle(color: cMagenta, fontWeight: FontWeight.bold, fontSize: 13)),
        content: Text(
          'Enviar un $detalleCodigo\n\nA: ${_usuarioDestino!['nombre']} (ID: $_busquedaId)?',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: Colors.white70))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cMagenta, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              _mostrarAlerta('EXITO', 'Codigo transferido (Simulado).');
            },
            child: const Text('ENVIAR'),
          ),
        ],
      ),
    );
  }

  void _venderTarjetaFisica(String detalleTarjeta) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cCard,
        title: const Text('VENDER', style: TextStyle(color: cGold, fontWeight: FontWeight.bold)),
        content: Text('$detalleTarjeta\n\nFunciono la recarga?', style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _mostrarAlerta('REPORTADO', 'Fallo reportado a Mesa de Verificacion.');
            },
            child: const Text('FALLO (REPORTAR)', style: TextStyle(color: cRed)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cGreen, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              _mostrarAlerta('APROBADO', 'Venta P2P aprobada.');
            },
            child: const Text('SI (APROBAR)'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_screen == 'login') {
      return _buildLoginScreen();
    }
    return _buildHomeScreen(context);
  }

  Widget _buildLoginScreen() {
    return Container(
      color: cDark,
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
              children: [
                TextSpan(text: 'APP'),
                TextSpan(text: 'IMPERIO', style: TextStyle(color: cCyan)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          if (_loading)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: CircularProgressIndicator(color: cCyan),
            ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: _botonesPin.map((raw) {
              final Map b = Map.from(raw as Map);
              final Color col = b['color'] as Color;
              return SizedBox(
                width: 155,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black,
                    side: BorderSide(color: col, width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  onPressed: () => _handleLogin(b['pin'].toString()),
                  child: Text(
                    b['label'].toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
    final String rango = _user?['rango']?.toString() ?? 'USUARIO_FINAL';
    final bool esSuper = rango == 'SUPERADMIN';
    final bool esAdmin = rango == 'ADMIN' || esSuper;
    final bool esRecargador = rango == 'RECARGADOR' || esAdmin;

    return Container(
      color: cDark,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
                decoration: const BoxDecoration(
                  color: cDark,
                  border: Border(bottom: BorderSide(color: Color(0xFF333333))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            children: [
                              TextSpan(text: 'APP'),
                              TextSpan(text: 'IMPERIO', style: TextStyle(color: cCyan)),
                            ],
                          ),
                        ),
                        Text(
                          '${_user?['nombre'] ?? ''} | $rango',
                          style: const TextStyle(color: cCyan, fontSize: 10),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cMagenta),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                          children: [
                            const TextSpan(text: 'SALDO: '),
                            TextSpan(
                              text: '${_user?['saldo_ic'] ?? 0} IC',
                              style: const TextStyle(color: cMagenta, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: cCard,
                  border: Border(bottom: BorderSide(color: Color(0xFF333333))),
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _tabItem(Icons.movie_outlined, 'MEDIA', cCyan, () => (widget as Ms18AppImperioClon).onAbrirMotorAvanzado('CINETV', {})),
                          _tabItem(Icons.sports_esports_outlined, 'ARCADE', cMagenta, () => (widget as Ms18AppImperioClon).onAbrirMotorAvanzado('MERCADO', {'cat': 'CURSOS'})),
                          _tabItem(Icons.school_outlined, 'CEREBRO', cCyan, () => (widget as Ms18AppImperioClon).onAbrirMotorAvanzado('MUNDO3_PROFESOR', {})),
                          _tabItem(Icons.chat_bubble_outline, 'CHAT', cGreen, () => _mostrarAlerta('CHAT', 'Canal P2P activo.')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _tabItem(Icons.qr_code_2_outlined, 'BOVEDA', cCyan, () => (widget as Ms18AppImperioClon).onAbrirMotorAvanzado('BOVEDA_QR', {})),
                          _tabItem(Icons.people_outline, 'DEALERS', cMagenta, () => (widget as Ms18AppImperioClon).onAbrirMotorAvanzado('PREMIOS', {})),
                          _tabItem(Icons.settings_outlined, 'ADMIN', cGreen, () => (widget as Ms18AppImperioClon).onAbrirMotorAvanzado('REGLAS', {})),
                          _tabItem(Icons.power_settings_new, 'SALIR', cRed, () {
                            setState(() {
                              _screen = 'login';
                              _user = null;
                            });
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, MediaQuery.of(context).viewInsets.bottom + 60),
                  children: [
                    if (esSuper) _buildPanelSuperAdmin(),
                    if (esAdmin) _buildPanelAdmin(),
                    if (esRecargador) _buildInventarioDetallado(rango),
                    if (rango == 'RECARGADOR') _buildBuscadorRecargador(),
                    if (rango == 'USUARIO_FINAL') _buildPanelUsuarioFinal(),
                  ],
                ),
              ),
            ],
          ),
          if (_modalFotoVisible)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(235),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_fotoSeleccionada != null)
                      Image.network(
                        _fotoSeleccionada!,
                        width: double.infinity,
                        height: 450,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: cCyan, size: 64),
                      ),
                    Positioned(
                      top: 50,
                      right: 20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: cRed, foregroundColor: Colors.white),
                        onPressed: () => setState(() => _modalFotoVisible = false),
                        child: const Text('CERRAR X', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tabItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 75,
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelSuperAdmin() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: cCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cRed),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('IMPRESION DE CODIGOS', style: TextStyle(color: cRed, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [1, 2, 5, 10].map((val) {
                  final bool sel = _valorUsdSeleccionado == val;
                  return InkWell(
                    onTap: () => setState(() => _valorUsdSeleccionado = val),
                    child: Container(
                      width: 50,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sel ? cRed : Colors.black,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: cRed),
                      ),
                      child: Text('USD $val', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _ctrlCantidadImpresion,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Cantidad a imprimir (Ej: 50)',
                  hintStyle: TextStyle(color: Color(0xFF555555)),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: _imprimirCodigos,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0x22FF0033),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: cRed),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: cRed)
                      : const Text('IMPRIMIR LOTE', style: TextStyle(color: cRed, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: cCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cCyan),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AUDITORIA GLOBAL', style: TextStyle(color: cCyan, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statItem('${_estadisticas['aprobadas']}', 'APROBADAS', cGreen),
                  _statItem('${_estadisticas['recargadas']}', 'RECARGADAS', cCyan),
                  _statItem('${_estadisticas['fallidas']}', 'FALLIDAS', cRed),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statItem(String num, String lbl, Color col) {
    return Column(
      children: [
        Text(num, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(lbl, style: TextStyle(color: col, fontSize: 10)),
      ],
    );
  }

  Widget _buildPanelAdmin() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: cCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cMagenta),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('MESA DE VERIFICACION (EDICION TOTAL)', style: TextStyle(color: cMagenta, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 12),
              if (_solicitudes.isEmpty)
                const Text('Sin pendientes.', style: TextStyle(color: Color(0xFF555555)))
              else
                ..._solicitudes.map((raw) {
                  final Map s = Map.from(raw as Map);
                  final String id = s['id'].toString();
                  final Map edit = Map.from((_edicionesTemp[id] as Map?) ?? {});
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF222222)))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                initialValue: (edit['empresa'] ?? s['empresa']).toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                onChanged: (v) => _manejarEdicion(id, 'empresa', v),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                initialValue: (edit['monto'] ?? s['monto_bs']).toString(),
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                onChanged: (v) => _manejarEdicion(id, 'monto', v),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text('Bs', style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                        if (s['foto_url'] != null)
                          InkWell(
                            onTap: () => _verFotoGrande(s['foto_url'].toString()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(s['foto_url'].toString(), width: 60, height: 60, fit: BoxFit.cover),
                                ),
                                const Text('Ver Foto', style: TextStyle(color: cCyan, fontSize: 9)),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: (edit['codigo'] ?? s['codigo_tarjeta']).toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                onChanged: (v) => _manejarEdicion(id, 'codigo', v),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: cGreen, foregroundColor: Colors.black),
                              onPressed: () => _aprobarConEdicionFull(s),
                              child: const Text('APROBAR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
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
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: cCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cCyan),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('DESPACHO A TIENDA', style: TextStyle(color: cCyan, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 12),
              TextField(
                controller: _ctrlIdDestino,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: '> ID Destino', hintStyle: TextStyle(color: Color(0xFF555555)), filled: true, fillColor: Colors.black),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrlCantTarjetas,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(hintText: 'Cant. Tarjetas', hintStyle: TextStyle(color: Color(0xFF555555)), filled: true, fillColor: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _ctrlCantCodigos,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(hintText: 'Cant. Codigos', hintStyle: TextStyle(color: Color(0xFF555555)), filled: true, fillColor: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _despacharMixto,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: cCyan)),
                  child: const Text('ENVIAR', style: TextStyle(color: cCyan, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventarioDetallado(String rango) {
    final Color borde = rango == 'RECARGADOR' ? cGold : cMagenta;
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: cCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MI INVENTARIO DETALLADO', style: TextStyle(color: cGold, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 12),
          if (_inventarioResumen.isEmpty)
            const Text('Inventario vacio.', style: TextStyle(color: Color(0xFF555555)))
          else
            ..._inventarioResumen.map((raw) {
              final Map item = Map.from(raw as Map);
              final bool esTarjeta = item['tipo'] == 'TARJETA';
              return Container(
                padding: const EdgeInsets.only(bottom: 10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF222222)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${esTarjeta ? 'TARJETA' : 'CODIGO'} ${item['detalle']}',
                          style: TextStyle(color: esTarjeta ? cGold : cMagenta, fontWeight: FontWeight.bold),
                        ),
                        Text('Stock: ${item['cantidad']} unidades', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                    if (rango == 'RECARGADOR')
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: esTarjeta ? cGold : cMagenta,
                          foregroundColor: esTarjeta ? Colors.black : Colors.white,
                        ),
                        onPressed: () => esTarjeta
                            ? _venderTarjetaFisica(item['detalle'].toString())
                            : _transferirCodigo(item['detalle'].toString()),
                        child: Text(esTarjeta ? 'VENDER P2P' : 'TRANSFERIR', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildBuscadorRecargador() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: cCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BUSCAR USUARIO DESTINO', style: TextStyle(color: cGreen, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrlBusquedaId,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: '> ID Usuario (Ej: 3333)',
                    hintStyle: TextStyle(color: Color(0xFF555555)),
                    filled: true,
                    fillColor: Colors.black,
                  ),
                  onChanged: (v) => _busquedaId = v,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: cGreen, foregroundColor: Colors.black),
                onPressed: _buscarUsuario,
                child: _loading ? const CircularProgressIndicator(color: Colors.black) : const Icon(Icons.search),
              ),
            ],
          ),
          if (_usuarioDestino != null)
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0x2200FF66), borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('USUARIO ENCONTRADO:', style: TextStyle(color: cGreen, fontWeight: FontWeight.bold)),
                  Text(_usuarioDestino!['nombre'].toString(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                  Text('Rango: ${_usuarioDestino!['rango']}', style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 5),
                  const Text('Ahora puedes transferirle Codigos Imperio de tu inventario de arriba.', style: TextStyle(color: cCyan, fontSize: 11)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPanelUsuarioFinal() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: cCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cCyan),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ECOSISTEMA USUARIO FINAL (PIN 3333)', style: TextStyle(color: cCyan, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          const Text('Cedula QR, Recargas con foto, Boveda VIP, Mercado Intelectual y Mundo 3.', style: TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: cCyan, foregroundColor: Colors.black),
                onPressed: () => (widget as Ms18AppImperioClon).onAbrirMotorAvanzado('CINETV', {}),
                child: const Text('CINE 4D / TV', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: cMagenta, foregroundColor: Colors.white),
                onPressed: () => (widget as Ms18AppImperioClon).onAbrirMotorAvanzado('MERCADO', {'cat': 'CURSOS'}),
                child: const Text('MERCADO / CURSOS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: cGreen, foregroundColor: Colors.black),
                onPressed: () => (widget as Ms18AppImperioClon).onAbrirMotorAvanzado('MUNDO3_ALUMNO', {}),
                child: const Text('MUNDO 3 ALUMNO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}