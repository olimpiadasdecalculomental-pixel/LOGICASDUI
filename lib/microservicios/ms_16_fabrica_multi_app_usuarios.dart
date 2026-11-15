import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/puente_supabase_sdui.dart';
import '../nucleo/despachador_acciones.dart';

class Ms16FabricaMultiAppUsuarios extends StatefulWidget {
  final Function(String) onFeedback;
  const Ms16FabricaMultiAppUsuarios({super.key, required this.onFeedback});

  @override
  State createState() => _Ms16FabricaMultiAppUsuariosState();
}

class _Ms16FabricaMultiAppUsuariosState extends State {
  int _idxAppActiva = 0;
  int _idxRolActivo = 0;
  bool _mostrarFormNuevaApp = false;
  bool _mostrarFormNuevoRol = false;

  final TextEditingController _ctrlNombreNuevaApp = TextEditingController();
  final TextEditingController _ctrlIndustriaNuevaApp = TextEditingController(text: 'SuperApp / Negocio / SaaS');
  final TextEditingController _ctrlObjetivoNuevaApp = TextEditingController();
  final TextEditingController _ctrlNotasNuevaApp = TextEditingController();

  final TextEditingController _ctrlNombreNuevoRol = TextEditingController();

  final TextEditingController _ctrl1Login = TextEditingController();
  final TextEditingController _ctrl2Habilidades = TextEditingController();
  final TextEditingController _ctrl3Registra = TextEditingController();
  final TextEditingController _ctrl4Consulta = TextEditingController();
  final TextEditingController _ctrl5ModificaElimina = TextEditingController();
  final TextEditingController _ctrl6Transacciones = TextEditingController();
  final TextEditingController _ctrl7Impresiones = TextEditingController();
  final TextEditingController _ctrl8ComoActuaLogica = TextEditingController();
  final TextEditingController _ctrl9ReglasRfcMust = TextEditingController();
  final TextEditingController _ctrl10ComponentesUx = TextEditingController();
  final TextEditingController _ctrl11NotasLibres = TextEditingController();

  List _apps = [
    {
      'id_app': 'APP_01_CLUB_DEPORTIVO_SUPERAPP',
      'nombre_app': '1. SuperApp Club San José 1942',
      'categoria_industria': 'Deportes / Fidelización / Fintech / Social Video',
      'objetivo_vision_prd': 'Conectar hinchas, socios vitalicios, tiendas aliadas y tribunal electoral con video 9:16, dados, bóveda QR con PIN y votaciones (+51%).',
      'arquitectura_rfc_resumen': 'SDUI Triple Motor + Supabase PostgreSQL + 5 Microservicios RPC + Paginación Cursor LIMIT 10.',
      'escala_usuarios_meta': '10,000,000,000 de registros soportados con LIMIT 10',
      'notas_generales_app': 'Modelo maestro adaptable a clubes, cooperativas o franquicias.',
    },
    {
      'id_app': 'APP_02_DELIVERY_Y_COMERCIO_GLOBAL',
      'nombre_app': '2. App Multicomercios, POS y Delivery',
      'categoria_industria': 'E-Commerce / Punto de Venta / Inventarios',
      'objetivo_vision_prd': 'Vender productos con buscador Top-10 instantáneo, cobrar con QR, confirmar con diálogo Sí/No e imprimir comandas y PDF.',
      'arquitectura_rfc_resumen': 'Tablas particionadas + Índices compuestos + RPC transaccional atómico para stock.',
      'escala_usuarios_meta': '10,000,000,000 de transacciones soportadas sin lentitud',
      'notas_generales_app': 'Ideal para restaurantes, supermercados, farmacias y distribuidoras.',
    },
  ];

