import 'dart:math';


List<dynamic> obtenerAleatorios(List<dynamic> lista, int cantidad) {
  lista.shuffle(Random());
  return lista.take(cantidad).toList();
}
