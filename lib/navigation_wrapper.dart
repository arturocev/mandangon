import 'package:flutter/material.dart';
import 'recetas_screen.dart';

class NavigationWrapper extends StatefulWidget {
  final int selectedIndex;

  const NavigationWrapper({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _NavigationWrapperState createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Center(child: Text("Pantalla de Inicio")),
    RecetasScreen(),
    Center(child: Text("Pantalla de Restaurantes")), 
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Column(
        children: [
          Expanded(child: _screens[_currentIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Recetas"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Restaurantes"),
        ],
        onTap: _onTabTapped,
      ),
    );
  }
}