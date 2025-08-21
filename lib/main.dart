import 'package:flutter/material.dart';
import 'screens/habbits_progreso_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita la etiqueta "DEBUG"
      title: 'Habits Progreso',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HabbitsProgresoScreen(), // Pantalla principal
    );
  }
}
