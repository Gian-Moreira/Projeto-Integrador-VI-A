# Métodos de construção da parede de blocos

Este documento descreve **quais** métodos montam a parede de tijolos do Brick Braker e **como** cada um funciona. A construção fica no **Model** (`BrickWall`) e é disparada pelo **Controller** (`BrickWallController`), usando as opções da tela Configurações.

---

## Origem dos parâmetros

A parede não é desenhada à mão em cada nível. Ela é gerada em tempo de execução a partir de três configurações (ver [wireframe](wireframes.md)):

| Configuração | Uso na construção |
| --- | --- |
| Tamanho dos tijolos | Largura e altura de cada bloco |
| Quantidade de colunas | Número de blocos por linha |
| Cor dos tijolos | Cor aplicada a todos os blocos da parede |

O controller lê esses valores e chama o método de construção correspondente ao nível atual.

---

## Modelo de um tijolo

Cada bloco é uma instância de `Brick`:

| Campo | Função |
| --- | --- |
| `id` | Identificador único na parede |
| `linha` / `coluna` | Posição na grade |
| `x` / `y` | Coordenadas na tela |
| `largura` / `altura` | Dimensão (tamanho configurado) |
| `cor` | Cor configurada |
| `ativo` | `true` enquanto o bloco não foi destruído |

A parede é a lista de tijolos ativos. Quando a bola acerta um bloco, `ativo` passa a `false` e o bloco deixa de ser desenhado.

---

## Métodos

Os métodos abaixo pertencem a `BrickWall` (model) e são usados por `BrickWallController`.

### 1. `gerarParede`

**Papel:** ponto de entrada da construção.

**Como funciona:**

1. Recebe `colunas`, `tamanho`, `cor` e `nivel`.
2. Calcula quantas linhas cabem na área de jogo (`calcularLinhas`).
3. Escolhe o padrão pelo nível (`selecionarPadrao`).
4. Chama o método de padrão (grade regular, intercalada ou pirâmide).
5. Para cada posição válida, chama `criarTijolo` e guarda o bloco na lista.

É o único método que a `GameView` precisa conhecer indiretamente: o controller chama `gerarParede` ao iniciar a partida ou ao avançar de nível.

### 2. `calcularLinhas`

**Papel:** definir a altura da parede.

**Como funciona:** usa o tamanho do tijolo, o espaçamento entre blocos e a faixa superior da tela (abaixo de “Nivel X / Pontos”). O resultado é o número de linhas, limitado para não invadir a área da bola e da raquete.

Quanto maior o tijolo, menor o número de linhas. Quanto menor, mais linhas — a dificuldade visual acompanha a configuração.

### 3. `calcularPosicao`

**Papel:** converter (linha, coluna) em coordenadas `(x, y)`.

**Como funciona:**

```
x = margemEsquerda + coluna * (tamanho + espacamento)
y = margemTopo + linha * (tamanho + espacamento)
```

A margem esquerda centra a grade quando a quantidade de colunas não ocupa a largura inteira da tela. Assim a parede permanece alinhada em qualquer combinação de tamanho × colunas.

### 4. `criarTijolo`

**Papel:** instanciar um `Brick`.

**Como funciona:** recebe linha, coluna, tamanho e cor; chama `calcularPosicao`; devolve o tijolo com `ativo = true`. Toda inserção na parede passa por este método, para manter posição e cor consistentes.

### 5. `selecionarPadrao`

**Papel:** escolher o método de montagem de acordo com o nível.

| Nível | Método chamado | Resultado |
| --- | --- | --- |
| 1 | `construirGradeRegular` | Retângulo completo |
| 2 | `construirGradeIntercalada` | Linhas deslocadas (tijolinho) |
| 3+ | `construirPiramide` | Pirâmide centrada |

Novos níveis reutilizam esses três padrões, aumentando linhas ou colunas em vez de criar um método novo a cada fase.

### 6. `construirGradeRegular`

**Papel:** parede retangular, método base.

**Como funciona:** dois laços — linhas e colunas. Em toda célula `(linha, coluna)` é criado um tijolo. É o padrão do nível 1 e o mais previsível para o jogador.

```
para linha de 0 até linhas - 1
  para coluna de 0 até colunas - 1
    criarTijolo(linha, coluna)
```

### 7. `construirGradeIntercalada`

**Papel:** parede em formato de alvenaria.

**Como funciona:** igual à grade regular, mas linhas ímpares recebem um deslocamento horizontal de `tamanho / 2`. Nas linhas ímpares, a última coluna é omitida para o bloco extra não sair da tela. O formato quebra o alinhamento vertical e muda o ricochete da bola.

### 8. `construirPiramide`

**Papel:** parede triangular.

**Como funciona:** na linha `i` são colocados `colunas - i` tijolos, centralizados com `calcularPosicao`. A base fica em cima (mais blocos) e o topo da pirâmide aponta para a raquete — ou o inverso, conforme o nível. Há menos blocos que na grade regular, mas o formato exige mais precisão.

### 9. `aplicarConfiguracoes`

**Papel:** ligar a tela Configurações à construção.

**Como funciona:** o `SettingsController` grava tamanho, colunas e cor em `GameSettings`. Antes de `gerarParede`, o `BrickWallController` chama `aplicarConfiguracoes` e usa esses valores. Sem isso, a parede ignoraria o que o jogador escolheu.

---

## Fluxo de construção

```
Configurações (tamanho, colunas, cor)
        ↓
SettingsController.salvar()
        ↓
GameController.iniciarNivel(nivel)
        ↓
BrickWallController.gerarParede(...)
        ↓
calcularLinhas → selecionarPadrao → construir*
        ↓
lista de Brick na View
```

A `GameView` apenas percorre os tijolos com `ativo == true` e os desenha. Ela não decide o formato da parede.

---

## Relação com a partida

| Evento | Efeito na parede |
| --- | --- |
| Toque em **Jogar** | `gerarParede` com nível 1 e as configurações atuais |
| Todos os tijolos destruídos | Avança o nível e chama `gerarParede` de novo |
| Alterar configurações e jogar | A próxima parede usa tamanho, colunas e cor novos |

A destruição de um bloco (colisão com a bola) não é método de *construção*; apenas marca `ativo = false`. A reconstrução só ocorre ao iniciar ou repetir um nível.

---

[Voltar ao README](../README.md)
