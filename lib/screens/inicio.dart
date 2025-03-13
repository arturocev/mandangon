import 'package:flutter/material.dart';
import '../metodos_lc/color_lc.dart';
import '../metodos_lc/ordenar_lc.dart';
import '../metodos_lc/get_lc.dart';
import '../metodos_lc/aniadir_lc.dart';
import '../metodos_lc/opciones_lc.dart';

class PantallaPrincipal extends StatefulWidget {
  final int usuarioId;

  const PantallaPrincipal({super.key, required this.usuarioId});

  @override
  PPEstado createState() => PPEstado();
}

class PPEstado extends State<PantallaPrincipal> {
  List<Map<String, dynamic>> listasCompra = [];

  @override
  void initState() {
    super.initState();
    obtenerListasCompra(context, listasCompra, setState, widget.usuarioId);
  }

  @override
  Widget build(BuildContext context) {
    // Ordenar las listas de compra antes de mostrarlas
    ordenarListasCompra(listasCompra);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset("assets/logo.png", height: 50),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/fondo15.png",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: listasCompra.isEmpty
                    ? const Center(child: Text("No hay listas de compra"))
                    : ListView.builder(
                        itemCount: listasCompra.length,
                        itemBuilder: (context, index) {
                          final lista = listasCompra[index];

                          final colorLista = convertirColor(lista["color"] ?? "#FFCCCBB");

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: colorLista,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () => mostrarOpcionesLista(
                                      context, index, listasCompra, setState, widget.usuarioId),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      lista["nombre"],
                                      style: const TextStyle(
                                        fontFamily: 'DancingScript',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (listasCompra.length < 25)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: IconButton(
                    icon: const Icon(Icons.add_circle, size: 50, color: Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () => nuevaLC(context, listasCompra, setState, widget.usuarioId),
                  ),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Recetas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Restaurantes",
          ),
        ],
        onTap: (index) {},
      ),
    );
  }
}
