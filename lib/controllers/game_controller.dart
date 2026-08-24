import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/game_state.dart';
import 'brick_wall_controller.dart';
import 'settings_controller.dart';

class GameController extends ChangeNotifier {
  GameController({
    required this.settingsController,
    required this.brickWallController,
  });

  final SettingsController settingsController;
  final BrickWallController brickWallController;
  final GameState state = GameState();

  void iniciarNivel(int nivel, Size area) {
    state.nivel = nivel;
    state.area = area;
    state.status = StatusPartida.jogando;

    brickWallController.aplicarConfiguracoes(settingsController.settings);
    brickWallController.gerarParede(nivel: nivel, area: area);

    _reiniciarBolaERaquete();
    notifyListeners();
  }

  void reiniciarPartida(Size area) {
    state.pontos = 0;
    iniciarNivel(1, area);
  }

  void moverRaquete(double x) {
    final metade = state.raqueteLargura / 2;
    state.raqueteX = x.clamp(metade, state.area.width - metade);
    notifyListeners();
  }

  void atualizar(double dt) {
    if (state.status != StatusPartida.jogando || state.area == Size.zero) {
      return;
    }

    state.bolaX += state.vx * dt;
    state.bolaY += state.vy * dt;

    _tratarParedes();
    _tratarRaquete();
    _tratarTijolos();

    if (state.bolaY - state.bolaRaio > state.area.height) {
      state.status = StatusPartida.gameOver;
    } else if (brickWallController.parede.todosDestruidos) {
      state.pontos += 50;
      iniciarNivel(state.nivel + 1, state.area);
      return;
    }

    notifyListeners();
  }

  void _reiniciarBolaERaquete() {
    final area = state.area;
    state.raqueteLargura = math.min(88, area.width * 0.28);
    state.raqueteAltura = 14;
    state.raqueteX = area.width / 2;
    state.raqueteY = area.height - 28;
    state.bolaRaio = 8;
    state.bolaX = state.raqueteX;
    state.bolaY = state.raqueteY - 28;

    final velocidade = 280 + (state.nivel - 1) * 22.0;
    const angulo = -math.pi / 3.4;
    state.vx = math.cos(angulo) * velocidade;
    state.vy = math.sin(angulo) * velocidade;
  }

  void _tratarParedes() {
    final r = state.bolaRaio;
    if (state.bolaX - r <= 0) {
      state.bolaX = r;
      state.vx = state.vx.abs();
    } else if (state.bolaX + r >= state.area.width) {
      state.bolaX = state.area.width - r;
      state.vx = -state.vx.abs();
    }

    if (state.bolaY - r <= 0) {
      state.bolaY = r;
      state.vy = state.vy.abs();
    }
  }

  void _tratarRaquete() {
    if (state.vy <= 0) {
      return;
    }

    final bola = Rect.fromCircle(
      center: Offset(state.bolaX, state.bolaY),
      radius: state.bolaRaio,
    );
    final raquete = Rect.fromCenter(
      center: Offset(state.raqueteX, state.raqueteY),
      width: state.raqueteLargura,
      height: state.raqueteAltura,
    );

    if (!bola.overlaps(raquete)) {
      return;
    }

    state.bolaY = raquete.top - state.bolaRaio;
    state.vy = -state.vy.abs();

    final offset =
        ((state.bolaX - state.raqueteX) / (state.raqueteLargura / 2)).clamp(
          -1.0,
          1.0,
        );
    state.vx += offset * 180;
    _limitarVelocidade();
  }

  void _tratarTijolos() {
    final bola = Rect.fromCircle(
      center: Offset(state.bolaX, state.bolaY),
      radius: state.bolaRaio,
    );

    for (final tijolo in brickWallController.parede.tijolosAtivos) {
      final bloco = tijolo.retangulo;
      if (!bola.overlaps(bloco)) {
        continue;
      }

      tijolo.ativo = false;
      state.pontos += 10;

      final overlapX = math.min(bola.right - bloco.left, bloco.right - bola.left);
      final overlapY = math.min(bola.bottom - bloco.top, bloco.bottom - bola.top);
      if (overlapX < overlapY) {
        state.vx = -state.vx;
        state.bolaX += state.vx > 0 ? overlapX : -overlapX;
      } else {
        state.vy = -state.vy;
        state.bolaY += state.vy > 0 ? overlapY : -overlapY;
      }
      break;
    }
  }

  void _limitarVelocidade() {
    final velocidade = math.sqrt(state.vx * state.vx + state.vy * state.vy);
    final alvo = 280 + (state.nivel - 1) * 22.0;
    if (velocidade == 0) {
      return;
    }
    final fator = alvo / velocidade;
    state.vx *= fator;
    state.vy *= fator;
  }
}
