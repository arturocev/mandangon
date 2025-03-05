import 'package:flutter/material.dart';

class LCScreen extends StatefulWidget {
  final bool editable;
  final Map<String, dynamic> lista; // Recibe la lista desde PantallaPrincipal
  final Function(String, List<String>) onConfirm;
  
  const LCScreen({super.key, required this.editable, required this.lista, required this.onConfirm});

  @override
  LCEstado createState() => LCEstado();
}

class LCEstado extends State<LCScreen> {
  TextEditingController nombreController = TextEditingController();
  List<String> productos = [];
  TextEditingController productoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.lista["nombre"];
    productos = List<String>.from(widget.lista["productos"]);
  }

  void agregarProducto() {
    if (productoController.text.isNotEmpty) {
      setState(() {
        productos.add(productoController.text);
        productoController.clear();
      });
    }
  }

  void confirmarLista() {
    widget.onConfirm(nombreController.text, productos);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset("assets/logo.png", height: 80)),
            SizedBox(height: 20),
            Text("NOMBRE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
            TextField(
              controller: nombreController,
              enabled: widget.editable,
            ),
            SizedBox(height: 20),
            Text("PRODUCTOS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
            // Mostrar los productos, siempre que existan, en ambas modalidades
            Expanded(
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(productos[index]),
                  );
                },
              ),
            ),
            // Solo mostrar la barra de texto y el botón si es editable
            if (widget.editable)
              Padding(
                padding: const EdgeInsets.only(top: 8.0), // Añadí un pequeño margen para separar
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: productoController,
                        decoration: InputDecoration(
                          hintText: 'Añadir producto...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.green),
                      onPressed: agregarProducto,
                    ),
                  ],
                ),
              ),
            // Solo mostrar el botón de confirmar si es editable
            if (widget.editable)
              Padding(
                padding: const EdgeInsets.only(top: 8.0), // Separar el botón de la barra de texto
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: confirmarLista,
                    child: Text("CONFIRMAR", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
