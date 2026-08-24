import 'package:flutter/material.dart';

import '../models/game_settings.dart';

class SettingsController extends ChangeNotifier {
  final GameSettings settings = GameSettings();

  void salvar({TamanhoTijolo? tamanho, int? colunas, Color? cor}) {
    if (tamanho != null) {
      settings.tamanho = tamanho;
    }
    if (colunas != null) {
      settings.colunas = colunas;
    }
    if (cor != null) {
      settings.cor = cor;
    }
    notifyListeners();
  }
}
