import 'package:intl/intl.dart';

String formatearFecha(String fechaOriginal) {
  try {
    DateTime fecha = DateTime.parse(fechaOriginal);
    return DateFormat('dd/MM/yyyy').format(fecha);
  } catch (e) {
    return fechaOriginal;
  }
}
