import 'package:flutter/material.dart';
import 'package:telas/imagem.dart';

class Info extends StatefulWidget {
  final Img img;

  const Info({
    super.key,
    required this.img,
  });

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  bool checked = false;
  @override
  void initState() {
    super.initState();
    checked = widget.img.favorita;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.img.link.startsWith('assets/')
                  ? Image.asset(widget.img.link, fit: BoxFit.cover)
                  : Image.network(widget.img.link, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text(
              "Nome: ${widget.img.nomeImg}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: checked,
                    onChanged: (value) {
                      setState(() {
                        checked = value ?? false;
                        widget.img.setImgFav(checked);
                      });
                    },
                  ),
                  Text(
                    'Favoritar',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.red),
              label: const Text(
                "Fechar",
                style: TextStyle(color: Colors.red),
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
