import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../controllers/settings_controller.dart';
import 'game_view.dart';
import 'settings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.settingsController});

  final SettingsController settingsController;

  static const _equipe = [
    'Gabriel Robinson de Azevedo',
    'Felipe Bock Magagnin',
    'Gian Filipi de Lorenzzo Moreira',
    'Nathan Backes Lara',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                'Brick Braker',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kText,
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              for (final nome in _equipe)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    nome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kMutedText, fontSize: 16),
                  ),
                ),
              const Spacer(),
              _MenuButton(
                label: 'Jogar',
                color: kPlayButton,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          GameView(settingsController: settingsController),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _MenuButton(
                label: 'Configurações',
                color: kSurface,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SettingsView(
                        settingsController: settingsController,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: kText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
