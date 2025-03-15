import 'package:flutter/material.dart';
import 'recetas_screen.dart';

class NavigationWrapper extends StatefulWidget {
  // Recibe el índice de la pantalla seleccionada inicialmente
  final int selectedIndex;

  const NavigationWrapper({super.key, required this.selectedIndex});

  @override
  NavigationWrapperState createState() => NavigationWrapperState();
}

class NavigationWrapperState extends State<NavigationWrapper> {
  // Variable para almacenar el índice de la pantalla actual
  int currentIndex = 0;

  // Lista de pantallas que se pueden mostrar en el cuerpo del Scaffold
  final List<Widget> screens = [
    Center(child: Text("Pantalla de Inicio")),
    RecetasScreen(),
    Center(child: Text("Pantalla de Restaurantes")),
  ];

  @override
  void initState() {
    super.initState();
    // Se inicializa currentIndex con el valor pasado como parámetro
    currentIndex = widget.selectedIndex;
  }

  // Método que se llama cuando el usuario selecciona un nuevo índice
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index; // Se actualiza el índice actual con el seleccionado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // El título del AppBar cambia según la pantalla seleccionada
        title: Text(["Inicio", "Recetas", "Restaurantes"][currentIndex]),
      ),
      body: screens[
          currentIndex], // Muestra la pantalla correspondiente al índice actual
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            currentIndex, // Establece el índice actual en la barra de navegación
        items: const [
          // Elementos de la barra de navegación con iconos y etiquetas
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), label: "Recetas"),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant), label: "Restaurantes"),
        ],
        onTap:
            onTabTapped, // Llama al método onTabTapped cuando el usuario cambia de pestaña
      ),
    );
  }
}
