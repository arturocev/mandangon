// opciones.dart
import 'package:flutter/material.dart';
import '../screens/lista_compra.dart';
import 'package:mandangon/metodos_lc/confirmar_eliminar_lc.dart';
import 'package:mandangon/metodos_lc/color_lc.dart';
import 'package:mandangon/metodos_lc/compartir_lc.dart';

void mostrarOpcionesLista(
    BuildContext context,
    int index,
    List<Map<String, dynamic>> listasCompra,
    StateSetter setState,
    int usuarioId) {
  final lista = listasCompra[index];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Opciones de Lista"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                      usuarioId: usuarioId,
                    ),
                  ),
                );
              },
            ),
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
                      usuarioId: usuarioId,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Cambiar Color"),
              onTap: () {
                Navigator.pop(context);
                eligeColor(context, index, listasCompra, setState);
              },
            ),
            ListTile(
              title: const Text("Compartir"),
              onTap: () {
                Navigator.pop(context);
                mostrarOpcionesCompartir(context, lista);
              },
            ),
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