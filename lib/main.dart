import 'package:flutter/material.dart';
import 'metodos_lc/get_lc.dart';
import 'metodos_lc/aniadir_lc.dart';
import 'metodos_lc/opciones_lc.dart';

void main() {
  runApp(MandangonApp());
}

class MandangonApp extends StatelessWidget {
  const MandangonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Eliminar banner.
      home: PantallaPrincipal(), // Establece PantallaPrincipal.
    );
  }
}

class PantallaPrincipal extends StatefulWidget { 
  const PantallaPrincipal({super.key});

  @override
  PPEstado createState() => PPEstado();
}

class PPEstado extends State<PantallaPrincipal> {
  List<Map<String, dynamic>> listasCompra = []; // Lista que almacenará las listas de compras.

  @override
  void initState() {
    super.initState();
    // Llama al método para obtener las listas de compra. 
    // Pasa el contexto, la lista de compras y el método setState.
    obtenerListasCompra(context, listasCompra, setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Hace el fondo del AppBar transparente.
        elevation: 0, // Elimina la sombra del AppBar.
        toolbarHeight: 70, // Ajusta la altura del AppBar.
        actions: [
          // Iconos de acción en el AppBar.
          IconButton(
            icon: const Icon(Icons.person), // Icono de perfil de usuario.
            onPressed: () {}, // Acción al presionar el icono de perfil (vacío por ahora).
          ),
          IconButton(
            icon: const Icon(Icons.settings), // Icono de configuración.
            onPressed: () {}, // Acción al presionar el icono de configuración (vacío por ahora).
          ),
        ],
      ),
      body: Column(
        children: [
          Center(child: Image.asset("assets/logo.png", height: 80)), // Muestra un logo en el centro.
          const SizedBox(height: 20), // Espacio entre el logo y el resto de los widgets.
          Expanded(
            child: listasCompra.isEmpty
                ? const Center(child: Text("No hay listas de compra")) // Mensaje cuando no hay listas de compra.
                : ListView.builder(
                    itemCount: listasCompra.length, // Cuenta las listas de compra.
                    itemBuilder: (context, index) {
                      final lista = listasCompra[index]; // Obtiene cada lista de compra.
                      // Función para convertir un color hexadecimal a un color de Flutter.
                      Color parseColor(String colorHex) {
                        return Color(int.parse(colorHex.replaceAll("#", "0xFF")));
                      }

                      final colorLista = parseColor(lista["list_color"] ?? "#FFFFFF"); // Color de fondo para cada lista.

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15), // Espaciado alrededor de cada elemento de la lista.
                        child: Align(
                          alignment: Alignment.center, // Alinea el contenedor al centro.
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Padding dentro del contenedor.
                            decoration: BoxDecoration(
                              color: colorLista, // Color de fondo de la lista.
                              borderRadius: BorderRadius.circular(12), // Bordes redondeados.
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black, // Sombra negra.
                                  blurRadius: 4, // Difusión de la sombra.
                                  offset: Offset(0, 2), // Desplazamiento de la sombra.
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () => mostrarOpcionesLista(
                                  context, index, listasCompra, setState), // Acción al hacer clic en una lista.
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Espaciado interno.
                                child: Text(
                                  lista["nombre"], // Muestra el nombre de la lista de compra.
                                  style: const TextStyle(
                                    fontFamily: 'DancingScript', // Fuente personalizada.
                                    fontSize: 18, // Tamaño de fuente.
                                    fontWeight: FontWeight.bold, // Peso de la fuente.
                                    color: Colors.brown, // Color del texto.
                                  ),
                                  textAlign: TextAlign.center, // Centra el texto.
                                  softWrap: true, // Permite que el texto se ajuste.
                                  maxLines: 2, // Máximo de dos líneas para el texto.
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (listasCompra.length < 25) // Verifica si hay menos de 25 listas de compra.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10), // Espaciado alrededor del botón.
              child: IconButton(
                icon: const Icon(Icons.add_circle, size: 50, color: Colors.brown), // Icono de añadir nueva lista.
                onPressed: () =>
                    masListaCompra(context, listasCompra, setState), // Acción para añadir una nueva lista.
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icono de inicio.
            label: "Inicio", // Etiqueta de la primera opción.
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book), // Icono de recetas.
            label: "Recetas", // Etiqueta de la segunda opción.
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant), // Icono de restaurantes.
            label: "Restaurantes", // Etiqueta de la tercera opción.
          ),
        ],
        onTap: (index) {}, // Acción cuando se toca un ítem de la barra de navegación (vacío por ahora).
      ),
    );
  }
}
