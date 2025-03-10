import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necesario para usar los filtros de entrada
import 'package:http/http.dart' as http;

class LCScreen extends StatefulWidget {
  final bool editable;
  final Map<String, dynamic> lista;
  final Function(String, List<String>) onConfirm;

  const LCScreen({super.key, required this.editable, required this.lista, required this.onConfirm});

  @override
  LCEstado createState() => LCEstado();
}

class LCEstado extends State<LCScreen> {
  TextEditingController nombreController = TextEditingController();
  List<String> productos = [];
  TextEditingController productoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.lista["nombre"];
    productos = List<String>.from(widget.lista["productos"]);
  }

  void agregarProducto() {
    String producto = productoController.text.trim();

    if (producto.isEmpty) {
      return;
    }

    setState(() {
      productos.add(producto);
      productoController.clear();
    });
  }

  // 🗑 Función para eliminar un producto
  void eliminarProducto(int index) {
    setState(() {
      productos.removeAt(index);
    });
  }

void confirmarLista() async {
  String nombre = nombreController.text.trim();
  String productosString = productos.join(", "); // Convertir lista a string separado por comas

  print("1. Confirmando lista con nombre: $nombre y productos: $productosString");

  try {
    // Enviar los datos en formato JSON
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/guardar_lista.php'),
      headers: {
        'Content-Type': 'application/json', // Asegúrate de enviar el contenido como JSON
      },
      body: jsonEncode({
        'nombre': nombre,
        'productos': productos, // Enviar la lista de productos directamente (no como string)
      }),
    );

    print("2. Respuesta recibida: ${response.statusCode}");
    print("3. Respuesta del servidor: ${response.body}");

    if (response.statusCode == 200) {
      if (response.body.contains("Lista guardada correctamente")) {
        print("4. Lista guardada correctamente.");
        widget.onConfirm(nombre, productos);
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        print("5. La respuesta del servidor no es la esperada: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al guardar la lista. Intente de nuevo.")),
        );
      }
    } else {
      print("6. Error al guardar la lista. Código de estado: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar la lista. Intente de nuevo.")),
      );
    }
  } catch (e) {
    print("7. Error en la solicitud HTTP: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No se pudo conectar con el servidor.")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Compras"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre de la Lista"),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            if (widget.editable)
              TextField(
                controller: productoController,
                decoration: const InputDecoration(labelText: "Producto"),
                onSubmitted: (_) => agregarProducto(),
              ),
            const SizedBox(height: 20),
            if (widget.editable)
              ElevatedButton(
                onPressed: agregarProducto,
                child: const Text("Agregar Producto"),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(productos[index]),
                    trailing: widget.editable
                        ? IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => eliminarProducto(index),
                          )
                        : null,
                  );
                },
              ),
            ),
            if (widget.editable)
              ElevatedButton(
                onPressed: confirmarLista,
                child: const Text("Guardar Lista"),
              ),
          ],
        ),
      ),
    );
  }
}
