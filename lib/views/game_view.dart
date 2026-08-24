import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../app_colors.dart';
import '../controllers/brick_wall_controller.dart';
import '../controllers/game_controller.dart';
import '../controllers/settings_controller.dart';
import '../models/brick_wall.dart';
import '../models/game_state.dart';

class GameView extends StatefulWidget {
  const GameView({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with SingleTickerProviderStateMixin {
  late final GameController _controller;
  late final Ticker _ticker;
  Duration _ultimoTick = Duration.zero;
  Size? _area;

  @override
  void initState() {
    super.initState();
    _controller = GameController(
      settingsController: widget.settingsController,
      brickWallController: BrickWallController(),
    );
    _ticker = createTicker(_onTick);
  }

  void _onTick(Duration elapsed) {
    if (_ultimoTick == Duration.zero) {
      _ultimoTick = elapsed;
      return;
    }
    final dt = (elapsed - _ultimoTick).inMicroseconds / 1000000;
    _ultimoTick = elapsed;
    _controller.atualizar(dt.clamp(0, 1 / 30));
  }

  void _garantirInicio(Size area) {
    if (_area == area) {
      return;
    }
    _area = area;
    _controller.iniciarNivel(
      _controller.state.nivel == 0 ? 1 : _controller.state.nivel,
      area,
    );
    if (!_ticker.isActive) {
      _ultimoTick = Duration.zero;
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final state = _controller.state;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Row(
                    children: [
                      Text(
                        'Nivel ${state.nivel}',
                        style: const TextStyle(color: kText, fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        'Pontos: ${state.pontos}',
                        style: const TextStyle(color: kText, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final area = Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );
                      if (_area != area) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            _garantirInicio(area);
                          }
                        });
                      }
                      return Stack(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onHorizontalDragUpdate: (details) {
                              _controller.moverRaquete(details.localPosition.dx);
                            },
                            onTapDown: (details) {
                              _controller.moverRaquete(details.localPosition.dx);
                            },
                            child: CustomPaint(
                              size: area,
                              painter: _GamePainter(
                                state: state,
                                parede: _controller.brickWallController.parede,
                              ),
                              child: SizedBox(
                                width: area.width,
                                height: area.height,
                              ),
                            ),
                          ),
                          if (state.status == StatusPartida.gameOver)
                            _GameOverOverlay(
                              pontos: state.pontos,
                              onJogarNovamente: () {
                                final areaAtual = _area;
                                if (areaAtual != null) {
                                  _controller.reiniciarPartida(areaAtual);
                                }
                              },
                              onInicio: () => Navigator.of(context).pop(),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GamePainter extends CustomPainter {
  _GamePainter({required this.state, required this.parede});

  final GameState state;
  final BrickWall parede;

  @override
  void paint(Canvas canvas, Size size) {
    for (final tijolo in parede.tijolosAtivos) {
      final rrect = RRect.fromRectAndRadius(
        tijolo.retangulo,
        const Radius.circular(4),
      );
      canvas.drawRRect(rrect, Paint()..color = tijolo.cor);
    }

    canvas.drawCircle(
      Offset(state.bolaX, state.bolaY),
      state.bolaRaio,
      Paint()..color = kBall,
    );

    final raquete = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(state.raqueteX, state.raqueteY),
        width: state.raqueteLargura,
        height: state.raqueteAltura,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(raquete, Paint()..color = kPaddle);
  }

  @override
  bool shouldRepaint(covariant _GamePainter oldDelegate) => true;
}

class _GameOverOverlay extends StatelessWidget {
  const _GameOverOverlay({
    required this.pontos,
    required this.onJogarNovamente,
    required this.onInicio,
  });

  final int pontos;
  final VoidCallback onJogarNovamente;
  final VoidCallback onInicio;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black54,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Material(
            color: kSurface,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Fim de jogo',
                    style: TextStyle(
                      color: kText,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pontos: $pontos',
                    style: const TextStyle(color: kMutedText, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: onJogarNovamente,
                    style: FilledButton.styleFrom(
                      backgroundColor: kPlayButton,
                      foregroundColor: kText,
                    ),
                    child: const Text('Jogar novamente'),
                  ),
                  TextButton(
                    onPressed: onInicio,
                    child: const Text(
                      'Início',
                      style: TextStyle(color: kText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
