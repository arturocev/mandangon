import 'package:flutter/material.dart'; 

void agregarProducto(TextEditingController productoController, List<String> productos, Function setState) {
  // Recupera el texto del controlador de producto y elimina los espacios innecesarios al principio y al final.
  String producto = productoController.text.trim();

  // Si el texto del producto está vacío, no hace nada y simplemente regresa de la función.
  if (producto.isEmpty) {
    return;
  }

  // Si el producto no está vacío, actualiza el estado de la lista de productos.
  setState(() {
    productos.add(producto); // Agrega el producto a la lista de productos.
    productoController.clear(); // Limpia el controlador para que el campo de texto se quede vacío.
  });
}
