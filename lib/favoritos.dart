import 'package:flutter/material.dart';
import 'package:telas/imagem.dart';
import 'package:telas/main.dart';
import 'info.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key, required this.imagens});
  final List<Img> imagens;

  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  @override
  Widget build(BuildContext context) {
    List<Img> favoritas = widget.imagens.where((img) => img.favorita).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favoritos",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
        leading: IconButton(
          tooltip: "Voltar",
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(children: [
        estruturaGridFav(
            fotos: favoritas
                .map((img) => imagem(img.link, funcao: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => Info(
                            img: img,
                          ),
                        ),
                      );
                    }))
                .toList())
      ]),
    );
  }
}

Widget estruturaGridFav({List<Widget> fotos = const []}) {
  if (fotos.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Não há favoritos',
            style:
                TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

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
