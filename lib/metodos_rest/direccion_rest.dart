import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class DireccionRestaurante {
  static Future<void> abrirDireccion(String direccion, BuildContext context) async {
    final mapsUrl = 'https://www.google.com/maps/search/?q=$direccion';
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se puede abrir Google Maps.")),
      );
    }
  }
}
