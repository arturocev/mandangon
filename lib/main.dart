import 'package:flutter/material.dart';
import 'navigation_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFG',
      home: const NavigationWrapper(selectedIndex: 1), // Comienza en la pantalla de recetas
    );
  }
}