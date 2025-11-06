import 'package:flutter/material.dart';
import 'package:telas/imagem.dart';
import 'package:telas/favoritos.dart';

import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

class Img {
  String nomeImg = '';
  String link = '';
  bool favorita = false;
  Img(this.nomeImg, this.link);

  void setImgNome(String nomeImg) {
    this.nomeImg = nomeImg;
  }

  void setImgLink(String link) {
    this.link = link;
  }

  void setImgFav(bool fav) {
    this.favorita = fav;
  }
}

Widget imagem(String caminho,
    {largura = 90, altura = 90, VoidCallback? funcao}) {
  if (caminho.startsWith('assets/')) {
    return GestureDetector(
      onTap: funcao,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child: Column(
          children: [
            Image.asset(
              caminho,
              width: largura,
              height: altura,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  } else {
    return GestureDetector(
      onTap: funcao,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child: Column(
          children: [
            Image.network(
              caminho,
              width: largura,
              height: altura,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
