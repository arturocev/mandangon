import 'package:flutter/material.dart';
import 'recetas_screen.dart';

class NavigationWrapper extends StatefulWidget {
  final int selectedIndex;

  const NavigationWrapper({super.key, required this.selectedIndex});

  @override
  NavigationWrapperState createState() => NavigationWrapperState();
}

class NavigationWrapperState extends State<NavigationWrapper> {
  int currentIndex = 0;

  final List<Widget> screens = [
    Center(child: Text("Pantalla de Inicio")),
    RecetasScreen(),
    Center(child: Text("Pantalla de Restaurantes")),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.selectedIndex;
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(["Inicio", "Recetas", "Restaurantes"][currentIndex]),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), label: "Recetas"),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant), label: "Restaurantes"),
        ],
        onTap: onTabTapped,
      ),
    );
  }
}
