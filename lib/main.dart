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
  List<Map<String, dynamic>> listasCompra =
      []; // Lista que almacenará las listas de compras.

  @override
  void initState() {
    super.initState();
    // Llama al método para obtener las listas de compra.
    // Pasa el contexto, la lista de compras y el método setState.
    obtenerListasCompra(context, listasCompra, setState);
  }

  // Función para convertir un color hexadecimal a un color de Flutter
  Color parseColor(String colorHex) {
    return Color(int.parse(colorHex.replaceAll("#", "0xFF")));
  }

  // Función para ordenar las listas de compra sin distinguir mayúsculas/minúsculas
  // y con números antes que letras
  void ordenarListasCompra() {
    listasCompra.sort((a, b) {
      String nombreA = a["nombre"].toLowerCase(); // Convertir a minúsculas
      String nombreB = b["nombre"].toLowerCase(); // Convertir a minúsculas

      // Verificar si el nombre comienza con un número
      bool aEsNumero = nombreA.isNotEmpty && nombreA[0].contains(RegExp(r'[0-9]'));
      bool bEsNumero = nombreB.isNotEmpty && nombreB[0].contains(RegExp(r'[0-9]'));

      // Si ambos comienzan con números o ambos no, comparar alfabéticamente
      if ((aEsNumero && bEsNumero) || (!aEsNumero && !bEsNumero)) {
        return nombreA.compareTo(nombreB);
      }
      // Si A comienza con número y B no, A va primero
      else if (aEsNumero) {
        return -1;
      }
      // Si B comienza con número y A no, B va primero
      else {
        return 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ordenar las listas de compra antes de mostrarlas
    ordenarListasCompra();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(left: 16), // Margen izquierdo para separar del borde
          child: Image.asset("assets/logo.png", height: 50),
        ),
        actions: [
          // Iconos de acción en el AppBar con margen
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Espaciado de los iconos.
            child: IconButton(
              icon: const Icon(Icons.person), // Icono de perfil de usuario.
              onPressed:
                  () {}, // Acción al presionar el icono de perfil (vacío por ahora).
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Espaciado de los iconos.
            child: IconButton(
              icon: const Icon(Icons.settings), // Icono de configuración.
              onPressed:
                  () {}, // Acción al presionar el icono de configuración (vacío por ahora).
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo de la pantalla (fondo2.png) colocado de fondo
          Positioned.fill(
            child: Image.asset(
              "assets/fondo2.png", // Fondo de la pantalla
              fit: BoxFit.cover, // Ajuste para cubrir toda la pantalla
            ),
          ),
          Column(
            children: [
              const SizedBox(
                  height: 20), // Espacio entre la parte superior y el contenido.
              Expanded(
                child: listasCompra.isEmpty
                    ? const Center(
                        child: Text(
                            "No hay listas de compra")) // Mensaje cuando no hay listas de compra.
                    : ListView.builder(
                        itemCount:
                            listasCompra.length, // Cuenta las listas de compra.
                        itemBuilder: (context, index) {
                          final lista =
                              listasCompra[index]; // Obtiene cada lista de compra.

                          final colorLista = parseColor(lista["list_color"] ??
                              "#FFCCCBB"); // Color de fondo para cada lista.

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal:
                                    15), // Espaciado alrededor de cada elemento de la lista.
                            child: Align(
                              alignment: Alignment
                                  .center, // Alinea el contenedor al centro.
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8), // Padding dentro del contenedor.
                                decoration: BoxDecoration(
                                  color: colorLista, // Color de fondo de la lista.
                                  borderRadius: BorderRadius.circular(
                                      12), // Bordes redondeados.
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black, // Sombra negra.
                                      blurRadius: 4, // Difusión de la sombra.
                                      offset: Offset(
                                          0, 2), // Desplazamiento de la sombra.
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () => mostrarOpcionesLista(
                                      context,
                                      index,
                                      listasCompra,
                                      setState), // Acción al hacer clic en una lista.
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0), // Espaciado interno.
                                    child: Text(
                                      lista[
                                          "nombre"], // Muestra el nombre de la lista de compra.
                                      style: const TextStyle(
                                        fontFamily:
                                            'DancingScript', // Fuente personalizada.
                                        fontSize: 18, // Tamaño de fuente.
                                        fontWeight:
                                            FontWeight.bold, // Peso de la fuente.
                                        color: Color.fromARGB(
                                            255, 0, 0, 0), // Color del texto.
                                      ),
                                      textAlign:
                                          TextAlign.center, // Centra el texto.
                                      softWrap:
                                          true, // Permite que el texto se ajuste.
                                      maxLines:
                                          2, // Máximo de dos líneas para el texto.
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (listasCompra.length <
                  25) // Verifica si hay menos de 25 listas de compra.
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10), // Espaciado alrededor del botón.
                  child: IconButton(
                    icon: const Icon(Icons.add_circle,
                        size: 50,
                        color: Color.fromARGB(
                            255, 0, 0, 0)), // Icono de añadir nueva lista.
                    onPressed: () => nuevaLC(context, listasCompra,
                        setState), // Acción para añadir una nueva lista.
                  ),
                ),
            ],
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
        onTap:
            (index) {}, // Acción cuando se toca un ítem de la barra de navegación (vacío por ahora).
      ),
    );
  }
}