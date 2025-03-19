import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class CompartirRestaurante {
  static Future<void> compartirRestaurante(
    String opcion,
    String url,
    String nombre,
    String direccion,
    BuildContext context,
  ) async {
    final direccionCodificada = Uri.encodeComponent(direccion);
    final mensaje = '$nombre - $url\n\nUbicación: https://www.google.com/maps?q=$direccionCodificada';
    final pieMensaje = '\n\nEnviado desde la app Mandangon';
    final mensajeCompleto = '$mensaje$pieMensaje';

    if (opcion == 'whatsapp') {
      final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent('¡Hola!\n\nTe comparto el restaurante:\n\n$mensajeCompleto')}';
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se puede abrir WhatsApp.")),
        );
      }
    } else if (opcion == 'email') {
      final cuerpoCorreo = '¡Hola!\n\nTe comparto el restaurante:\n\n$mensaje$pieMensaje';
      final emailUrl = 'mailto:?subject=Restaurante $nombre&body=${Uri.encodeComponent(cuerpoCorreo)}';
      if (await canLaunch(emailUrl)) {
        await launch(emailUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se puede abrir el correo.")),
        );
      }
    } else if (opcion == 'copy') {
      await Clipboard.setData(ClipboardData(text: '¡Hola!\n\nTe comparto el restaurante:\n\n$mensajeCompleto'));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mensaje copiado al portapapeles")),
      );
    }
  }
}
