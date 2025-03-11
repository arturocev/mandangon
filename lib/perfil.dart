import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String usuario = "Usuario123"; // Simulación de usuario cargado

  Future<void> _pickImage() async {
    XFile? selectedImage;

    if (kIsWeb) {
      selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    } else {
      selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    }

    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Perfil"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: _image != null
                  ? (kIsWeb
                      ? NetworkImage(_image!.path) as ImageProvider
                      : FileImage(File(_image!.path)))
                  : const AssetImage("assets/images/avatar.png"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Editar imagen"),
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
