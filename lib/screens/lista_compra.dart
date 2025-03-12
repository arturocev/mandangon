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
        title: const Text("Lista de Compras"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Campo para editar el nombre de la lista.
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre de la Lista"),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Si es editable, permite agregar productos.
            if (widget.editable)
              TextField(
                controller: productoController,
                decoration: const InputDecoration(labelText: "Producto"),
                onSubmitted: (_) =>
                    agregarProducto(productoController, productos, setState),
              ),
            const SizedBox(height: 20),
            if (widget.editable)
              ElevatedButton(
                onPressed: () =>
                    agregarProducto(productoController, productos, setState),
                child: const Text("Agregar Producto"),
              ),
            const SizedBox(height: 20),
            // Muestra la lista de productos.
            Expanded(
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(productos[index]),
                    trailing: widget.editable
                        ? IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => eliminarProducto(
                                index, productos, setState),
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
                child: const Text("Guardar Lista"),
              ),
          ],
        ),
      ),
    );
  }
}
