class Lexema {
  final String lexema;
  final int token;
  final String clase;
  final String categoria;
  List<int> linea = [];

  Lexema(
    this.lexema,
    this.token,
    this.clase,
    this.categoria,
  );

  void addLine(int numLinea) => linea.add(numLinea);
}
