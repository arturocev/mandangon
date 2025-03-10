import 'dart:convert';

import 'package:flutter/material.dart';
// Import necesario para usar los filtros de entrada
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

  // Depuración: Verificar el id_list antes de enviar la solicitud
  print("ID de la lista antes de enviar: ${widget.lista["id_list"]}");
  print("Nombre de la lista: $nombre");
  print("Productos: $productos");

  try {
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/guardar_lista.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_list': widget.lista["id_list"] ?? 0, // Asegúrate de enviar el id_list correcto
        'nombre': nombre,
        'productos': productos, // Enviar la lista de productos
      }),
    );

    // Depuración: Verificar la respuesta del servidor
    print("Respuesta del servidor: ${response.body}");
    print("Código de estado: ${response.statusCode}");

    if (response.statusCode == 200) {
      // Parsear la respuesta JSON
      final responseData = json.decode(response.body);

      // Verificar el estado en la respuesta JSON
      if (responseData["status"] == "success") {
        widget.onConfirm(nombre, productos);
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al guardar la lista. Intente de nuevo.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar la lista. Intente de nuevo.")),
      );
    }
  } catch (e) {
    // Depuración: Capturar errores de conexión
    print("Error en la solicitud HTTP: $e");
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