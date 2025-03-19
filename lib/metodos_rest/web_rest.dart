import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebRestaurante {
  static Future<void> visitarWeb(String url, BuildContext context) async {
    if (url.isNotEmpty && await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se puede abrir la página web.")),
      );
    }
  }
}
