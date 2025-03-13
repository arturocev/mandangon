void ordenarListasCompra(List<Map<String, dynamic>> listasCompra) {
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
