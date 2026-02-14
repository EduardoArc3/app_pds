import 'package:app_pds/services/database_service.dart';
import 'package:flutter/material.dart';
import 'screens/InitialSplash.dart';

void main() async {
  // inicializar base de datos
  await DatabaseService.instance.initDB();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Initialsplash(),
    );
  }
}
