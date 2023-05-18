import 'package:compilador/models/lexema_model.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  String codigoFuente = '';
  String errorMessage = '';
  late List<String> lineas;
  List<Lexema> lexemas = [];
  List<Lexema> identifier = [];
  bool modePanic = true;

  List<RegExp> categoriasLexicas = [
    RegExp(r'@if|@else|@for|@while|@int|@string|@cout'),
    RegExp(r'^[a-z][a-z0-9]*$'),
    RegExp(r'(\+|-|\*|/)'),
    RegExp(r'^(==|!=|>|<)$'),
    RegExp(r'>>'),
    RegExp(r'(\||;|:|\.|,|\)|\(|\{|\})'),
    RegExp(r'^-?\d+$'),
    RegExp(r"^'.*'$"),
  ];

  void reset() {
    lexemas = [];
    modePanic = false;
    identifier = [];
  }

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

      if (palabras[numPalabras].isEmpty) continue; // Elimina vacios
      if (palabras[numPalabras].trim().length == 0)
        continue; // Elimina espacios en blanco
      if (palabras[numPalabras] == '\n') continue; // Elimina saltos

      for (int numExpresion = 0;
          numExpresion < categoriasLexicas.length;
          numExpresion++) {
        if (categoriasLexicas[numExpresion].hasMatch(palabras[numPalabras])) {
          coincide = true;
          Lexema lexema = Lexema(
            palabras[numPalabras],
            ultimoToken(numExpresion) + 1,
            '${(numExpresion + 1) * 100}',
            searchCategoria(numExpresion),
          );
          if (numExpresion == 1) addIdentifier(lexema, numLinea);
          lexemas.add(
            lexema,
          );
        }
        if (coincide) break;
      }

      if (!coincide) {
        modePanic = true;
        errorMessage =
            'Error en el análisis léxico: Token (${palabras[numPalabras]}) no reconocido en la linea ${numLinea + 1}';
      }
    }
  }

  void addIdentifier(Lexema lexema, int numLinea) {
    if (identifier.isEmpty) {
      lexema.addLine(numLinea + 1);
      addType(lexema);
      identifier.add(lexema);
      return;
    }

    for (Lexema element in identifier) {
      if (element.lexema == lexema.lexema) {
        element.addLine(numLinea + 1);
        return;
      }
    }
    addType(lexema);
    lexema.addLine(numLinea + 1);
    identifier.add(lexema);
  }

  void addType(Lexema lexema) {
    if (lexemas.isEmpty) return;
    if ((lexemas.last.lexema.trim() == '@int') ||
        (lexemas.last.lexema.trim() == '@string')) {
      lexema.setTipo(lexemas.last.lexema);
    }
  }

  int ultimoToken(int categoria) {
    String cadenaComparar = '${(categoria + 1) * 100}';

    if (lexemas.isEmpty) return 0;
    Lexema ultimo = lexemas.lastWhere(
        (lexema) => lexema.clase == cadenaComparar,
        orElse: () => Lexema('', 0, '', ''));
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
