import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Color convertirColor(String colorHex) {
  return Color(int.parse(colorHex.replaceAll("#", "0xFF")));
}

Future<void> actualizarColorLista(BuildContext context, int idLista, String nuevoColor) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/actualizar_color_lista.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_list': idLista,
        'list_color': nuevoColor,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData["status"] == "success") {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Color actualizado correctamente")),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al actualizar el color")),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al conectar con el servidor")),
      );
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error al conectar con el servidor")),
    );
  }
}


void eligeColor(BuildContext context, int index, List<Map<String, dynamic>> listasCompra, StateSetter setState) {
  Color currentColor = convertirColor(listasCompra[index]["list_color"] ?? "#FFCCCBB");

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
              // ignore: deprecated_member_use
              final nuevoColor = "#${currentColor.value.toRadixString(16).substring(2, 8)}";

              setState(() {
                listasCompra[index]["color"] = nuevoColor;
              });

              await actualizarColorLista(context, listasCompra[index]["id_list"], nuevoColor);

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
  