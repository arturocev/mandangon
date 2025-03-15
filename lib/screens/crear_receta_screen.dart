import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class CrearRecetaScreen extends StatefulWidget {
  final Map<String, String>?
      receta; // Recibe una receta si se está editando una existente

  const CrearRecetaScreen({super.key, this.receta});

  @override
  CrearRecetaScreenState createState() => CrearRecetaScreenState();
}

class CrearRecetaScreenState extends State<CrearRecetaScreen> {
  final _formKey = GlobalKey<FormState>(); // Clave para validar el formulario
  late TextEditingController tituloController;
  late TextEditingController tipoController;
  late TextEditingController instruccionesController;
  late TextEditingController tiempoController;
  String? imagenPath;
  bool subiendo = false;

  // Lista para almacenar los ingredientes
  List<String> ingredientes = [];
  TextEditingController ingredienteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con valores si se está editando una receta existente
    tituloController =
        TextEditingController(text: widget.receta?['titulo'] ?? '');
    tipoController = TextEditingController(text: widget.receta?['tipo'] ?? '');
    instruccionesController =
        TextEditingController(text: widget.receta?['instrucciones'] ?? '');
    tiempoController =
        TextEditingController(text: widget.receta?['tiempo'] ?? '');
    imagenPath = widget.receta?['imagen'];
  }

  @override
  void dispose() {
    // Liberar recursos al cerrar la pantalla
    tituloController.dispose();
    tipoController.dispose();
    instruccionesController.dispose();
    tiempoController.dispose();
    ingredienteController.dispose();
    super.dispose();
  }

  // Método para seleccionar una imagen desde la galería
  Future<void> seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      setState(() {
        imagenPath = imagen.path;
      });
    }
  }

  // Método para mostrar la imagen seleccionada
  Widget mostrarImagen() {
    if (imagenPath == null || imagenPath!.isEmpty) {
      return Center(
          child: Container(
        width: 150,
        height: 150,
        color: Colors.grey[300],
        child: Icon(Icons.image,
            color: const Color.fromARGB(255, 97, 97, 97), size: 100),
      ));
    }

    if (kIsWeb) {
      return Center(
          child: Image.network(
        imagenPath!,
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      ));
    } else {
      return Center(
          child: Image.file(
        File(imagenPath!),
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      ));
    }
  }

  // Método para guardar la receta en la base de datos
  Future<void> guardarReceta() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      subiendo = true;
    });

    String? imagenBase64;
    if (imagenPath != null && !kIsWeb) {
      List<int> imageBytes = await File(imagenPath!).readAsBytes();
      imagenBase64 = base64Encode(imageBytes);
    }

    var url = widget.receta == null
        ? Uri.parse(
            "http://localhost/guardar_receta.php") // Guardar nueva receta
        : Uri.parse(
            "http://localhost/actualizar_receta.php"); // Actualizar receta existente

    http.Response respuesta = await http.post(url, body: {
      'rec_id': widget.receta?['id_rec'] ?? '',
      'rec_nom': tituloController.text,
      'rec_tipo_com': tipoController.text,
      'rec_ing': ingredientes.join(', '),
      'rec_desc': instruccionesController.text,
      'rec_tmp': tiempoController.text,
      'rec_img': imagenBase64 ?? '',
      'rec_usu': 'usuario_demo' // Usuario predeterminado
    });

    if (!mounted) return;

    if (respuesta.statusCode == 200) {
      // Si la receta se guarda correctamente, se devuelve la información a la pantalla anterior
      Map<String, String> recetaGuardada = {
        'id_rec': widget.receta?['id_rec'] ?? 'nuevo',
        'titulo': tituloController.text,
        'tipo': tipoController.text,
        'ingredientes': ingredientes.join(', '),
        'instrucciones': instruccionesController.text,
        'tiempo': tiempoController.text,
        'imagen': imagenPath ?? '',
      };

      Navigator.pop(context, recetaGuardada);
    } else {
      debugPrint("Error al guardar o actualizar la receta");
      // Mostrar error al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar o actualizar la receta')),
      );
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

  // Método para eliminar un ingrediente de la lista
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
              image: AssetImage("assets/images/receta.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                  _campoTexto(
                    label: "Título",
                    controller: tituloController,
                    hintText: "Ejemplo: Tarta de chocolate",
                  ),
                  SizedBox(height: 15),
                  _campoTexto(
                    label: "Tipo de comida",
                    controller: tipoController,
                    hintText: "Ejemplo: Postre",
                  ),
                  SizedBox(height: 15),
                  // Lista de ingredientes
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: ingredienteController,
                          decoration: InputDecoration(
                            labelText: "Ingrediente",
                            hintText: "Ejemplo: 2 huevos",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: agregarIngrediente,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Mostrar lista de ingredientes
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: ingredientes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(ingredientes[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => eliminarIngrediente(index),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  _campoTexto(
                    label: "Instrucciones",
                    controller: instruccionesController,
                    hintText: "Escribe los pasos de la receta...",
                    maxLines: 5,
                  ),
                  SizedBox(height: 15),
                  _campoTexto(
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

  Widget _campoTexto({
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
          hintStyle: TextStyle(color: Colors.black),
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder()),
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Este campo es obligatorio";
        }
        if ((label == "Título" || label == "Tipo de comida") &&
            !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
          return "Solo se permiten letras y espacios";
        }
        return null;
      },
    );
  }
}
