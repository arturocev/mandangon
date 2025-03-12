import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mandangon/metodos_lc/confirmar_eliminar_lc.dart';
import 'package:mandangon/metodos_lc/color_lc.dart';
import '../screens/lista_compra.dart';

// Muestra un cuadro de diálogo con opciones para editar, ver, cambiar color o eliminar una lista de compra.
void mostrarOpcionesLista(
    BuildContext context,
    int index,
    List<Map<String, dynamic>> listasCompra,
    StateSetter setState,
    int usuarioId  // Se agrega el parámetro requerido
    ) {
  final lista = listasCompra[index]; // Obtener la lista seleccionada.

  if (kDebugMode) {
    print("ID de la lista seleccionada: ${lista["id_list"]}");
    print("Nombre de la lista seleccionada: ${lista["nombre"]}");
    print("Productos de la lista seleccionada: ${lista["productos"]}");
  }

  // Mostrar un cuadro de diálogo con las opciones disponibles.
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Opciones de Lista"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Opción de editar la lista.
            ListTile(
              title: const Text("Editar"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LCScreen(
                      editable: true,
                      lista: {
                        "id_list": lista["id_list"],
                        "nombre": lista["nombre"],
                        "productos": lista["productos"],
                      },
                      onConfirm: (nombre, productos) {
                        setState(() {
                          listasCompra[index]["nombre"] = nombre;
                          listasCompra[index]["productos"] = productos;
                        });
                      },
                      usuarioId: usuarioId, // Se pasa el usuarioId
                    ),
                  ),
                );
              },
            ),
            // Opción para ver la lista sin editar.
            ListTile(
              title: const Text("Ver"),
              onTap: () {
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
                      usuarioId: usuarioId, // Se pasa el usuarioId
                    ),
                  ),
                );
              },
            ),
            // Opción para cambiar el color de la lista.
            ListTile(
              title: const Text("Cambiar Color"),
              onTap: () {
                Navigator.pop(context);
                eligeColor(context, index, listasCompra, setState);
              },
            ),
            // Opción para eliminar la lista.
            ListTile(
              title: const Text("Eliminar"),
              onTap: () {
                Navigator.pop(context);
                confirmarEliminacion(context, index, listasCompra, setState);
              },
            ),
          ],
        ),
      );
    },
  );
}

// Función para convertir un color hexadecimal a un Color de Flutter.
Color converHexa(String colorHex) {
  if (colorHex.isEmpty || colorHex[0] != '#') {
    return const Color(0xFFFFFFFF); // Blanco por defecto.
  }
  return Color(int.parse(colorHex.replaceAll("#", "0xFF")));
}

// Muestra un cuadro de diálogo para cambiar el color de la lista.
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
            pickerColor: currentColor,
            onColorChanged: (Color color) {
              currentColor = color;
            },
            // ignore: deprecated_member_use
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text("Guardar"),
            onPressed: () async {
              final nuevoColor =
                  // ignore: deprecated_member_use
                  "#${currentColor.value.toRadixString(16).substring(2, 8)}";

              setState(() {
                listasCompra[index]["color"] = nuevoColor;
              });

              await actualizarColorLista(
                  context, listasCompra[index]["id_list"], nuevoColor);

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
