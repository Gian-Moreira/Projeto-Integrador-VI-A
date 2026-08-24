import 'dart:math' as math;
import 'dart:ui';

import 'brick.dart';

class BrickWall {
  final List<Brick> tijolos = [];

  int _proximoId = 0;
  double _tamanho = 48;
  static const double _espacamento = 6;
  int _colunas = 6;
  Color _cor = const Color(0xFF8BB4E0);
  double _larguraArea = 0;
  double _alturaArea = 0;
  static const double _margemTopo = 12;

  double get _larguraTijolo => _tamanho;
  double get _alturaTijolo => _tamanho * 0.42;

  bool get todosDestruidos =>
      tijolos.isNotEmpty && tijolos.every((tijolo) => !tijolo.ativo);

  List<Brick> get tijolosAtivos =>
      tijolos.where((tijolo) => tijolo.ativo).toList();

  void gerarParede({
    required int colunas,
    required double tamanho,
    required Color cor,
    required int nivel,
    required Size area,
  }) {
    tijolos.clear();
    _proximoId = 0;
    _colunas = colunas;
    _tamanho = tamanho;
    _cor = cor;
    _larguraArea = area.width;
    _alturaArea = area.height;

    final linhas = calcularLinhas();
    selecionarPadrao(nivel, linhas);
  }

  int calcularLinhas() {
    final areaMaxima = _alturaArea * 0.36;
    final passo = _alturaTijolo + _espacamento;
    if (passo <= 0) {
      return 3;
    }
    final linhas = ((areaMaxima - _margemTopo) / passo).floor();
    return linhas.clamp(3, 5);
  }

  Offset calcularPosicao(
    int linha,
    int coluna, {
    double deslocamentoX = 0,
  }) {
    final gradeLargura =
        _colunas * _larguraTijolo + (_colunas - 1) * _espacamento;
    final margemEsquerda = (_larguraArea - gradeLargura) / 2;
    final x =
        margemEsquerda + coluna * (_larguraTijolo + _espacamento) + deslocamentoX;
    final y = _margemTopo + linha * (_alturaTijolo + _espacamento);
    return Offset(x, y);
  }

  Brick criarTijolo(int linha, int coluna, {double deslocamentoX = 0}) {
    final posicao = calcularPosicao(
      linha,
      coluna,
      deslocamentoX: deslocamentoX,
    );
    final tijolo = Brick(
      id: _proximoId++,
      linha: linha,
      coluna: coluna,
      x: posicao.dx,
      y: posicao.dy,
      largura: _larguraTijolo,
      altura: _alturaTijolo,
      cor: _cor,
    );
    tijolos.add(tijolo);
    return tijolo;
  }

  void selecionarPadrao(int nivel, int linhas) {
    switch ((nivel - 1) % 3) {
      case 0:
        construirGradeRegular(linhas);
      case 1:
        construirGradeIntercalada(linhas);
      default:
        construirPiramide(linhas);
    }
  }

  void construirGradeRegular(int linhas) {
    for (var linha = 0; linha < linhas; linha++) {
      for (var coluna = 0; coluna < _colunas; coluna++) {
        criarTijolo(linha, coluna);
      }
    }
  }

  void construirGradeIntercalada(int linhas) {
    for (var linha = 0; linha < linhas; linha++) {
      final intercalada = linha.isOdd;
      final colunasNaLinha = intercalada ? math.max(1, _colunas - 1) : _colunas;
      final deslocamento = intercalada ? _tamanho / 2 : 0.0;
      for (var coluna = 0; coluna < colunasNaLinha; coluna++) {
        criarTijolo(linha, coluna, deslocamentoX: deslocamento);
      }
    }
  }

  void construirPiramide(int linhas) {
    final maxLinhas = math.min(linhas, _colunas);
    for (var linha = 0; linha < maxLinhas; linha++) {
      final quantidade = math.max(1, _colunas - linha);
      final deslocamento =
          ((_colunas - quantidade) * (_larguraTijolo + _espacamento)) / 2;
      for (var coluna = 0; coluna < quantidade; coluna++) {
        criarTijolo(linha, coluna, deslocamentoX: deslocamento);
      }
    }
  }
}
