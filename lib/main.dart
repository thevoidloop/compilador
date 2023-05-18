import 'package:compilador/main_provider.dart';
import 'package:compilador/models/lexema_model.dart';
import 'package:compilador/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => MainProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  late Size size;
  TextEditingController codigoFuenteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
        builder: (BuildContext context, procesado, Widget? child) {
      return MaterialApp(
        title: 'SNACK',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('SNACK - Analizador Lexico'),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RunBotton(
                    procesado: procesado,
                    codigoFuenteController: codigoFuenteController),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Editor(codigoFuenteController: codigoFuenteController),
                const SizedBox(width: 1000, child: CategoryTable()),
                TablaSimbolos(
                  procesado: procesado,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

void panicMode(BuildContext context, String errorMessage) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    title: 'ERROR',
    text: errorMessage,
    backgroundColor: Colors.black,
    titleColor: Colors.white,
    textColor: Colors.white,
  );
}

class TablaSimbolos extends StatelessWidget {
  final MainProvider procesado;
  const TablaSimbolos({
    super.key,
    required this.procesado,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Table(
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(10),
          color: Colors.lightBlueAccent,
        ), // Permite establecer un borde para la tabla
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(60), // Permite controlar el ancho de la columna
          1: FlexColumnWidth(), // Se extiende para llenar el espacio restante
          2: FlexColumnWidth(),
          3: FixedColumnWidth(200), // Ancho de columna fijo
          4: FixedColumnWidth(200), // Ancho de columna fijo
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: symbols(procesado), // Alineación vertical predeterminada
      ),
    );
  }

  List<TableRow> symbols(MainProvider procesado) {
    int contador = 0;
    List<TableRow> table = [];

    const styleHeader = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    table.add(
      const TableRow(
        children: <Widget>[
          Center(child: Text('No.', style: styleHeader)),
          Center(child: Text('Lexema', style: styleHeader)),
          Center(child: Text('Categoria', style: styleHeader)),
          Center(child: Text('Clase', style: styleHeader)),
          Center(child: Text('Token', style: styleHeader)),
        ],
      ),
    );

    for (Lexema element in procesado.lexemas) {
      contador++;
      table.add(
        TableRow(
          children: <Widget>[
            Center(child: Text(contador.toString())),
            Center(child: Text(element.lexema)),
            Center(child: Text(element.categoria)),
            Center(child: Text(element.clase)),
            Center(child: Text("#${element.token.toString().padLeft(3, '0')}")),
          ],
        ),
      );
    }

    return table;
  }
}

class CategoryTable extends StatelessWidget {
  const CategoryTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Table(
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(10),
          color: Colors.lightBlueAccent,
        ), // Permite establecer un borde para la tabla
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(60), // Permite controlar el ancho de la columna
          1: FlexColumnWidth(), // Ancho de columna fijo
          2: FixedColumnWidth(200), // Ancho de columna fijo
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: symbols(), // Alineación vertical predeterminada
      ),
    );
  }

  List<TableRow> symbols() {
    int contador = 0;
    List<TableRow> table = [];
    List<String> categories = [
      'Palabras de sistema',
      'Identificadores',
      'Operadores Aritméticos',
      'Operadores de Comparación',
      'Operadores de Asignación',
      'Símbolos',
      'Literales',
    ];

    const styleHeader = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    table.add(
      const TableRow(
        children: <Widget>[
          Center(child: Text('No.', style: styleHeader)),
          Center(child: Text('Categoria', style: styleHeader)),
          Center(child: Text('Clase', style: styleHeader)),
        ],
      ),
    );

    for (String element in categories) {
      contador++;
      table.add(
        TableRow(
          children: <Widget>[
            Center(child: Text(contador.toString())),
            Center(child: Text(element)),
            Center(child: Text('${contador * 100}')),
          ],
        ),
      );
    }

    return table;
  }
}

class RunBotton extends StatelessWidget {
  final MainProvider procesado;
  final TextEditingController codigoFuenteController;

  const RunBotton({
    super.key,
    required this.procesado,
    required this.codigoFuenteController,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        procesado.codigoFuente = codigoFuenteController.text;
        procesado.reset();
        procesado.compilar();
        if (procesado.modePanic) panicMode(context, procesado.errorMessage);
      },
      child: const Icon(Icons.play_circle_fill),
    );
  }
}

class Editor extends StatelessWidget {
  const Editor({
    super.key,
    required this.codigoFuenteController,
  });

  final TextEditingController codigoFuenteController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: 800,
        child: Enmarcar(
          child: TextFormField(
            controller: codigoFuenteController,
            decoration: const InputDecoration(
              fillColor: Colors.red,
              hoverColor: Colors.red,
            ),
            expands: true,
            maxLines: null,
            minLines: null,
          ),
        ),
      ),
    );
  }
}
