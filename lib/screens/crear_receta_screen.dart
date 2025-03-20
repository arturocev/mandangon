import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class CrearRecetaScreen extends StatefulWidget {
  final Map<String, String>? receta; // Recibe una receta si se está editando

  const CrearRecetaScreen({super.key, this.receta});

  @override
  CrearRecetaScreenState createState() => CrearRecetaScreenState();
}

class CrearRecetaScreenState extends State<CrearRecetaScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController tituloController;
  late TextEditingController tipoController;
  late TextEditingController instruccionesController;
  late TextEditingController tiempoController;
  // Para Web usaremos imagenFile; imagenPath se usará para mostrar información
  XFile? imagenFile;
  String? imagenPath;
  bool subiendo = false;

  // Lista para almacenar los ingredientes
  List<String> ingredientes = [];
  TextEditingController ingredienteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tituloController =
        TextEditingController(text: widget.receta?['titulo'] ?? '');
    tipoController = TextEditingController(text: widget.receta?['tipo'] ?? '');
    instruccionesController =
        TextEditingController(text: widget.receta?['instrucciones'] ?? '');
    tiempoController =
        TextEditingController(text: widget.receta?['tiempo'] ?? '');
    imagenPath = widget.receta?['imagen'];

    // Si se está editando y existen ingredientes guardados, convertir la cadena a lista
    if (widget.receta != null &&
        widget.receta?['ingredientes'] != null &&
        widget.receta!['ingredientes']!.isNotEmpty) {
      ingredientes = widget.receta!['ingredientes']!.split(', ');
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    tipoController.dispose();
    instruccionesController.dispose();
    tiempoController.dispose();
    ingredienteController.dispose();
    super.dispose();
  }

  // Método para seleccionar imagen (compatible con Web)
  Future<void> seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        imagenFile = imagen;
        // En Web, usamos el nombre de la imagen para mostrarla (no se puede usar la ruta local)
        imagenPath = imagen.name;
      });
    }
  }

  // Método para mostrar la imagen seleccionada
  Widget mostrarImagen() {
    if (imagenFile == null && (imagenPath == null || imagenPath!.isEmpty)) {
      return Center(
        child: Container(
          width: 150,
          height: 150,
          color: Colors.grey[300],
          child: Icon(Icons.image, color: Colors.white, size: 100),
        ),
      );
    }

    if (kIsWeb) {
      return Center(
        child: FutureBuilder<Uint8List>(
          future: imagenFile!.readAsBytes(), // Leer la imagen como bytes
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Image.memory(snapshot.data!,
                  width: 150, height: 150, fit: BoxFit.cover);
            } else {
              return CircularProgressIndicator(); // Indicador de carga
            }
          },
        ),
      );
    } else {
      return Center(
        child: Image.file(
          File(imagenFile!.path),
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  // Método para guardar la receta usando Multipart (para Web se envía la imagen como bytes)
  Future<void> guardarReceta() async {
    if (!formKey.currentState!.validate()) return;

    // Validar que se haya seleccionado una imagen
    if (imagenFile == null && (imagenPath == null || imagenPath!.isEmpty)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Debe seleccionar una imagen")));
      return;
    }

    // Validar que la lista de ingredientes tenga al menos un elemento
    if (ingredientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Debe agregar al menos un ingrediente")));
      return;
    }

    setState(() {
      subiendo = true;
    });

    var url = widget.receta == null
        ? Uri.parse("http://localhost/guardar_receta.php")
        : Uri.parse("http://localhost/actualizar_receta.php");

    var request = http.MultipartRequest('POST', url);

    // Agregar campos de texto
    request.fields['rec_nom'] = tituloController.text;
    request.fields['rec_tipo_com'] = tipoController.text;
    request.fields['rec_ing'] = ingredientes.join(', ');
    request.fields['rec_desc'] = instruccionesController.text;
    request.fields['rec_tmp'] = tiempoController.text;
    request.fields['rec_usu'] = '10';

    // Si se trata de una actualización, se envía el nombre original de la receta
    if (widget.receta != null) {
      request.fields['rec_nom_original'] = widget.receta!['titulo'] ?? '';
    }

    // Agregar el archivo de imagen
    if (imagenFile != null) {
      try {
        if (kIsWeb) {
          // Para Web, leemos los bytes del archivo
          Uint8List bytes = await imagenFile!.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'rec_img',
            bytes,
            filename: imagenFile!.name,
          ));
        } else {
          request.files
              .add(await http.MultipartFile.fromPath('imagen', imagenPath!));
        }
      } catch (e) {
        print("Error al adjuntar la imagen: $e");
      }
    }

    // Enviar la solicitud
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print("Respuesta del servidor: ${response.body}");

    if (response.statusCode == 200) {
      // Se espera que el servidor retorne un JSON con un mensaje, por ejemplo:
      // "Imagen subida (BLOB - 123456 bytes) y datos guardados exitosamente."
      var data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message'] ?? 'Imagen subida correctamente')));

      Map<String, String> recetaGuardada = {
        'titulo': tituloController.text,
        'tipo': tipoController.text,
        'ingredientes': ingredientes.join(', '),
        'instrucciones': instruccionesController.text,
        'tiempo': tiempoController.text,
        'rec_img': imagenPath ?? '',
      };

      Navigator.pop(context, recetaGuardada);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar o actualizar la receta')));
    }

    if (!mounted) return;
    setState(() {
      subiendo = false;
    });
  }

  // Método para agregar un ingrediente a la lista
  void agregarIngrediente() {
    setState(() {
      if (ingredienteController.text.isNotEmpty) {
        ingredientes.add(ingredienteController.text);
        ingredienteController.clear();
      }
    });
  }

  // Método para eliminar un ingrediente
  void eliminarIngrediente(int index) {
    setState(() {
      ingredientes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receta == null ? "Nueva Receta" : "Editar Receta"),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/recetas.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mostrarImagen(),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: seleccionarImagen,
                      child: Text("Seleccionar Imagen"),
                    ),
                  ),
                  SizedBox(height: 20),
                  campoTexto(
                    label: "Título",
                    controller: tituloController,
                    hintText: "Ejemplo: Tarta de chocolate",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                    ],
                  ),
                  SizedBox(height: 15),
                  campoTexto(
                    label: "Tipo de comida",
                    controller: tipoController,
                    hintText: "Ejemplo: Postre",
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                    ],
                  ),
                  SizedBox(height: 15),
                  // Campo para agregar ingredientes
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: ingredienteController,
                          decoration: InputDecoration(
                            labelText: "Ingrediente",
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: "Ejemplo: 2 huevos",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: agregarIngrediente,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Lista de ingredientes
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: ingredientes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(ingredientes[index],
                            style: TextStyle(color: Colors.white)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () => eliminarIngrediente(index),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  campoTexto(
                    label: "Instrucciones",
                    controller: instruccionesController,
                    hintText: "Escribe los pasos de la receta...",
                    maxLines: 5,
                  ),
                  SizedBox(height: 15),
                  campoTexto(
                    label: "Tiempo estimado (minutos)",
                    controller: tiempoController,
                    hintText: "Ejemplo: 30",
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: subiendo
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: guardarReceta,
                            child: Text(widget.receta == null
                                ? 'Guardar Receta'
                                : 'Actualizar Receta'),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget campoTexto({
    required String label,
    required TextEditingController controller,
    required String hintText,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
      ),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }
}
