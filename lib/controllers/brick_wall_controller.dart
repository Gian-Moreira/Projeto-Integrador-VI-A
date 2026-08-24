import 'package:flutter/material.dart';

import '../models/brick_wall.dart';
import '../models/game_settings.dart';

class BrickWallController {
  final BrickWall parede = BrickWall();
  GameSettings? _settings;

  void aplicarConfiguracoes(GameSettings settings) {
    _settings = settings;
  }

  void gerarParede({required int nivel, required Size area}) {
    final configuracao = _settings;
    if (configuracao == null) {
      throw StateError(
        'aplicarConfiguracoes deve ser chamado antes de gerarParede.',
      );
    }

    parede.gerarParede(
      colunas: configuracao.colunas,
      tamanho: configuracao.valorTamanho,
      cor: configuracao.cor,
      nivel: nivel,
      area: area,
    );
  }
}
