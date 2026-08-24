import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../controllers/settings_controller.dart';
import '../models/game_settings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        foregroundColor: kText,
        elevation: 0,
        title: const Text('Configurações'),
      ),
      body: AnimatedBuilder(
        animation: settingsController,
        builder: (context, _) {
          final settings = settingsController.settings;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            children: [
              const Text(
                'Tamanho dos tijolos',
                style: TextStyle(color: kText, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _DarkDropdown<TamanhoTijolo>(
                value: settings.tamanho,
                hint: 'Selecione',
                items: [
                  for (final tamanho in TamanhoTijolo.values)
                    DropdownMenuItem(
                      value: tamanho,
                      child: Text(_rotuloTamanho(tamanho)),
                    ),
                ],
                onChanged: (valor) {
                  if (valor != null) {
                    settingsController.salvar(tamanho: valor);
                  }
                },
              ),
              const SizedBox(height: 28),
              const Text(
                'Quantidade de colunas',
                style: TextStyle(color: kText, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _DarkDropdown<int>(
                value: settings.colunas,
                hint: 'Selecione',
                items: [
                  for (final colunas in GameSettings.opcoesColunas)
                    DropdownMenuItem(
                      value: colunas,
                      child: Text('$colunas'),
                    ),
                ],
                onChanged: (valor) {
                  if (valor != null) {
                    settingsController.salvar(colunas: valor);
                  }
                },
              ),
              const SizedBox(height: 28),
              const Text(
                'Cor dos Tijolos',
                style: TextStyle(color: kText, fontSize: 16),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  for (final cor in GameSettings.cores)
                    GestureDetector(
                      onTap: () => settingsController.salvar(cor: cor),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: cor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: settings.cor == cor
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String _rotuloTamanho(TamanhoTijolo tamanho) {
    return switch (tamanho) {
      TamanhoTijolo.pequeno => 'Pequeno',
      TamanhoTijolo.medio => 'Médio',
      TamanhoTijolo.grande => 'Grande',
    };
  }
}

class _DarkDropdown<T> extends StatelessWidget {
  const _DarkDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: kMutedText)),
          isExpanded: true,
          dropdownColor: kSurface,
          iconEnabledColor: kText,
          style: const TextStyle(color: kText, fontSize: 16),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
