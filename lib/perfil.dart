import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class PerfilScreen extends StatefulWidget {
  final int userId; // ID del usuario
  final String usuario; // Nombre del usuario

  const PerfilScreen({Key? key, required this.userId, required this.usuario})
      : super(key: key);

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });

      // Subir la imagen al servidor
      await _uploadImage(File(_image!.path));
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://localhost/guardar_foto.php'),
    );

    // Agregar el ID del usuario
    request.fields['id_usu'] = widget.userId.toString();

    // Detectar el tipo MIME del archivo
    String mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

    // Agregar la imagen al request
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      ),
    );

    // Enviar la petición al servidor
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Imagen subida correctamente');
    } else {
      print('Error al subir la imagen');
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
              widget.usuario.isNotEmpty ? widget.usuario : "Sin usuario",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
