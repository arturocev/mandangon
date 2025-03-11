import 'package:flutter/material.dart'; 
import '../metodos_lc/agregar_prod.dart';
import '../metodos_lc/eliminar_prod.dart';
import '../metodos_lc/confirmar_lc.dart'; 

class LCScreen extends StatefulWidget {
  final bool editable; // Indica si la lista es editable o no.
  final Map<String, dynamic> lista; // Datos de la lista de compras, como el nombre y los productos.
  final Function(String, List<String>) onConfirm; // Función para manejar la confirmación de la lista.

  const LCScreen({
    super.key,
    required this.editable,
    required this.lista,
    required this.onConfirm,
  });

  @override
  LCEstado createState() => LCEstado();
}

class LCEstado extends State<LCScreen> {
  TextEditingController nombreController = TextEditingController(); // Controlador para el nombre de la lista.
  List<String> productos = []; // Lista que almacenará los productos de la lista de compras.
  TextEditingController productoController = TextEditingController(); // Controlador para agregar productos.

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.lista["nombre"]; // Inicializa el nombre de la lista con los datos pasados.
    productos = List<String>.from(widget.lista["productos"]); // Inicializa la lista de productos.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Compras"), // Título en la barra de la aplicación.
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Padding alrededor del contenido del cuerpo.
        child: Column(
          children: [
            // Campo de texto para modificar el nombre de la lista.
            TextField(
              controller: nombreController, // Controlador del nombre.
              decoration: const InputDecoration(labelText: "Nombre de la Lista"), // Etiqueta de entrada.
              style: const TextStyle(fontSize: 18), // Estilo de la fuente.
            ),
            const SizedBox(height: 20), // Espacio entre los elementos.

            // Si la lista es editable, permite agregar productos.
            if (widget.editable)
              TextField(
                controller: productoController, // Controlador para el producto.
                decoration: const InputDecoration(labelText: "Producto"), // Etiqueta del campo de producto.
                onSubmitted: (_) => agregarProducto(productoController, productos, setState), // Acción al enviar el producto.
              ),
            const SizedBox(height: 20), // Espacio entre los elementos.

            // Si la lista es editable, muestra un botón para agregar un producto.
            if (widget.editable)
              ElevatedButton(
                onPressed: () => agregarProducto(productoController, productos, setState), // Acción para agregar un producto.
                child: const Text("Agregar Producto"), // Texto del botón.
              ),
            const SizedBox(height: 20), // Espacio entre los elementos.

            // Muestra los productos de la lista.
            Expanded(
              child: ListView.builder(
                itemCount: productos.length, // Número de productos en la lista.
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(productos[index]), // Muestra el nombre del producto.
                    trailing: widget.editable
                        ? IconButton(
                            icon: const Icon(Icons.delete), // Icono de eliminar.
                            onPressed: () => eliminarProducto(index, productos, setState), // Acción al presionar el icono de eliminar.
                          )
                        : null, // Si no es editable, no muestra el icono de eliminar.
                  );
                },
              ),
            ),

            // Si la lista es editable, muestra un botón para guardar la lista.
            if (widget.editable)
              ElevatedButton(
                onPressed: () => confirmarLista(context, widget.lista, productos, widget.onConfirm), // Confirma la lista.
                child: const Text("Guardar Lista"), // Texto del botón.
              ),
          ],
        ),
      ),
    );
  }
}
