import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:telas/aviso.dart';
import 'package:telas/imagem.dart';
import 'package:telas/favoritos.dart';
import 'package:telas/info.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Galeria';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Img> imagens = [];

  TextEditingController nomeController = TextEditingController();
  TextEditingController srcController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    srcController.dispose();
    super.dispose();
  }

  Future<List<Img>> listarImagensAssets() async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestJson);

    final caminhos = manifestMap.keys
        .where((String key) => key.startsWith('assets/'))
        .toList();

    final imagens = caminhos.map((caminho) {
      final nome = caminho.split('/').last;
      return Img(nome, caminho);
    }).toList();

    return imagens;
  }

  void abrirModal() {
    showDialog(
      context: context,
      builder: (context) {
        return modal(
          context,
          widgets: [
            input("Nome da imagem", controller: nomeController),
            input("Link da imagem", controller: srcController),
          ],
          onConfirm: () {
            Img novaImagem = Img(nomeController.text, srcController.text);
            setState(() {
              imagens.add(
                Img(nomeController.text, srcController.text),
              );
            });

            Navigator.of(context).pop();

            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => Aviso(image: novaImagem),
              ),
            );

            nomeController.clear();
            srcController.clear();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imagens.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Text(
              'Galeria',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            centerTitle: true,
          ),
          body: body(
            widgets: [
              SizedBox(
                height: 20,
              ),
              EstruturaGrid(
                fotos: imagens.map((img) => imagem(img.link)).toList(),
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: abrirModal,
                backgroundColor: Colors.red,
                child: const Icon(Icons.add_a_photo, color: Colors.white),
              ),
              const SizedBox(height: 10),
              floatingFavBtnRedirect(
                  context: context,
                  rota: Favoritos(
                    imagens: imagens.where((img) => img.favorita).toList(),
                  ),
                  icone: Icons.star),
              const SizedBox(height: 10),
              FloatingActionButton(
                onPressed: () async {
                  final lista = await listarImagensAssets();
                  setState(() {
                    imagens = lista;
                  });
                },
                tooltip: 'Carregar Imagens',
                backgroundColor: Colors.red,
                child: const Icon(Icons.local_dining, color: Colors.white),
              ),
            ],
          ));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            'Galeria',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          centerTitle: true,
        ),
        body: body(
          widgets: [
            EstruturaGrid(
              fotos: imagens
                  .map((img) => imagem(
                        img.link,
                        funcao: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => Info(img: img),
                            ),
                          );
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: abrirModal,
              backgroundColor: Colors.red,
              child: const Icon(Icons.add_a_photo, color: Colors.white),
            ),
            const SizedBox(height: 10),
            floatingFavBtnRedirect(
                context: context,
                rota: Favoritos(
                  imagens: imagens,
                ),
                icone: Icons.star)
          ],
        ));
  }
}

Widget EstruturaGrid({List<Widget> fotos = const []}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(10),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9),
        children: fotos,
      ),
    ),
  );
}

Widget body({List<Widget> widgets = const []}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [...widgets],
    ),
  );
}

Widget modal(BuildContext context,
    {List<Widget> widgets = const [], required VoidCallback onConfirm}) {
  return AlertDialog(
    title: Text("Adicionar Imagem"),
    insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 130),
    contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    content: Center(
      child: Column(
        children: [...widgets],
      ),
    ),
    actions: [
      TextButton(
          onPressed: onConfirm,
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.red),
            child: Text("adicionar",
                style: TextStyle(
                    backgroundColor: Colors.red, color: Colors.white)),
          )),
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.red),
            child: Text("Cancelar", style: TextStyle(color: Colors.white)),
          ))
    ],
  );
}

Widget input(String nome,
    {double bordaTamanho = 8.0,
    Color corFixa = Colors.black,
    Color corVariavel = Colors.red,
    double largura = 240.0,
    required TextEditingController controller}) {
  return Container(
    width: largura,
    margin: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nome,
          style: TextStyle(fontSize: 14, color: corFixa),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(bordaTamanho),
              borderSide: BorderSide(color: corFixa),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(bordaTamanho),
              borderSide: BorderSide(color: corVariavel),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget butaoRedirect(nome, BuildContext context, Widget route) {
  return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.purple),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => route,
            ),
          );
        },
        child: Text(nome,
            style: TextStyle(
              color: Colors.white,
            )),
      ));
}

Widget floatingFavBtnRedirect({
  required BuildContext context,
  required Widget rota,
  required IconData icone,
  Color backgroundColor = Colors.red,
  Color iconColor = Colors.white,
}) {
  return FloatingActionButton(
    backgroundColor: backgroundColor,
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => rota),
      );
    },
    child: Icon(icone, color: Colors.white),
  );
}

Widget botao(String texto, VoidCallback? funcao) {
  return TextButton(
      onPressed: funcao,
      style: TextButton.styleFrom(
          backgroundColor: Colors.red, padding: EdgeInsets.all(8)),
      child: Text(texto,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
}
