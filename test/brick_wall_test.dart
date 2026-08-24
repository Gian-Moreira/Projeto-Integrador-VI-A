import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:brick_braker/models/brick_wall.dart';

void main() {
  const area = Size(360, 640);

  test('grade regular preenche todas as células', () {
    final parede = BrickWall();
    parede.gerarParede(
      colunas: 6,
      tamanho: 48,
      cor: const Color(0xFF8BB4E0),
      nivel: 1,
      area: area,
    );

    final linhas = parede.calcularLinhas();
    expect(parede.tijolos.length, linhas * 6);
    expect(parede.tijolos.every((tijolo) => tijolo.ativo), isTrue);
  });

  test('grade intercalada omite uma coluna nas linhas ímpares', () {
    final parede = BrickWall();
    parede.gerarParede(
      colunas: 6,
      tamanho: 48,
      cor: const Color(0xFF8BB4E0),
      nivel: 2,
      area: area,
    );

    final linhas = parede.calcularLinhas();
    var esperado = 0;
    for (var linha = 0; linha < linhas; linha++) {
      esperado += linha.isOdd ? 5 : 6;
    }
    expect(parede.tijolos.length, esperado);
  });

  test('pirâmide reduz a quantidade de tijolos a cada linha', () {
    final parede = BrickWall();
    parede.gerarParede(
      colunas: 6,
      tamanho: 48,
      cor: const Color(0xFF8BB4E0),
      nivel: 3,
      area: area,
    );

    expect(parede.tijolos.length, lessThan(parede.calcularLinhas() * 6));
    expect(parede.tijolos, isNotEmpty);
  });
}
