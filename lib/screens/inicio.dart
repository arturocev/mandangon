import 'package:flutter/material.dart';
import '../metodos_lc/color_lc.dart';
import '../metodos_lc/ordenar_lc.dart';
import '../metodos_lc/get_lc.dart';
import '../metodos_lc/aniadir_lc.dart';
import '../metodos_lc/opciones_lc.dart';
import '../screens/restaurantes.dart';  


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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFECC099),
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 1),
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(left: 16, top: 15),
              child: Image.asset("assets/logo.png", height: 50),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 15),
                child: IconButton(
                  icon: const Icon(Icons.person, color: Colors.black),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 15),
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.black),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/fondo1.png",
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
                            padding: EdgeInsets.only(
                              top: index == 0 ? 20 : 10, // Solo la primera tarjeta baja más
                              left: 15,
                              right: 15,
                              bottom: 10,
                            ),
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
                  padding: const EdgeInsets.only(bottom: 110),
                  child: IconButton(
                    icon: const Icon(Icons.add_circle, size: 50, color: Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () => nuevaLC(context, listasCompra, setState, widget.usuarioId),
                  ),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFECC099),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
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
          onTap: (index) {
            if (index == 2) {
              // Redirige a Restaurantes.dart cuando se presiona el icono de restaurantes
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Restaurantes(usuarioId: widget.usuarioId)),
              );
            }
          },
        ),
      ),
    );
  }
}
