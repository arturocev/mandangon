import 'package:flutter/material.dart';
import 'package:mandangon/metodos_lc/eliminar_lc.dart';  // Importamos el método para eliminar la lista de la base de datos

// Función para confirmar la eliminación de una lista de compras
void confirmarEliminacion(BuildContext context, int index, List<Map<String, dynamic>> listasCompra, StateSetter setState) {
  final lista = listasCompra[index];  // Obtenemos la lista de compras que se desea eliminar

  final idList = int.tryParse(lista["id_list"].toString()) ?? 0;  // Extraemos el ID de la lista de compras. Si no es válido, usamos 0

  // Mostramos un cuadro de diálogo de confirmación
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("¿Eliminar lista?"),  // Título del cuadro de diálogo
        content: const Text("¿Estás seguro de que quieres eliminar esta lista?"),  // Mensaje de confirmación
        actions: [
          // Botón de cancelar que cierra el diálogo sin hacer nada
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),  // Cierra el diálogo sin realizar ninguna acción
          ),
          // Botón de eliminar, que realiza la eliminación de la lista
          TextButton(
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),  // El texto en rojo indica la acción destructiva
            onPressed: () {
              // Llamamos a la función para eliminar la lista desde la base de datos
              eliminarListaCompra(idList, context);

              // Elimina la lista de la lista local (estado de la aplicación)
              setState(() {
                listasCompra.removeAt(index);  // Elimina la lista seleccionada de la lista local
              });

              Navigator.pop(context);  // Cierra el diálogo
            },
          ),
        ],
      );
    },
  );
}
