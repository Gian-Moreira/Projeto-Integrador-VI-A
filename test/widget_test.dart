import 'package:flutter_test/flutter_test.dart';

import 'package:brick_braker/controllers/settings_controller.dart';
import 'package:brick_braker/main.dart';

void main() {
  testWidgets('Home mostra título, equipe e botões do wireframe', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      BrickBrakerApp(settingsController: SettingsController()),
    );

    expect(find.text('Brick Braker'), findsOneWidget);
    expect(find.text('Gabriel Robinson de Azevedo'), findsOneWidget);
    expect(find.text('Jogar'), findsOneWidget);
    expect(find.text('Configurações'), findsOneWidget);
  });

  testWidgets('Configurações abre a tela de opções da parede', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      BrickBrakerApp(settingsController: SettingsController()),
    );

    await tester.tap(find.text('Configurações'));
    await tester.pumpAndSettle();

    expect(find.text('Tamanho dos tijolos'), findsOneWidget);
    expect(find.text('Quantidade de colunas'), findsOneWidget);
    expect(find.text('Cor dos Tijolos'), findsOneWidget);
  });
}
