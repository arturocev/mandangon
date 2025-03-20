import 'package:flutter/material.dart';
import 'screens/navigation_wrapper.dart';

void main() {
  runApp(const MandangonApp());
}

class MandangonApp extends StatelessWidget {
  const MandangonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandangon',
      home: const NavigationWrapper(selectedIndex: 1),
      debugShowCheckedModeBanner: false,
    );
  }
}
