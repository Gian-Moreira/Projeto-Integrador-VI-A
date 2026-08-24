import 'package:flutter/material.dart';

enum TamanhoTijolo { pequeno, medio, grande }

class GameSettings {
  GameSettings({
    this.tamanho = TamanhoTijolo.medio,
    this.colunas = 6,
    this.cor = const Color(0xFF8BB4E0),
  });

  TamanhoTijolo tamanho;
  int colunas;
  Color cor;

  static const opcoesColunas = [4, 5, 6, 7, 8];

  static const cores = [
    Color(0xFF8BB4E0),
    Color(0xFFE07A7A),
    Color(0xFF7BC67E),
    Color(0xFFE0C36E),
    Color(0xFFC07BDE),
    Color(0xFFE09A5C),
  ];

  double get valorTamanho => switch (tamanho) {
    TamanhoTijolo.pequeno => 36,
    TamanhoTijolo.medio => 48,
    TamanhoTijolo.grande => 64,
  };

  String get rotuloTamanho => switch (tamanho) {
    TamanhoTijolo.pequeno => 'Pequeno',
    TamanhoTijolo.medio => 'Médio',
    TamanhoTijolo.grande => 'Grande',
  };
}
