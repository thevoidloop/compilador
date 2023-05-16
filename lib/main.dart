import 'package:compilador/main_provider.dart';
import 'package:compilador/models/lexema_model.dart';
import 'package:compilador/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Consumer<MainProvider>(
          builder: (BuildContext context, procesado, Widget? child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Editor(codigoFuenteController: codigoFuenteController),
                  const SizedBox(height: 20),
                  RunBotton(
                    procesado: procesado,
                    codigoFuenteController: codigoFuenteController,
                  ),
                  TablaSimbolos(
                    procesado: procesado,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
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
        border: TableBorder.all(), // Permite establecer un borde para la tabla
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(60), // Permite controlar el ancho de la columna
          1: FlexColumnWidth(), // Se extiende para llenar el espacio restante
          2: FlexColumnWidth(),
          3: FixedColumnWidth(200), // Ancho de columna fijo
          4: FixedColumnWidth(200), // Ancho de columna fijo
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: rowTable(procesado), // Alineación vertical predeterminada
      ),
    );
  }

  List<TableRow> rowTable(MainProvider procesado) {
    int contador = 0;
    List<TableRow> table = [];

    table.add(
      const TableRow(
        children: <Widget>[
          Center(child: Text('No.')),
          Center(child: Text('Lexema')),
          Center(child: Text('Categoria')),
          Center(child: Text('Clase')),
          Center(child: Text('Token')),
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
        procesado.compilar();
      },
      child: const Text('RUN'),
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
