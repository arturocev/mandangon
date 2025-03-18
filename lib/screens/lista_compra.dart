import 'package:flutter/material.dart';
import '../metodos_lc/agregar_prod.dart';
import '../metodos_lc/eliminar_prod.dart';
import '../metodos_lc/confirmar_lc.dart';

class LCScreen extends StatefulWidget {
  final bool editable;
  final Map<String, dynamic> lista;
  final Function(String, List<String>) onConfirm;
  final int usuarioId;

  const LCScreen({
    super.key,
    required this.editable,
    required this.lista,
    required this.onConfirm,
    required this.usuarioId,
  });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Nombre de la lista
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: "Nombre de la Lista",
                    labelStyle: const TextStyle(color: Colors.black87),
                    filled: true,
                    fillColor: Colors.orange[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Campo y botón para agregar productos
                if (widget.editable)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: productoController,
                          decoration: InputDecoration(
                            labelText: "Producto",
                            labelStyle: const TextStyle(color: Colors.black87),
                            filled: true,
                            fillColor: Colors.orange[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: (_) => agregarProducto(productoController, productos, setState),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => agregarProducto(productoController, productos, setState),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 80, 255, 220),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Icon(Icons.add, color: Colors.black),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),

                // Lista de productos con un diseño más limpio
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListView.separated(
                      itemCount: productos.length,
                      separatorBuilder: (context, index) => Divider(color: const Color.fromARGB(255, 103, 169, 255)),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            productos[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: widget.editable
                              ? IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => eliminarProducto(index, productos, setState),
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botón para guardar la lista
                if (widget.editable)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.lista["nombre"] = nombreController.text;
                        });
                        confirmarLista(context, widget.lista, productos, widget.onConfirm, widget.usuarioId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 36, 230, 43),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text("Guardar Lista", style: TextStyle(color: Colors.black)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
