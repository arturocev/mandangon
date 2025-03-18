import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // Para copiar al portapapeles

void mostrarOpcionesCompartir(
    BuildContext context, Map<String, dynamic> lista) {
  String titulo = "*${lista["nombre"]}*";
  List<dynamic> productos = lista["productos"] ?? [];
  String contenido = "$titulo\n\n${productos.map((p) => "• $p").join("\n")}";

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Image.asset('assets/icon_whatsapp.png', width: 24, height: 24),
              title: const Text('Compartir por WhatsApp'),
              onTap: () async {
                final Uri whatsappUrl = Uri.parse(
                    "https://wa.me/?text=${Uri.encodeComponent(contenido)}");
                if (await canLaunchUrl(whatsappUrl)) {
                  await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No se pudo abrir WhatsApp')),
                  );
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context); // Cierra el diálogo
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Compartir por Correo'),
              onTap: () async {
                final Uri emailUrl = Uri.parse(
                    "mailto:?subject=Lista de Compra&body=$contenido");
                if (await canLaunchUrl(emailUrl)) {
                  await launchUrl(emailUrl);
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copiar al Portapapeles'),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: contenido));
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Texto copiado al portapapeles")),
                );
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
