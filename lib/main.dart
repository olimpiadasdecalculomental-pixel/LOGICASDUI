import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nucleo/orquestador_sdui.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0505),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orangeAccent),
        ),
        child: const Text(
          'Escudo LOGICASDUI Activo: Componente aislado de forma segura.',
          style: TextStyle(color: Colors.white70, fontSize: 11),
        ),
      );
    };
    runApp(const LogicaSduiMultiApp());
  }, (error, stack) {
    debugPrint('Escudo Global LOGICASDUI: $error');
  });
}

class LogicaSduiMultiApp extends StatelessWidget {
  const LogicaSduiMultiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LOGICA SDUI - Fábrica Multi-App PRD, RFC y UX/UI (Esquema 1)',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF071326),
      ),
      home: const LienzoMaestroSdui(),
    );
  }
}