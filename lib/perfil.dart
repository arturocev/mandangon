import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class PerfilScreen extends StatefulWidget {
  final int userId;
  final String usuarios;

  const PerfilScreen({super.key, required this.userId, required this.usuarios});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  Uint8List? _webImage;
  final String _serverUrl = "http://192.168.1.15";
  // Cambia esto por tu IP del servidor

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      if (kIsWeb) {
        _webImage = await selectedImage.readAsBytes();
      }
      setState(() {
        _image = selectedImage;
      });

      bool success = await _uploadImage(selectedImage);
      if (success) {
        _showMessage("✅ Imagen subida correctamente");
      } else {
        _showMessage("❌ Error al subir la imagen");
      }
    }
  }

  Future<bool> _uploadImage(XFile imageFile) async {
    try {
      var uri = Uri.parse('$_serverUrl/guardar_foto.php');
      var request = http.MultipartRequest('POST', uri);
      request.fields['id_usu'] = widget.userId.toString();

      String mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      var mimeTypeSplit = mimeType.split('/');

      if (kIsWeb) {
        var imageBytes = await imageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: imageFile.name,
            contentType: MediaType(mimeTypeSplit[0], mimeTypeSplit[1]),
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType(mimeTypeSplit[0], mimeTypeSplit[1]),
          ),
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("🔹 Respuesta del servidor: $responseBody");

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error al subir la imagen: $e");
      return false;
    }
  }

  Future<void> _deleteImage() async {
    bool confirmDelete = await _confirmDeleteDialog();
    if (!confirmDelete) return;

    try {
      var response = await http.post(
        Uri.parse('$_serverUrl/eliminar_foto.php'),
        body: {'id_usu': widget.userId.toString()},
      );

      var responseBody = response.body;
      print("🔹 Respuesta al eliminar: $responseBody");

      if (response.statusCode == 200) {
        setState(() {
          _image = null;
          _webImage = null;
        });
        _showMessage("✅ Imagen eliminada correctamente");
      } else {
        _showMessage("❌ Error al eliminar la imagen");
      }
    } catch (e) {
      print("❌ Error al eliminar la imagen: $e");
      _showMessage("❌ Error al eliminar la imagen");
    }
  }

  Future<bool> _confirmDeleteDialog() async {
    return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Eliminar imagen"),
              content: const Text(
                  "¿Estás seguro de que deseas eliminar tu foto de perfil?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Eliminar",
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Hacer foto desde la cámara"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Sacar foto desde la galería"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_image != null || _webImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Eliminar foto",
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteImage();
                },
              ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Cancelar"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
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
              backgroundImage: _webImage != null
                  ? MemoryImage(_webImage!)
                  : _image != null
                      ? FileImage(File(_image!.path)) as ImageProvider
                      : const AssetImage("assets/images/avatar.png"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showImageOptions,
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
              widget.usuarios.isNotEmpty ? widget.usuarios : "Sin usuario",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
