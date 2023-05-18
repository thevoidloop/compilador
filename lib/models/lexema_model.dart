class Lexema {
  final String lexema;
  final int token;
  final String clase;
  final String categoria;
  List<int> linea = [];
  String tipo = '';

  Lexema(
    this.lexema,
    this.token,
    this.clase,
    this.categoria,
  );

  void setTipo(String value) => tipo = value;
  void addLine(int numLinea) => linea.add(numLinea);

  String lineasToString() {
    String msg = '';

    for (int linea in linea) {
      msg = '$msg$linea, ';
    }

    return msg;
  }
}
