import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mandangon/metodos_lc/color_lc.dart';
import 'package:mandangon/metodos_lc/confirmar_eliminar_lc.dart';
import '../screens/lista_compra.dart';

// Muestra un cuadro de diálogo con opciones para editar, ver, cambiar color o eliminar una lista de compra.
void mostrarOpcionesLista(BuildContext context, int index, List<Map<String, dynamic>> listasCompra, StateSetter setState) {

  final lista = listasCompra[index];  // Obtener la lista seleccionada.

  if (kDebugMode) {
    print("ID de la lista seleccionada: ${lista["id_list"]}");
    print("Nombre de la lista seleccionada: ${lista["nombre"]}");
    print("Productos de la lista seleccionada: ${lista["productos"]}");
  }

  // Mostrar un cuadro de diálogo con las opciones disponibles para la lista seleccionada.
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Opciones de Lista"),
        content: Column(
          mainAxisSize: MainAxisSize.min,  // Ajustar el tamaño del contenido al mínimo necesario
          children: [
            // Opción de editar la lista
            ListTile(
              title: const Text("Editar"),
              onTap: () {
                // Navegar a la pantalla de edición
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LCScreen(
                      editable: true,
                      lista: {
                        "id_list": lista["id_list"],  // Pasar la lista con todos sus datos
                        "nombre": lista["nombre"],
                        "productos": lista["productos"],
                      },
                      onConfirm: (nombre, productos) {
                        // Al confirmar los cambios, actualizamos el estado local
                        setState(() {
                          listasCompra[index]["nombre"] = nombre;
                          listasCompra[index]["productos"] = productos;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            // Opción para ver los detalles de la lista (sin editar)
            ListTile(
              title: const Text("Ver"),
              onTap: () {
                // Navegar a la pantalla de solo vista
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LCScreen(
                      editable: false,
                      lista: {
                        "id_list": lista["id_list"], 
                        "nombre": lista["nombre"],
                        "productos": lista["productos"],
                      },
                      onConfirm: (nombre, productos) {},
                    ),
                  ),
                );
              },
            ),
            // Opción para cambiar el color de la lista
            ListTile(
              title: const Text("Cambiar Color"),
              onTap: () {
                Navigator.pop(context); // Cerrar el cuadro de diálogo actual
                _mostrarSelectorColor(context, index, listasCompra, setState); // Mostrar selector de color
              },
            ),
            // Opción para eliminar la lista
            ListTile(
              title: const Text("Eliminar"),
              onTap: () {
                Navigator.pop(context); // Cerrar el cuadro de diálogo actual
                confirmarEliminacion(context, index, listasCompra, setState); // Confirmar eliminación
              },
            ),
          ],
        ),
      );
    },
  );
}

// Muestra un cuadro de diálogo para seleccionar un color nuevo para la lista de compra.
void _mostrarSelectorColor(BuildContext context, int index, List<Map<String, dynamic>> listasCompra, Function(Function()) setState) {
  // Obtener el color actual de la lista
  Color currentColor = parseColor(listasCompra[index]["list_color"] ?? "#FFFFFF");

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Selecciona un color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,  // Color inicial
            onColorChanged: (Color color) {
              currentColor = color;  // Actualizar el color seleccionado
            },
            // ignore: deprecated_member_use
            showLabel: true,  // Mostrar etiquetas de colores
            pickerAreaHeightPercent: 0.8,  // Altura del área del selector
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.pop(context);  // Cerrar el cuadro de diálogo sin guardar
            },
          ),
          TextButton(
            child: const Text("Guardar"),
            onPressed: () async {
              // Convertir el color seleccionado a formato hexadecimal
              // ignore: deprecated_member_use
              final nuevoColor = "#${currentColor.value.toRadixString(16).substring(2, 8)}";
              // Actualizar el color en la base de datos
              await actualizarColorLista(context, listasCompra[index]["id_list"], nuevoColor);
              // Actualizar el color en el estado local
              setState(() {
                listasCompra[index]["list_color"] = nuevoColor;
              });
              // ignore: use_build_context_synchronously
              Navigator.pop(context);  // Cerrar el cuadro de diálogo
            },
          ),
        ],
      );
    },
  );
}

// Convierte un color hexadecimal (#RRGGBB) en un objeto Color de Flutter.
Color parseColor(String colorHex) {
  // Convertir un color hexadecimal a un objeto Color en Flutter
  return Color(int.parse(colorHex.replaceAll("#", "0xFF")));
}
