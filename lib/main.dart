import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'screens/home_screen.dart';

void main() {
  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
    throw UnsupportedError(
      "Esta aplicação é suportada apenas em plataformas desktop.",
    );
  }

  print("Inicializando o Flutter...");
  WidgetsFlutterBinding.ensureInitialized(); 
  print("Flutter inicializado.");
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  print("Banco de dados inicializado.");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cervantes APP - CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
