import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mandangon/metodos_lc/confirmar_eliminar_lc.dart';
import 'package:mandangon/metodos_lc/color_lc.dart';
import '../screens/lista_compra.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart'; // Para compartir en Web

// Muestra un cuadro de diálogo con opciones para editar, ver, cambiar color o eliminar una lista de compra.
void mostrarOpcionesLista(
    BuildContext context,
    int index,
    List<Map<String, dynamic>> listasCompra,
    StateSetter setState,
    int usuarioId // Se agrega el parámetro requerido
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
            // Opción para compartir la lista.
            ListTile(
              title: const Text("Compartir"),
              onTap: () {
                compartirLista(lista);
                Navigator.pop(context);
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

void compartirLista(Map<String, dynamic> lista) async {
  try {
    String titulo = "*${lista["nombre"]}*"; // Negrita para WhatsApp/Email
    List<dynamic> productos = lista["productos"] ?? [];

    // ignore: unnecessary_type_check
    if (productos is! List) {
      productos = [];
    }

    // ignore: prefer_interpolation_to_compose_strings
    String contenido = "$titulo\n\n" + productos.map((p) => "• $p").join("\n");
    final Uri emailUrl =
        Uri.parse("mailto:?subject=Lista de Compra&body=$contenido");

    if (kIsWeb) {
      // 🔹 Compartir en Web (abre WhatsApp Web)
      final Uri shareUrl = Uri.parse(
          "https://web.whatsapp.com/send?text=${Uri.encodeComponent(contenido)}");
      if (!await launchUrl(shareUrl)) {
        if (kDebugMode) {
          print("Error al abrir WhatsApp Web");
        }
      }
    } else if (Platform.isAndroid || Platform.isIOS) {
      // 🔹 Compartir en Android/iOS (Share Plus)
      Share.share(contenido);
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // 🔹 Compartir en Escritorio (Email)
      if (!await launchUrl(emailUrl)) {
        if (kDebugMode) {
          print("No se pudo abrir el correo.");
        }
      }
    } else {
      if (kDebugMode) {
        print("Plataforma no soportada.");
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error al compartir la lista: $e");
    }
  }
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