  List _roles = [
    {
      'id_rol_usuario': 'ROL_01_INVITADO_SIN_LOGIN',
      'id_app': 'APP_01_CLUB_DEPORTIVO_SUPERAPP',
      'nombre_rol': 'Hincha Invitado (El Mirón #89F2A)',
      'icono_avatar': '👤',
      'metodo_login_acceso': 'Sin Login (Entra directo al abrir la APK con ID temporal #89F2A)',
      'habilidades_que_hace': 'Explora videos 9:16, da Me Gusta, lanza el Dado Santo (1 al 6) y acumula puntos temporales.',
      'que_registra_insert': 'Registra reacciones de Me Gusta, tiros del dado y cuando decide proteger sus premios registra su Apodo + PIN de 4 dígitos.',
      'que_consulta_select': 'Consulta el Muro de Videos 9:16, el Reloj del Sorteo 06:00 AM y la lista Top-10 de Ganadores.',
      'que_modifica_elimina': 'Quita su propio Me Gusta o cierra el aviso de Modo Anónimo.',
      'transacciones_y_pagos': 'Acumula +40 pts y +120 pts en billetera temporal; para transferir premios QR primero blinda su cuenta con PIN.',
      'impresiones_y_reportes': 'Visualiza y copia códigos de cupones promocionales públicos.',
      'como_actua_logica_negocio': 'SI entra por primera vez -> abre directo el Muro sin login. SI toca Transferir QR o Votar -> abre Modal para crear Apodo + PIN de 4 dígitos.',
      'reglas_rfc_must_mustnot': 'MUST entrar sin pantalla de bloqueo inicial. MUST NOT transferir premios QR sin antes crear su PIN.',
      'componentes_uxui_usados': 'ElevatedButton (Lanzar Dado), IconButton (Corazón), AlertDialog (+120 pts), ListView Top-10.',
      'notas_libres_extra': 'Aumenta la retención porque ningún usuario rebota al inicio.',
    },
    {
      'id_rol_usuario': 'ROL_02_SOCIO_VITALICIO_VIP',
      'id_app': 'APP_01_CLUB_DEPORTIVO_SUPERAPP',
      'nombre_rol': 'Socio Vitalicio / Registrado con PIN (#1942)',
      'icono_avatar': '🏅',
      'metodo_login_acceso': 'Login con Apodo + PIN Secreto de 4 dígitos (bloqueo configurable en 1h, 6h, 24h o Siempre)',
      'habilidades_que_hace': 'Guarda premios en Bóveda QR, transfiere poleras/cupones, paga cuotas y vota en el Parlamento (+51%).',
      'que_registra_insert': 'Registra voto firmado digitalmente (A Favor / En Contra), sube comprobantes de 70 BS y reclama tickets VIP.',
      'que_consulta_select': 'Consulta Billetera (480 pts), Credencial Digital Holográfica, Estado de Cuenta y 3 Cupones Diarios.',
      'que_modifica_elimina': 'Modifica frecuencia de bloqueo de su PIN (1h/6h/24h/Siempre) y actualiza sus datos.',
      'transacciones_y_pagos': 'Paga inscripción (270 BS), mensualidad (70 BS), transfiere QR (SJ-8821-QR) y firma voto con Hash (0x9b42...1942SJ).',
      'impresiones_y_reportes': 'Imprime o exporta en PDF su Credencial Digital VIP y sus recibos de aportes.',
      'como_actua_logica_negocio': 'CUANDO abre Bóveda QR -> regenera el código cada 45s. CUANDO vota en el Parlamento -> verifica cuota al día y suma al quórum del 51%.',
      'reglas_rfc_must_mustnot': 'MUST encriptar PIN de 4 dígitos. MUST calcular quórum sobre 3,420 socios. MUST NOT votar dos veces la misma moción.',
      'componentes_uxui_usados': 'QrImageView, RadioButton (A Favor/En Contra), SegmentedButton (1h/6h/24h/Siempre), ListView con Botones.',
      'notas_libres_extra': 'Si cambia de celular, recupera su Bóveda con su Apodo + PIN.',
    },
    {
      'id_rol_usuario': 'ROL_03_CAJERO_TIENDA_ALIADA',
      'id_app': 'APP_01_CLUB_DEPORTIVO_SUPERAPP',
      'nombre_rol': 'Cajero de Tienda Aliada (Escáner QR)',
      'icono_avatar': '🏪',
      'metodo_login_acceso': 'Login de Sucursal Aliada con Rol Restringido (Modo Tienda)',
      'habilidades_que_hace': 'Escanea con cámara el QR del socio, valida autenticidad, entrega la polera o combo y quema el cupón (-1 stock).',
      'que_registra_insert': 'Registra cada entrega presencial en la bitácora del Nodo Oruro Central.',
      'que_consulta_select': 'Consulta únicamente el Escáner Óptico y el stock disponible de su sucursal (14 / 50 poleras).',
      'que_modifica_elimina': 'Cambia estado del QR a QUEMADO y descuenta -1 unidad del inventario.',
      'transacciones_y_pagos': 'Redime vales de 50 Bs, descuentos del 20% y Poleras Oficiales.',
      'impresiones_y_reportes': 'Imprime ticket de constancia de entrega de premio para archivo de la sucursal.',
      'como_actua_logica_negocio': 'SI activa Modo Tienda -> oculta Tribunal y Gestor Paramétrico. CUANDO toca Validar y Quemar -> pide confirmación Sí/No y resta -1 al stock.',
      'reglas_rfc_must_mustnot': 'MUST ocultar datos financieros del club. MUST verificar stock > 0 antes de quemar.',
      'componentes_uxui_usados': 'MobileScanner (Cámara 4:3), Botón Destructivo/Acción (Quemar QR), Badge de Stock (14/50), Toast.',
      'notas_libres_extra': 'El QR dinámico de 45s impide que usen capturas de pantalla repetidas.',
    },
    {
      'id_rol_usuario': 'ROL_04_SUPERADMIN_TRIBUNAL',
      'id_app': 'APP_01_CLUB_DEPORTIVO_SUPERAPP',
      'nombre_rol': 'Administrador Central / Tribunal Forense',
      'icono_avatar': '👑',
      'metodo_login_acceso': 'Doble Candado + Contraseña Maestra (?1942?) + Biometría',
      'habilidades_que_hace': 'Audita comprobantes bancarios a 2 columnas con Zoom, aprueba/rechaza pagos de 70 BS, calibra el dado y exporta PDF.',
      'que_registra_insert': 'Registra nuevas pantallas, nuevas reglas RPC y actualiza tarifas oficiales (270 BS / 70 BS).',
      'que_consulta_select': 'Consulta todas las tablas con paginación Top-10, lotes pendientes (12 recibos) y métricas.',
      'que_modifica_elimina': 'Aprueba o rechaza comprobantes y bloquea pantallas con candado.',
      'transacciones_y_pagos': 'Autoriza aportes de 70 BS y 270 BS con Regla Dual Automática.',
      'impresiones_y_reportes': 'Exporta el Libro Maestro PDF completo de la aplicación y todos sus roles.',
      'como_actua_logica_negocio': 'CUANDO abre el Tribunal -> compara foto del recibo (#BNB-88319) con la declaración (#1842) y presiona Aprobar o Rechazar.',
      'reglas_rfc_must_mustnot': 'MUST auditar cada cambio en api_comunicacion. MUST proteger diseños terminados con candado.',
      'componentes_uxui_usados': 'InteractiveViewer (Zoom), Comparador 2 Columnas, Slider (Dado 1-6), Switch (Regla Dual), Exportador PDF.',
      'notas_libres_extra': 'Gobierna toda la app en vivo sin recompilar el APK.',
    },
    {
      'id_rol_usuario': 'ROL_05_CAJERO_POS_MULTICOMERCIO',
      'id_app': 'APP_02_DELIVERY_Y_COMERCIO_GLOBAL',
      'nombre_rol': 'Vendedor / Cajero de Punto de Venta (POS)',
      'icono_avatar': '🧾',
      'metodo_login_acceso': 'Login rápido con PIN de 4 dígitos de apertura de turno',
      'habilidades_que_hace': 'Busca productos con buscador Top-10 (LIMIT 10), selecciona extras con Checkbox, cobra con QR e imprime recibo.',
      'que_registra_insert': 'Registra ventas, clientes nuevos con NIT/CI y arqueos de caja.',
      'que_consulta_select': 'Consulta los 10 productos buscados en menos de 1 milisegundo aunque existan 10,000M de registros.',
      'que_modifica_elimina': 'Ajusta cantidades (+/-) o elimina un ítem con diálogo "¿Seguro que deseas quitar? [Sí / No]".',
      'transacciones_y_pagos': 'Cobra en efectivo, QR o transferencia y descuenta stock atómicamente.',
      'impresiones_y_reportes': 'Imprime recibo térmico de 80mm y exporta cierre de caja en PDF.',
      'como_actua_logica_negocio': 'CUANDO escribe en el buscador -> trae solo 10 filas (LIMIT 10). CUANDO toca Cobrar -> pregunta "¿Registrar venta? [Sí / No]" y emite recibo.',
      'reglas_rfc_must_mustnot': 'MUST usar LIMIT 10 indexado. MUST pedir confirmación Sí/No antes de cerrar venta.',
      'componentes_uxui_usados': 'SearchBar LIMIT 10, ListView con Botones (+/-), ListView con Checkbox, AlertDialog Sí/No, PDF.',
      'notas_libres_extra': 'Permite facturar en menos de 8 segundos por cliente.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _cargarRolEnControladores();
    _sincronizarDesdeSupabase();
  }

  Future _sincronizarDesdeSupabase() async {
    final res = await PuenteSupabaseSdui.ejecutarRpcUniversal(
      'esq1_rpc_obtener_todo_logicasdui',
      {},
      esquemaOverride: 'esquema1',
    );
    if (res['exito'] == true && mounted) {
      setState(() {
        if (res['apps'] is List && (res['apps'] as List).isNotEmpty) {
          _apps = List.from(res['apps'] as List);
        }
        if (res['roles_usuarios'] is List && (res['roles_usuarios'] as List).isNotEmpty) {
          _roles = List.from(res['roles_usuarios'] as List);
        }
        _idxAppActiva = _idxAppActiva.clamp(0, _apps.length - 1);
        _idxRolActivo = 0;
        _cargarRolEnControladores();
      });
    }
  }

  List _rolesDeAppActiva() {
    if (_apps.isEmpty) return [];
    final String idApp = (_apps[_idxAppActiva] as Map)['id_app'].toString();
    return _roles.where((r) => (r as Map)['id_app'].toString() == idApp).toList();
  }

  void _cargarRolEnControladores() {
    final List lista = _rolesDeAppActiva();
    if (lista.isEmpty) {
      _ctrl1Login.text = '';
      _ctrl2Habilidades.text = '';
      _ctrl3Registra.text = '';
      _ctrl4Consulta.text = '';
      _ctrl5ModificaElimina.text = '';
      _ctrl6Transacciones.text = '';
      _ctrl7Impresiones.text = '';
      _ctrl8ComoActuaLogica.text = '';
      _ctrl9ReglasRfcMust.text = '';
      _ctrl10ComponentesUx.text = '';
      _ctrl11NotasLibres.text = '';
      return;
    }
    final int idxSeguro = _idxRolActivo.clamp(0, lista.length - 1);
    final Map r = Map.from(lista[idxSeguro] as Map);
    _ctrl1Login.text = r['metodo_login_acceso']?.toString() ?? '';
    _ctrl2Habilidades.text = r['habilidades_que_hace']?.toString() ?? '';
    _ctrl3Registra.text = r['que_registra_insert']?.toString() ?? '';
    _ctrl4Consulta.text = r['que_consulta_select']?.toString() ?? '';
    _ctrl5ModificaElimina.text = r['que_modifica_elimina']?.toString() ?? '';
    _ctrl6Transacciones.text = r['transacciones_y_pagos']?.toString() ?? '';
    _ctrl7Impresiones.text = r['impresiones_y_reportes']?.toString() ?? '';
    _ctrl8ComoActuaLogica.text = r['como_actua_logica_negocio']?.toString() ?? '';
    _ctrl9ReglasRfcMust.text = r['reglas_rfc_must_mustnot']?.toString() ?? '';
    _ctrl10ComponentesUx.text = r['componentes_uxui_usados']?.toString() ?? '';
    _ctrl11NotasLibres.text = r['notas_libres_extra']?.toString() ?? '';
  }

  Future _crearNuevaApp() async {
    final String nom = _ctrlNombreNuevaApp.text.trim();
    if (nom.isEmpty) {
      (widget as Ms16FabricaMultiAppUsuarios).onFeedback('⚠️ Escribe primero el nombre de la nueva App.');
      return;
    }
    HapticFeedback.heavyImpact();
    final String nuevoId = 'APP_${DateTime.now().millisecondsSinceEpoch % 100000}';
    final Map nuevaApp = {
      'id_app': nuevoId,
      'nombre_app': nom,
      'categoria_industria': _ctrlIndustriaNuevaApp.text.trim(),
      'objetivo_vision_prd': _ctrlObjetivoNuevaApp.text.trim().isEmpty
          ? 'Aplicación creada en LOGICASDUI con arquitectura PRD/RFC.'
          : _ctrlObjetivoNuevaApp.text.trim(),
      'arquitectura_rfc_resumen': 'SDUI + Supabase + Paginación Cursor LIMIT 10 para 10,000M de usuarios.',
      'escala_usuarios_meta': '10,000,000,000 de registros (LIMIT 10)',
      'notas_generales_app': _ctrlNotasNuevaApp.text.trim(),
    };

    final Map primerRol = {
      'id_rol_usuario': 'ROL_${DateTime.now().millisecondsSinceEpoch % 100000}',
      'id_app': nuevoId,
      'nombre_rol': 'Usuario Principal / Administrador de $nom',
      'icono_avatar': '👑',
      'metodo_login_acceso': 'Correo y Contraseña / PIN de 4 dígitos',
      'habilidades_que_hace': 'Gestiona los módulos principales de $nom.',
      'que_registra_insert': 'Registra clientes, operaciones y configuraciones.',
      'que_consulta_select': 'Consulta listas rápidas Top-10 (LIMIT 10) y reportes.',
      'que_modifica_elimina': 'Edita registros y elimina con confirmación [Sí / No].',
      'transacciones_y_pagos': 'Ejecuta cobros, transferencias o validaciones QR.',
      'impresiones_y_reportes': 'Imprime comprobantes y exporta el Libro PDF.',
      'como_actua_logica_negocio': 'CUANDO toca un botón de registro -> valida campos obligatorios -> guarda en Supabase -> muestra confirmación.',
      'reglas_rfc_must_mustnot': 'MUST validar sesión activa. MUST usar LIMIT 10 en búsquedas masivas.',
      'componentes_uxui_usados': 'ElevatedButton, TextField, AlertDialog Sí/No, ListView Top-10, PDF.',
      'notas_libres_extra': 'Primer rol creado automáticamente para $nom.',
    };

    setState(() {
      _apps.insert(0, nuevaApp);
      _roles.add(primerRol);
      _idxAppActiva = 0;
      _idxRolActivo = 0;
      _mostrarFormNuevaApp = false;
      _ctrlNombreNuevaApp.clear();
      _ctrlObjetivoNuevaApp.clear();
      _ctrlNotasNuevaApp.clear();
      _cargarRolEnControladores();
    });

    await PuenteSupabaseSdui.ejecutarRpcUniversal(
      'esq1_rpc_guardar_app_o_usuario',
      {
        'p_operacion': 'CREAR_APP',
        'p_id_app': nuevoId,
        'p_nombre_app': nom,
        'p_categoria': nuevaApp['categoria_industria'],
        'p_objetivo': nuevaApp['objetivo_vision_prd'],
        'p_notas': nuevaApp['notas_generales_app'],
      },
      esquemaOverride: 'esquema1',
    );
    (widget as Ms16FabricaMultiAppUsuarios).onFeedback('✅ Nueva App "$nom" creada. Ahora puedes agregar y entrevistar a todos sus Usuarios.');
  }

  Future _agregarNuevoRolAUnaApp() async {
    final String nomRol = _ctrlNombreNuevoRol.text.trim();
    if (nomRol.isEmpty || _apps.isEmpty) {
      (widget as Ms16FabricaMultiAppUsuarios).onFeedback('⚠️ Escribe el nombre del nuevo Tipo de Usuario / Rol.');
      return;
    }
    HapticFeedback.mediumImpact();
    final String idAppActual = (_apps[_idxAppActiva] as Map)['id_app'].toString();
    final String idRolNuevo = 'ROL_${DateTime.now().millisecondsSinceEpoch % 100000}';

    final Map nuevoRol = {
      'id_rol_usuario': idRolNuevo,
      'id_app': idAppActual,
      'nombre_rol': nomRol,
      'icono_avatar': '👤',
      'metodo_login_acceso': 'PIN de 4 dígitos / Correo y contraseña',
      'habilidades_que_hace': 'Como $nomRol, quiero operar en la app para cumplir mis funciones.',
      'que_registra_insert': 'Registra formularios y datos propios de $nomRol.',
      'que_consulta_select': 'Consulta listas paginadas Top-10 (LIMIT 10).',
      'que_modifica_elimina': 'Actualiza sus registros con confirmación Sí/No.',
      'transacciones_y_pagos': 'Realiza operaciones autorizadas para $nomRol.',
      'impresiones_y_reportes': 'Imprime comprobantes y descarga reportes PDF.',
      'como_actua_logica_negocio': 'DADO QUE ingresó como $nomRol, CUANDO presiona el botón de acción, ENTONCES valida permisos y guarda en BD.',
      'reglas_rfc_must_mustnot': 'MUST respetar permisos de $nomRol. MUST NOT acceder a pantallas de otro rol.',
      'componentes_uxui_usados': 'ElevatedButton, TextField, ListView con Botones, AlertDialog Sí/No.',
      'notas_libres_extra': '',
    };

    setState(() {
      _roles.add(nuevoRol);
      final List rolesApp = _rolesDeAppActiva();
      _idxRolActivo = rolesApp.length - 1;
      _mostrarFormNuevoRol = false;
      _ctrlNombreNuevoRol.clear();
      _cargarRolEnControladores();
    });

    await _guardarRespuestasDelUsuarioActual();
  }

  Future _guardarRespuestasDelUsuarioActual() async {
    final List lista = _rolesDeAppActiva();
    if (lista.isEmpty) return;
    HapticFeedback.heavyImpact();
    final int idxSeguro = _idxRolActivo.clamp(0, lista.length - 1);
    final Map rolActual = Map.from(lista[idxSeguro] as Map);
    final String idRol = rolActual['id_rol_usuario'].toString();

    final int idxGlobal = _roles.indexWhere((r) => (r as Map)['id_rol_usuario'].toString() == idRol);
    if (idxGlobal >= 0) {
      setState(() {
        _roles[idxGlobal] = {
          ...rolActual,
          'metodo_login_acceso': _ctrl1Login.text.trim(),
          'habilidades_que_hace': _ctrl2Habilidades.text.trim(),
          'que_registra_insert': _ctrl3Registra.text.trim(),
          'que_consulta_select': _ctrl4Consulta.text.trim(),
          'que_modifica_elimina': _ctrl5ModificaElimina.text.trim(),
          'transacciones_y_pagos': _ctrl6Transacciones.text.trim(),
          'impresiones_y_reportes': _ctrl7Impresiones.text.trim(),
          'como_actua_logica_negocio': _ctrl8ComoActuaLogica.text.trim(),
          'reglas_rfc_must_mustnot': _ctrl9ReglasRfcMust.text.trim(),
          'componentes_uxui_usados': _ctrl10ComponentesUx.text.trim(),
          'notas_libres_extra': _ctrl11NotasLibres.text.trim(),
        };
      });
    }

    final res = await PuenteSupabaseSdui.ejecutarRpcUniversal(
      'esq1_rpc_guardar_app_o_usuario',
      {
        'p_operacion': 'GUARDAR_USUARIO',
        'p_id_rol': idRol,
        'p_id_app': rolActual['id_app'],
        'p_nombre_rol': rolActual['nombre_rol'],
        'p_icono': rolActual['icono_avatar'] ?? '👤',
        'p_login': _ctrl1Login.text.trim(),
        'p_habilidades': _ctrl2Habilidades.text.trim(),
        'p_registra': _ctrl3Registra.text.trim(),
        'p_consulta': _ctrl4Consulta.text.trim(),
        'p_modifica_elimina': _ctrl5ModificaElimina.text.trim(),
        'p_transacciones': _ctrl6Transacciones.text.trim(),
        'p_impresiones': _ctrl7Impresiones.text.trim(),
        'p_como_actua': _ctrl8ComoActuaLogica.text.trim(),
        'p_reglas_rfc': _ctrl9ReglasRfcMust.text.trim(),
        'p_componentes_ux': _ctrl10ComponentesUx.text.trim(),
        'p_notas_extra': _ctrl11NotasLibres.text.trim(),
      },
      esquemaOverride: 'esquema1',
    );
    (widget as Ms16FabricaMultiAppUsuarios).onFeedback(
      res['mensaje']?.toString() ?? '💾 Respuestas de ${rolActual['nombre_rol']} guardadas con éxito.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map appActiva = _apps.isNotEmpty ? Map.from(_apps[_idxAppActiva] as Map) : {};
    final List rolesDeEstaApp = _rolesDeAppActiva();
    final Map? rolSeleccionado = rolesDeEstaApp.isNotEmpty
        ? Map.from(rolesDeEstaApp[_idxRolActivo.clamp(0, rolesDeEstaApp.length - 1)] as Map)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF00509D), Color(0xFF142033), Color(0xFF071326)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFBB400), width: 1.8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🏭 PANTALLA 2/8 · CREADOR DE APPS Y ENTREVISTA DE USUARIOS',
                      style: TextStyle(color: Color(0xFFFBB400), fontSize: 12.5, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Registra tus Apps por nombre, selecciona cualquier Usuario de la lista y responde todas sus preguntas PRD/RFC.',
                      style: TextStyle(color: Color(0xFFD7E3FD), fontSize: 10.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  foregroundColor: const Color(0xFF071326),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                icon: const Icon(Icons.picture_as_pdf, size: 16),
                label: const Text('EXPORTAR PDF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                onPressed: () {
                  DespachadorAccionesSdui.generarYMostrarLibroPdfMultiApp(
                    context: context,
                    tituloPdf: 'Libro Maestro PRD + RFC: ${appActiva['nombre_app'] ?? 'Todas mis Apps'}',
                    appsRegistradas: _apps,
                    rolesRegistrados: _roles,
                    onFeedback: (widget as Ms16FabricaMultiAppUsuarios).onFeedback,
                  );
                },
              ),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF142033),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF00F3FF), width: 1.4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '📱 PASO 1: MIS APLICACIONES (${_apps.length} REGISTRADAS)',
                    style: const TextStyle(color: Color(0xFF00F3FF), fontSize: 11.5, fontWeight: FontWeight.w900),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBB400),
                      foregroundColor: const Color(0xFF071326),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    icon: Icon(_mostrarFormNuevaApp ? Icons.close : Icons.add_circle_outline, size: 15),
                    label: Text(
                      _mostrarFormNuevaApp ? 'CERRAR' : '➕ NUEVA APP',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
                    ),
                    onPressed: () => setState(() => _mostrarFormNuevaApp = !_mostrarFormNuevaApp),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_mostrarFormNuevaApp)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF030E21),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFBB400)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✨ REGISTRAR NUEVA APLICACIÓN EN MI FÁBRICA:',
                        style: TextStyle(color: Color(0xFFFBB400), fontSize: 11, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      _inputSimple('Nombre de la Nueva App (Ej: App Clínica Santa, App Colegio, App Taxi):', _ctrlNombreNuevaApp),
                      _inputSimple('Industria / Rubro:', _ctrlIndustriaNuevaApp),
                      _inputSimple('Objetivo Principal (PRD - ¿Qué problema resuelve?):', _ctrlObjetivoNuevaApp, maxLines: 2),
                      _inputSimple('Notas Generales o Ideas de esta App:', _ctrlNotasNuevaApp, maxLines: 2),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: const Color(0xFF071326),
                          ),
                          icon: const Icon(Icons.check_circle, size: 16),
                          label: const Text('GUARDAR NUEVA APP Y EMPEZAR A REGISTRAR SUS USUARIOS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
                          onPressed: _crearNuevaApp,
                        ),
                      ),
                    ],
                  ),
                ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_apps.length, (i) {
                    final Map a = Map.from(_apps[i] as Map);
                    final bool sel = _idxAppActiva == i;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _idxAppActiva = i;
                            _idxRolActivo = 0;
                            _cargarRolEnControladores();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel ? const Color(0xFFFBB400) : const Color(0xFF030E21),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: sel ? Colors.white : const Color(0xFF295186), width: 1.5),
                          ),
                          child: Text(
                            a['nombre_app'].toString(),
                            style: TextStyle(
                              color: sel ? const Color(0xFF071326) : Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (appActiva.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  '🎯 Objetivo PRD: ${appActiva['objetivo_vision_prd']}',
                  style: const TextStyle(color: Color(0xFFC2C6D3), fontSize: 11),
                ),
              ],
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF142033),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFBB400), width: 1.4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '👥 PASO 2: LISTA DE USUARIOS DE ESTA APP (${rolesDeEstaApp.length}) · TOCA UNO:',
                      style: const TextStyle(color: Color(0xFFFBB400), fontSize: 11.5, fontWeight: FontWeight.w900),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00509D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    icon: Icon(_mostrarFormNuevoRol ? Icons.close : Icons.person_add_alt_1, size: 15),
                    label: Text(
                      _mostrarFormNuevoRol ? 'CERRAR' : '➕ AGREGAR USUARIO',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
                    ),
                    onPressed: () => setState(() => _mostrarFormNuevoRol = !_mostrarFormNuevoRol),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_mostrarFormNuevoRol)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF030E21),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF00F3FF)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ctrlNombreNuevoRol,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          decoration: const InputDecoration(
                            hintText: 'Ej: Repartidor, Paciente, Profesor, Gerente, Invitado...',
                            hintStyle: TextStyle(color: Colors.white38, fontSize: 11),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), foregroundColor: Colors.black),
                        onPressed: _agregarNuevoRolAUnaApp,
                        child: const Text('CREAR ROL', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                ),

              ...List.generate(rolesDeEstaApp.length, (rIdx) {
                final Map r = Map.from(rolesDeEstaApp[rIdx] as Map);
                final bool activo = _idxRolActivo == rIdx;
                return InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _idxRolActivo = rIdx;
                      _cargarRolEnControladores();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: activo ? const Color(0xFF00509D) : const Color(0xFF030E21),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: activo ? const Color(0xFFFBB400) : const Color(0xFF2A3549),
                        width: activo ? 2.0 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(r['icono_avatar']?.toString() ?? '👤', style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${rIdx + 1}. ${r['nombre_rol']}',
                                style: TextStyle(
                                  color: activo ? const Color(0xFFFBB400) : Colors.white,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Login: ${r['metodo_login_acceso']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Color(0xFFC2C6D3), fontSize: 10.5),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: activo ? const Color(0xFFFBB400) : const Color(0xFF142033),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            activo ? '✏️ RESPONDIENDO' : 'TOCAR',
                            style: TextStyle(
                              color: activo ? const Color(0xFF071326) : const Color(0xFFA9C7FF),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        if (rolSeleccionado != null)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF101C2F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF00FF66), width: 1.6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎙️ PASO 3: ENTREVISTA COMPLETA PRD / RFC PARA: ${rolSeleccionado['nombre_rol']}',
                  style: const TextStyle(color: Color(0xFF00FF66), fontSize: 12.5, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Toca las sugerencias rápidas para insertarlas o escribe libremente en cada caja cómo actúa este usuario:',
                  style: TextStyle(color: Color(0xFFD7E3FD), fontSize: 11),
                ),
                const SizedBox(height: 12),

                _preguntaConChips(
                  numero: '1️⃣',
                  titulo: '¿Cómo entra a la App este usuario? (Login / Seguridad RFC):',
                  ctrl: _ctrl1Login,
                  sugerencias: const [
                    'Sin Login (Modo Invitado Libre)',
                    'PIN Secreto de 4 dígitos',
                    'Correo y Contraseña',
                    'Huella Biométrica / FaceID',
                    'Doble Candado SuperAdmin',
                  ],
                ),

                _preguntaConChips(
                  numero: '2️⃣',
                  titulo: '¿Cuáles son todas sus habilidades y su Historia de Usuario (Atlassian PRD)?:',
                  ctrl: _ctrl2Habilidades,
                  maxLines: 2,
                  sugerencias: const [
                    'Explorar catálogo y videos',
                    'Registrar clientes y pedidos',
                    'Aprobar o rechazar pagos',
                    'Escanear y quemar códigos QR',
                    'Votar en asambleas (+51%)',
                  ],
                ),

                _preguntaConChips(
                  numero: '3️⃣',
                  titulo: '¿Qué datos REGISTRA o crea en la base de datos (INSERT)?:',
                  ctrl: _ctrl3Registra,
                  maxLines: 2,
                  sugerencias: const [
                    'Registra su perfil y PIN',
                    'Registra ventas y facturas',
                    'Sube fotos de comprobantes',
                    'Registra votos certificados',
                    'Crea productos e inventario',
                  ],
                ),

                _preguntaConChips(
                  numero: '4️⃣',
                  titulo: '¿Qué pantallas o listas CONSULTA (SELECT Top-10 para 10,000M de usuarios)?:',
                  ctrl: _ctrl4Consulta,
                  maxLines: 2,
                  sugerencias: const [
                    'Buscador rápido LIMIT 10',
                    'Lista de sus propios premios QR',
                    'Ranking Top-10 Ganadores',
                    'Reporte general de ventas',
                    'Historial de auditoría',
                  ],
                ),

                _preguntaConChips(
                  numero: '5️⃣',
                  titulo: '¿Qué MODIFICA o ELIMINA (UPDATE / DELETE con pregunta Sí/No)?:',
                  ctrl: _ctrl5ModificaElimina,
                  maxLines: 2,
                  sugerencias: const [
                    'Edita su apodo y foto',
                    'Descuenta -1 del stock al entregar',
                    'Elimina con diálogo ¿Seguro Sí/No?',
                    'Aprueba o rechaza lotes pendientes',
                    'No puede borrar nada (Solo lectura)',
                  ],
                ),

                _preguntaConChips(
                  numero: '6️⃣',
                  titulo: '¿Qué TRANSACCIONES, pagos, cobros o transferencias realiza?:',
                  ctrl: _ctrl6Transacciones,
                  maxLines: 2,
                  sugerencias: const [
                    'Acumula y canjea puntos',
                    'Paga cuotas por QR bancario',
                    'Transfiere premios QR a otro usuario',
                    'Cobra en efectivo y QR en caja',
                    'Autoriza desembolsos con Regla Dual',
                  ],
                ),

                _preguntaConChips(
                  numero: '7️⃣',
                  titulo: '¿Qué IMPRIME o exporta en PDF / Tickets térmicos?:',
                  ctrl: _ctrl7Impresiones,
                  maxLines: 2,
                  sugerencias: const [
                    'Imprime recibo térmico 80mm',
                    'Exporta Credencial Digital en PDF',
                    'Descarga extracto de pagos PDF',
                    'Exporta Libro Maestro PRD/RFC en PDF',
                  ],
                ),

                _preguntaConChips(
                  numero: '8️⃣',
                  titulo: '⚙️ ¿CÓMO QUIERES QUE ACTÚE? (Lógica de Negocio Paso a Paso SI -> ENTONCES):',
                  ctrl: _ctrl8ComoActuaLogica,
                  maxLines: 3,
                  sugerencias: const [
                    'SI toca Guardar -> pregunta ¿Confirmar Sí/No? -> guarda en Supabase',
                    'SI no inició sesión -> abre Modal de Registro',
                    'CUANDO busca en lista -> consulta solo los primeros 10 (LIMIT 10)',
                    'SI stock == 0 -> bloquea botón y muestra alerta roja',
                  ],
                ),

                _preguntaConChips(
                  numero: '9️⃣',
                  titulo: '⚖️ Reglas Normativas RFC Editor (MUST Obligatorio / MUST NOT Prohibido):',
                  ctrl: _ctrl9ReglasRfcMust,
                  maxLines: 2,
                  sugerencias: const [
                    'MUST validar PIN antes de transferir',
                    'MUST usar LIMIT 10 en listas masivas',
                    'MUST NOT permitir cobros duplicados',
                    'MUST NOT mostrar pantallas de Admin a otros roles',
                  ],
                ),

                _preguntaConChips(
                  numero: '🔟',
                  titulo: '🎨 ¿Qué Componentes UX/UI usa en pantalla? (Ver Pantallas 3 a 7):',
                  ctrl: _ctrl10ComponentesUx,
                  maxLines: 2,
                  sugerencias: const [
                    'ElevatedButton + IconButton',
                    'TextField + Label + Link',
                    'AlertDialog ¿Registrar Sí/No?',
                    'ListView con Botones + Checkbox',
                    'GridView 2 Columnas + RadioButton',
                  ],
                ),

                _preguntaConChips(
                  numero: '📝',
                  titulo: '11. BLOC DE NOTAS LIBRES E IDEAS EXTRA (Por si algo no estaba en las preguntas):',
                  ctrl: _ctrl11NotasLibres,
                  maxLines: 3,
                  sugerencias: const [
                    'Agregar notificación por WhatsApp',
                    'Funcionar también en Modo Offline',
                    'Agregar lector de código de barras',
                    'Conectar con impresora Bluetooth',
                  ],
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBB400),
                          foregroundColor: const Color(0xFF071326),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.save, size: 18),
                        label: const Text('💾 GUARDAR ESTE USUARIO EN SUPABASE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
                        onPressed: _guardarRespuestasDelUsuarioActual,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C853),
                          foregroundColor: const Color(0xFF071326),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.picture_as_pdf, size: 18),
                        label: const Text('📄 EXPORTAR TODO EN PDF', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900)),
                        onPressed: () {
                          DespachadorAccionesSdui.generarYMostrarLibroPdfMultiApp(
                            context: context,
                            tituloPdf: 'Libro Maestro PRD + RFC: ${appActiva['nombre_app'] ?? 'Multi-App'}',
                            appsRegistradas: _apps,
                            rolesRegistrados: _roles,
                            onFeedback: (widget as Ms16FabricaMultiAppUsuarios).onFeedback,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _inputSimple(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFA9C7FF), fontSize: 10.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF142033),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _preguntaConChips({
    required String numero,
    required String titulo,
    required TextEditingController ctrl,
    required List sugerencias,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF030E21),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF295186)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$numero $titulo',
              style: const TextStyle(color: Color(0xFFFBB400), fontSize: 11.5, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: sugerencias.map((sug) {
                final String sTxt = sug.toString();
                return InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      if (ctrl.text.trim().isEmpty) {
                        ctrl.text = sTxt;
                      } else if (!ctrl.text.contains(sTxt)) {
                        ctrl.text = '${ctrl.text.trim()} | $sTxt';
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF142033),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFF00F3FF).withAlpha(120)),
                    ),
                    child: Text(
                      '+ $sTxt',
                      style: const TextStyle(color: Color(0xFFA9C7FF), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: ctrl,
              maxLines: maxLines,
              style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.35),
              decoration: InputDecoration(
                hintText: 'Escribe aquí tu respuesta o toca las opciones de arriba...',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 11),
                filled: true,
                fillColor: const Color(0xFF142033),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}