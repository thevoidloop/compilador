import 'package:compilador/models/lexema_model.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  String codigoFuente = '';
  late List<String> lineas;
  List<Lexema> lexemas = [];
  bool modePanic = false;
  /*
  RegExp ps = RegExp(r'@if|@else|@for|@while|@int|@string|@cout');
  RegExp identificadores = RegExp(r'^[a-z][a-z0-9]*$');
  RegExp opArit = RegExp(r'\+|-|\*|/');
  RegExp opComp = RegExp(r'==|!=|>|<');
  RegExp opAsig = RegExp(r'>>');
  RegExp simbolos = RegExp(r'\||;|:|\.|,');
  RegExp conEntera = RegExp(r'^-?\d+$');
  RegExp conCadena = RegExp(r"^'.*'$");
*/
  List<RegExp> categoriasLexicas = [
    RegExp(r'@if|@else|@for|@while|@int|@string|@cout'),
    RegExp(r'^[a-z][a-z0-9]*$'),
    RegExp(r'\+|-|\*|/'),
    RegExp(r'==|!=|>|<'),
    RegExp(r'>>'),
    RegExp(r'\||;|:|\.|,|\)|\(|\{|\}'),
    RegExp(r'^-?\d+$'),
    RegExp(r"^'.*'$"),
  ];

  void compilar() {
    splitear();

    for (int numLinea = 0; numLinea < lineas.length; numLinea++) {
      if (!modePanic) {
        matchLineas(lineas[numLinea], numLinea);
      } else {
        notifyListeners();
        break;
      }
    }
    notifyListeners();
  }

  void splitear() {
    lineas = codigoFuente.split('\n');
  }

  void matchLineas(String examinar, int numLinea) {
    List<String> palabras = examinar.split(' ');

    for (int numPalabras = 0; numPalabras < palabras.length; numPalabras++) {
      bool coincide = false;
      if (palabras[numPalabras] == ' ') break;
      if (palabras[numPalabras] == '') break;

      for (int numExpresion = 0;
          numExpresion < categoriasLexicas.length;
          numExpresion++) {
        if (categoriasLexicas[numExpresion].hasMatch(palabras[numPalabras])) {
          coincide = true;
          lexemas.add(
            Lexema(
              palabras[numPalabras],
              ultimoToken(numExpresion) + 1,
              '${(numExpresion + 1) * 100}',
              numLinea,
              searchCategoria(numExpresion),
            ),
          );
        }
        if (coincide) break;
      }

      if (!coincide) {
        modePanic = true;
      }
    }
  }

  int ultimoToken(int categoria) {
    String cadenaComparar = '${(categoria + 1) * 100}';

    if (lexemas.isEmpty) return 0;
    Lexema ultimo = lexemas.lastWhere(
        (
          lexema,
        ) =>
            lexema.clase == cadenaComparar,
        orElse: () => Lexema('', 0, '', 0, ''));
    return ultimo.token;
  }

  String searchCategoria(int clase) {
    switch (clase) {
      case 0:
        return 'Palabras de Sistemas';
      case 1:
        return 'Identificadores';
      case 2:
        return 'Operadores Aritméticos';
      case 3:
        return 'Operadores de Comparacion';
      case 4:
        return 'Operadores de Asignacion';
      case 5:
        return 'Símbolos';
      case 6:
        return 'Literales';
      case 7:
        return 'Literales';
      default:
        return '';
    }
  }
}
