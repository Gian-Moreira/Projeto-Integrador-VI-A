import 'package:flutter/material.dart';

enum StatusPartida { jogando, gameOver }

class GameState {
  int nivel = 1;
  int pontos = 0;
  StatusPartida status = StatusPartida.jogando;
  Size area = Size.zero;

  double bolaX = 0;
  double bolaY = 0;
  double bolaRaio = 8;
  double vx = 0;
  double vy = 0;

  double raqueteX = 0;
  double raqueteY = 0;
  double raqueteLargura = 88;
  double raqueteAltura = 14;
}
