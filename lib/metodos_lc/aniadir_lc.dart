import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';  // Paquete para elegir colores
import 'package:http/http.dart' as http;  // Paquete para hacer solicitudes HTTP
import 'dart:convert';  // Paquete para convertir datos a formato JSON

// Función que se ejecuta al crear una nueva lista de compras
void masListaCompra(BuildContext context, List<Map<String, dynamic>> listasCompra, StateSetter setState) async {
  // Crear una nueva lista con un ID único generado con el tiempo actual
  final nuevaLista = {
    "id_list": DateTime.now().millisecondsSinceEpoch, // Usamos el tiempo actual como ID único
    "nombre": "Nueva Lista", // Nombre predeterminado para la nueva lista
    "productos": [], // Lista vacía de productos al principio
    "color": "#FFFFFF", // Color predeterminado para la lista (blanco)
  };

  // Agregar la nueva lista a la lista de compras
  setState(() {
    listasCompra.add(nuevaLista);
  });

  // Establecer el color predeterminado de la lista
  Color selectedColor = Color(0xFFFFFFFF); // Color predeterminado es blanco

  // Función para cambiar el color seleccionado
  void changeColor(Color color) {
    setState(() {
      selectedColor = color;  // Actualizar el color seleccionado
      // Convertir el color a formato hexadecimal y actualizar la propiedad "color" de la nueva lista
      // ignore: deprecated_member_use
      nuevaLista["color"] = "#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}"; // Formato hexadecimal
    });
  }

  // Mostrar el selector de color en un diálogo
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Seleccionar color'),  // Título del diálogo
        content: SingleChildScrollView(
          child: ColorPicker(  // Usar el paquete de color para elegir un color
            pickerColor: selectedColor,  // Color actual seleccionado
            onColorChanged: changeColor,  // Función llamada cuando el color cambia
            // ignore: deprecated_member_use
            showLabel: true,  // Mostrar etiquetas de color (opcional)
            pickerAreaHeightPercent: 0.8,  // Ajusta la altura del área del selector
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Seleccionar'),  // Botón para confirmar la selección del color
            onPressed: () {
              Navigator.of(context).pop();  // Cerrar el diálogo
            },
          ),
        ],
      );
    },
  );

  // Intentar enviar la nueva lista de compras al servidor
  try {
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/guardar_lista.php'),  // URL donde se enviará la solicitud
      headers: {'Content-Type': 'application/json'},  // Especificar que estamos enviando datos en formato JSON
      body: jsonEncode({
        'id_list': 0,  // Enviar el ID como 0, ya que el servidor asignará uno nuevo
        'nombre': nuevaLista["nombre"],  // Enviar el nombre de la lista
        'productos': nuevaLista["productos"],  // Enviar los productos de la lista
        'color': nuevaLista["color"],  // Enviar el color de la lista
      }),
    );

    // Verificar si la respuesta del servidor fue exitosa
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);  // Decodificar la respuesta en formato JSON

      if (responseData["status"] == "success") {  // Si el servidor respondió con éxito
        // Actualizar el ID de la lista con el que asignó el servidor
        setState(() {
          nuevaLista["id_list"] = responseData["id_list"];
        });

        // Mostrar un mensaje de éxito en la interfaz
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lista creada correctamente")),
        );
      } else {
        // Si el servidor no respondió con éxito, mostrar un mensaje de error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al crear la lista. Intente de nuevo.")),
        );
      }
    } else {
      // Si la respuesta del servidor no es 200, mostrar un mensaje de error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al crear la lista. Intente de nuevo.")),
      );
    }
  } catch (e) {
    // Si ocurre un error de conexión, mostrar un mensaje de error
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No se pudo conectar con el servidor.")),
    );
  }
}
