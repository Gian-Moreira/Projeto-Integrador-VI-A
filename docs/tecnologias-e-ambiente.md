# Características do projeto

Este documento define o ambiente de desenvolvimento, as tecnologias, a linguagem e o processo de geração do arquivo APK para entrega do **Brick Braker**.

---

## Ambiente de desenvolvimento

| Item | Escolha |
| --- | --- |
| Sistema operacional | macOS, Windows ou Linux |
| IDE principal | [Android Studio](https://developer.android.com/studio) ou [Visual Studio Code](https://code.visualstudio.com/) |
| Extensões (VS Code) | Flutter e Dart |
| SDK do aplicativo | [Flutter SDK](https://docs.flutter.dev/get-started/install) |
| SDK Android | Android SDK (instalado pelo Android Studio) |
| JDK | Java 17 (distribuído com o Android Studio) |
| Emulador / dispositivo | Android Emulator ou smartphone Android com depuração USB |

Comandos para conferir o ambiente:

```bash
flutter doctor
flutter --version
```

O `flutter doctor` deve apontar o Flutter, o Android toolchain e pelo menos um dispositivo (emulador ou físico) como disponíveis.

---

## Tecnologias e linguagens

| Camada | Tecnologia |
| --- | --- |
| Linguagem | **Dart** |
| Framework | **Flutter** (aplicativo nativo para Android) |
| Arquitetura | **MVC** (Model–View–Controller) |
| Interface | Widgets Flutter, alinhados ao [wireframe](wireframes.md) |
| Entrega | APK Android gerado com `flutter build apk` |

Não será usada engine de jogos (Unity, Godot etc.). A partida é desenhada com widgets e um loop de atualização controlado pelo `GameController`.

### Organização MVC

```
lib/
  models/          # dados e regras
    brick.dart
    brick_wall.dart
    game_settings.dart
    game_state.dart
  views/           # telas (widgets)
    home_view.dart
    game_view.dart
    settings_view.dart
  controllers/     # orquestração
    game_controller.dart
    settings_controller.dart
    brick_wall_controller.dart
  main.dart
```

- **Model:** representa tijolo, parede, configurações (tamanho, colunas, cor) e estado da partida (nível, pontos, bola, raquete).
- **View:** desenha as três telas do wireframe (Home, Jogar, Configurações) e encaminha toques/gestos ao controller.
- **Controller:** aplica as configurações, constrói a parede de blocos, atualiza física da bola/raquete e pontuação.

Os métodos de montagem da parede estão descritos em [Documentação dos métodos](metodos-construcao-blocos.md).

---

## Geração do APK para entrega

O artefato de entrega é um APK *release* do Android.

### 1. Preparar o projeto

Na raiz do aplicativo Flutter:

```bash
flutter pub get
flutter analyze
```

### 2. Gerar o APK

```bash
flutter build apk --release
```

O arquivo gerado fica em:

```
build/app/outputs/flutter-apk/app-release.apk
```

Esse é o arquivo a ser entregue.

### 3. Conferir a instalação (opcional)

```bash
flutter install --release
```

Ou copiar o APK para o dispositivo e instalar manualmente.

### Observações de entrega

- O build `--release` gera o pacote otimizado, sem modo debug.
- O APK único (`app-release.apk`) atende a entrega acadêmica. Se for necessário reduzir tamanho, pode-se usar `flutter build apk --split-per-abi`, gerando um APK por arquitetura (`armeabi-v7a`, `arm64-v8a`, `x86_64`).
- Não é exigido publicação na Play Store; o APK local é suficiente.

---

[Voltar ao README](../README.md)
