import 'package:flutter/material.dart';
import '../metodos_lc/agregar_prod.dart';
import '../metodos_lc/eliminar_prod.dart';
import '../metodos_lc/confirmar_lc.dart';

class LCScreen extends StatefulWidget {
  final bool editable; // Indica si la lista es editable o no.
  final Map<String, dynamic> lista; // Datos de la lista de compras.
  final Function(String, List<String>) onConfirm; // Función para confirmar la lista.
  final int usuarioId; // ID del usuario que ha iniciado sesión

  const LCScreen({
    super.key,
    required this.editable,
    required this.lista,
    required this.onConfirm,
    required this.usuarioId, // Ahora es obligatorio
  });

  @override
  LCEstado createState() => LCEstado();
}

class LCEstado extends State<LCScreen> {
  TextEditingController nombreController = TextEditingController();
  List<String> productos = []; // Lista de productos
  TextEditingController productoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.lista["nombre"]; // Inicializa el nombre
    productos = List<String>.from(widget.lista["productos"]); // Inicializa los productos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF9E4B7), // Color cálido para la AppBar
        title: const Text("Lista de Compras", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Campo para editar el nombre de la lista.
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: "Nombre de la Lista",
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.orange[50],  // Fondo suave de color cálido para el campo
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Si es editable, permite agregar productos.
            if (widget.editable)
              TextField(
                controller: productoController,
                decoration: InputDecoration(
                  labelText: "Producto",
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.orange[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSubmitted: (_) =>
                    agregarProducto(productoController, productos, setState),
              ),
            const SizedBox(height: 20),

            if (widget.editable)
              ElevatedButton(
                onPressed: () =>
                    agregarProducto(productoController, productos, setState),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 80, 255, 220),  // Fondo verde para el botón
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 18, 1, 66)
                  ),
                ),
                child: const Text("Agregar Producto"),
              ),
            const SizedBox(height: 20),

            // Muestra la lista de productos.
            Expanded(
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(productos[index], style: TextStyle(fontSize: 18)),
                    trailing: widget.editable
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Color.fromARGB(255, 133, 19, 10)),
                            onPressed: () => eliminarProducto(index, productos, setState),
                          )
                        : null,
                  );
                },
              ),
            ),

            // Botón para guardar la lista.
            if (widget.editable)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.lista["nombre"] = nombreController.text;
                  });
                  // Llama a la función de confirmación y pasa además el usuarioId.
                  // Asegúrate de que la función confirmarLista esté preparada para recibir este parámetro.
                  confirmarLista(context, widget.lista, productos, widget.onConfirm, widget.usuarioId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 36, 230, 43),  // Fondo verde para el botón
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 10, 56, 1)
                  ),
                ),
                child: const Text("Guardar Lista"),
              ),
          ],
        ),
      ),
    );
  }
}
