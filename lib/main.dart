import 'package:flutter/material.dart';
import 'ajustes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandangon',
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
  int _selectedIndex = 0;
  bool _showSettings = false;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Inicio')),
    Center(child: Text('Recetas')),
    Center(child: Text('Restaurantes')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showSettings = false;
    });
  }

  void _toggleSettings() {
    setState(() {
      _showSettings = !_showSettings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _showSettings
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _toggleSettings,
              )
            : null,
        title: _showSettings ? null : Text(widget.title),
        actions: _showSettings
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: _toggleSettings,
                ),
              ],
      ),
      body: _showSettings
          ? AjustesScreen(onClose: _toggleSettings)
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
