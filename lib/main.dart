import 'package:flutter/material.dart';
import 'screens/lista_compra_screen.dart';

void main() {
  runApp(MandangonApp());
}

class MandangonApp extends StatelessWidget {
  const MandangonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  PPEstado createState() => PPEstado();
}

class PPEstado extends State<PantallaPrincipal> {
  List<Map<String, dynamic>> listasCompra = [];

  // Función para agregar una nueva lista
  void masListaCompra() {
    if (listasCompra.length < 5) {
      setState(() {
        listasCompra.add({"nombre": "Nueva Lista", "productos": []});
      });
    }
  }

  // Mostrar opciones al pulsar sobre una lista
  void mostrarOpcionesLista(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Opciones de Lista"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Editar"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LCScreen(
                        editable: true,
                        lista: listasCompra[index],
                        onConfirm: (nombre, productos) {
                          setState(() {
                            listasCompra[index]["nombre"] = nombre;
                            listasCompra[index]["productos"] = productos;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Ver"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LCScreen(
                        editable: false,
                        lista: listasCompra[index],
                        onConfirm: (nombre, productos) {
                          // Esta acción no se hace al ver la lista
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Eliminar"),
                onTap: () {
                  Navigator.pop(context);
                  confirmarEliminacion(context, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Confirmación para eliminar una lista
  void confirmarEliminacion(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¿Eliminar lista?"),
          content: Text("¿Estás seguro de que quieres eliminar esta lista?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  listasCompra.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: IconButton(
              icon: Image.asset("assets/perfil.png"),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: IconButton(
              icon: Image.asset("assets/ajustes.png"),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/logo.png", height: 80)),
          SizedBox(height: 20),
          ...listasCompra.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 208, 208, 1), // Rojo pastel sin opacidad
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Cambiado de "primary" a "backgroundColor"
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () => mostrarOpcionesLista(context, entry.key),
                    child: Text(
                      entry.value["nombre"],
                      style: TextStyle(
                        fontFamily: 'DancingScript', // Fuente caligráfica
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ),
              )),
          if (listasCompra.length < 5)
            IconButton(
              icon: Icon(Icons.add_circle, size: 50, color: Colors.brown),
              onPressed: masListaCompra,
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
