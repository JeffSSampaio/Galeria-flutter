import 'package:flutter/material.dart';
import 'package:telas/imagem.dart';

class Aviso extends StatefulWidget {
  const Aviso({super.key, required this.image});
  final Img image;

  @override
  _AvisosState createState() => _AvisosState();
}

class _AvisosState extends State<Aviso> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              "Imagem adicionada: ${widget.image.nomeImg}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff33ff00),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Color(0xff000000)),
              label: const Text(
                "Fechar",
                style: TextStyle(color: Color(0xff000000)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
