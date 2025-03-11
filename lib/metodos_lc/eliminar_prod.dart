void eliminarProducto(int index, List<String> productos, Function setState) {
  // Actualizamos el estado de la lista de productos usando la función setState
  setState(() {
    // Eliminamos el producto en el índice especificado de la lista
    productos.removeAt(index);
  });
}
