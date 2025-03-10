import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String usuario =
        "Usuario123"; // Aquí puedes cargar el usuario real desde tu base de datos

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Perfil"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para editar la imagen
              },
              child: const Text("Editar imagen"),
            ),
            const SizedBox(height: 40),
            const Text(
              "Usuario",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              usuario.isNotEmpty ? usuario : "Sin usuario",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
