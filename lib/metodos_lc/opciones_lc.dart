import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mandangon/metodos_lc/confirmar_eliminar_lc.dart';
import 'package:mandangon/metodos_lc/color_lc.dart';
import '../screens/lista_compra.dart';

// Muestra un cuadro de diálogo con opciones para editar, ver, cambiar color o eliminar una lista de compra.
void mostrarOpcionesLista(BuildContext context, int index,
    List<Map<String, dynamic>> listasCompra, StateSetter setState) {
  final lista = listasCompra[index]; // Obtener la lista seleccionada.

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
          mainAxisSize: MainAxisSize
              .min, // Ajustar el tamaño del contenido al mínimo necesario
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
                        "id_list": lista[
                            "id_list"], // Pasar la lista con todos sus datos
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
                eligeColor(context, index, listasCompra,
                    setState); // Mostrar selector de color
              },
            ),
            // Opción para eliminar la lista
            ListTile(
              title: const Text("Eliminar"),
              onTap: () {
                Navigator.pop(context); // Cerrar el cuadro de diálogo actual
                confirmarEliminacion(context, index, listasCompra,
                    setState); // Confirmar eliminación
              },
            ),
          ],
        ),
      );
    },
  );
}

// Función para convertir un color hexadecimal a un Color de Flutter
Color converHexa(String colorHex) {
  if (colorHex.isEmpty || colorHex[0] != '#') {
    return Color(
        0xFFFFFFFF); // Retorna blanco por defecto si el formato es incorrecto
  }
  return Color(int.parse(colorHex.replaceAll("#", "0xFF")));
}

// Muestra un cuadro de diálogo con opciones para cambiar el color de una lista
void eligeColor(BuildContext context, int index,
    List<Map<String, dynamic>> listasCompra, Function(Function()) setState) {
  Color currentColor =
      converHexa(listasCompra[index]["list_color"] ?? "#FFCCCBB");

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Selecciona un color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor, // Color actual
            onColorChanged: (Color color) {
              currentColor = color; // Actualizar el color seleccionado
            },
            // ignore: deprecated_member_use
            showLabel: true, // Mostrar etiquetas de colores
            pickerAreaHeightPercent: 0.8, // Altura del área del selector
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.pop(context); // Cerrar el cuadro de diálogo sin guardar
            },
          ),
          TextButton(
            child: const Text("Guardar"),
            onPressed: () async {
              final nuevoColor =
                  // ignore: deprecated_member_use
                  "#${currentColor.value.toRadixString(16).substring(2, 8)}";

              // Actualizar el color en el estado de la lista localmente
              setState(() {
                listasCompra[index]["list_color"] = nuevoColor; // Actualizamos el color en la lista
              });

              // Actualizar el color en la base de datos
              await actualizarColorLista(context, listasCompra[index]["id_list"], nuevoColor);

              // ignore: use_build_context_synchronously
              Navigator.pop(context); // Cerrar el cuadro de diálogo
            },
          ),
        ],
      );
    },
  );
}
