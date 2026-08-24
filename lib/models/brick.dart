import 'package:flutter/material.dart';

class Brick {
  Brick({
    required this.id,
    required this.linha,
    required this.coluna,
    required this.x,
    required this.y,
    required this.largura,
    required this.altura,
    required this.cor,
    this.ativo = true,
  });

  final int id;
  final int linha;
  final int coluna;
  final double x;
  final double y;
  final double largura;
  final double altura;
  final Color cor;
  bool ativo;

  Rect get retangulo => Rect.fromLTWH(x, y, largura, altura);
}
