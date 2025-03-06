import 'package:flutter/material.dart';
import 'restaurantes.dart'; // Importa la pantalla de restaurantes

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFG',
      home: const MyHomePage(title: 'Mandangon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Índice para controlar la navegación

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      // Si se presiona "Restaurantes"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RestaurantesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Recetas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Restaurantes",
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
