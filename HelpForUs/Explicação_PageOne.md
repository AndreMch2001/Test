# Documentação didática: `page_one.dart`

Este arquivo explica **linha por linha** o código da tela de busca do app Bolsa Família, incluindo a funcionalidade de **scroll infinito** (carregar mais resultados ao rolar até o fim da lista).

---

## Índice

1. [Imports](#1-imports-linhas-1-4)
2. [Classe PageOne (StatefulWidget)](#2-classe-pageone-linhas-6-10)
3. [Classe _PageOneState e variáveis](#3-classe-_pageonestate-e-variáveis-linhas-12-16)
4. [initState e scroll infinito](#4-initstate-e-scroll-infinito-linhas-18-27)
5. [Método build](#5-método-build-linhas-29-104)
6. [dispose](#6-dispose-linhas-105-110)

---

## 1. Imports (linhas 1-4)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bolsa_provider.dart';
import '../models/buscas.dart';
```

| Linha | Código | Explicação |
|-------|--------|------------|
| 1 | `import 'package:flutter/material.dart';` | Importa os widgets de interface do Flutter (botões, textos, listas, cores, etc.). |
| 2 | `import 'package:provider/provider.dart';` | Importa o Provider para observar dados e reconstruir a tela quando a lista ou o loading mudam. |
| 3 | `import '../providers/bolsa_provider.dart';` | Importa o `BolsaProvider`, que guarda a lista de resultados, chama a API e tem os métodos `novaBusca` e `carregarMais`. |
| 4 | `import '../models/buscas.dart';` | Importa o enum `GetBuscas` (Nome, Município, NIS) usado no dropdown de tipo de busca. |

---

## 2. Classe PageOne (linhas 6-10)

```dart
class PageOne  extends StatefulWidget{ //classe que representa a tela de busca

  @override // poliformismo para criar o estado da tela
  _PageOneState createState() => _PageOneState(); // cria o estado da tela que será usado para controlar a tela
}
```

| Linha | Código | Explicação |
|-------|--------|------------|
| 6 | `class PageOne extends StatefulWidget{` | Define a tela como um **StatefulWidget**: uma tela que pode mudar (texto digitado, tipo de busca, lista, loading, e agora carregar mais ao rolar). |
| 7 | *(vazia)* | Apenas organização do código. |
| 8 | `@override` | Indica que o método abaixo sobrescreve um método da classe pai (`StatefulWidget`). |
| 9 | `_PageOneState createState() => _PageOneState();` | Método obrigatório: cria o objeto de **estado** (`_PageOneState`) onde ficam os controladores, o `initState`, o `build` e o `dispose`. |
| 10 | `}` | Fecha a classe `PageOne`. |

---

## 3. Classe _PageOneState e variáveis (linhas 12-16)

```dart
class _PageOneState extends State<PageOne> { // classe que representa o estado da tela de busca
   final TextEditingController _textController = TextEditingController(); // controlador de texto para o campo de busca
   final ScrollController _scrollController = ScrollController(); // controlador de scroll para a lista de resultados

 GetBuscas _tipoBuscaSelecionado = GetBuscas.nomeFavorecido; // variavel que controla o tipo de busca selecionado
```

| Linha | Código | Explicação |
|-------|--------|------------|
| 12 | `class _PageOneState extends State<PageOne> {` | Classe do **estado** da tela. O `_` deixa a classe privada a este arquivo. |
| 13 | `final TextEditingController _textController = TextEditingController();` | Controlador do campo de texto: permite ler o que o usuário digitou (`_textController.text`). |
| 14 | `final ScrollController _scrollController = ScrollController();` | Controlador da lista: usado para saber a posição do scroll e, no **scroll infinito**, detectar quando o usuário está perto do fim para chamar `carregarMais()`. |
| 15 | *(vazia)* | Organização do código. |
| 16 | `GetBuscas _tipoBuscaSelecionado = GetBuscas.nomeFavorecido;` | Guarda o tipo de busca atual (Nome, Município ou NIS). Valor inicial: "Nome". |

---

## 4. initState e scroll infinito (linhas 18-27)

```dart
  @override
  void initState() { // metodo que inicializa o estado da tela
    super.initState(); // chama o metodo super para inicializar o estado da tela
    // Listener de scroll: quando o usuário chega perto do fim da lista, carrega mais itens
    _scrollController.addListener(() { // metodo que adiciona um listener ao scroll para carregar mais itens
      final pos = _scrollController.position; // posição do scroll
      if (pos.pixels >= pos.maxScrollExtent - 200) { // verifica se o usuário chegou perto do fim da lista
        context.read<BolsaProvider>().carregarMais(); // carrega mais itens
      }
    });
  } // fim do metodo initState
```

Esta é a **alteração do scroll infinito**: ao rolar a lista e chegar perto do fim, a tela pede mais dados ao `BolsaProvider` automaticamente.

| Linha | Código | Explicação |
|-------|--------|------------|
| 18 | `@override` | Sobrescreve o método `initState` da classe pai. |
| 19 | `void initState() {` | Método chamado **uma vez** quando a tela é criada. Aqui configuramos o listener de scroll. |
| 20 | `super.initState();` | Chama o `initState` do Flutter; obrigatório antes de qualquer outra lógica. |
| 21 | `// Listener de scroll...` | Comentário explicando que o bloco abaixo é o listener de scroll infinito. |
| 22 | `_scrollController.addListener(() {` | Adiciona um **listener** ao scroll: sempre que o usuário rolar a lista, essa função é chamada. |
| 23 | `final pos = _scrollController.position;` | Obtém a **posição** atual do scroll: quanto já foi rolado (`pixels`) e o máximo possível (`maxScrollExtent`). |
| 24 | `if (pos.pixels >= pos.maxScrollExtent - 200) {` | Se o usuário está a **200 pixels ou menos** do fim da lista, entramos no `if`. O 200 evita esperar chegar exatamente no fim. |
| 25 | `context.read<BolsaProvider>().carregarMais();` | Chama o método **carregarMais()** do `BolsaProvider`, que busca a próxima página na API e adiciona os itens à lista. O `read` só lê o provider (não observa como o `watch`). |
| 26 | `}` | Fecha o `if`. |
| 27 | `});` e `}` | Fecham o callback do `addListener` e o método `initState`. |

**Resumo do scroll infinito:** ao rolar e ficar a 200px do fim, `carregarMais()` é chamado; o provider busca a próxima página, adiciona à `lista` e chama `notifyListeners()`, e a tela mostra os novos itens.

---

## 5. Método build (linhas 29-104)

### 5.1 Início do build e Scaffold (linhas 29-35)

```dart
  @override
  Widget build(BuildContext context){ // metodo que constrói a tela de busca
    final provider = context.watch<BolsaProvider>(); // contexto que observa o provider de busca para atualizar a tela

    return Scaffold( // tela de busca com appBar e body
      appBar: AppBar( title:  const Text("Bolsa Familia 👀")), // appBar com titulo fixo
      body: Column( // body com coluna para organizar os elementos da tela
```

| Linha | Código | Explicação |
|-------|--------|------------|
| 29 | `@override` | Sobrescreve o método `build` da classe pai. |
| 30 | `Widget build(BuildContext context){` | Método que **constrói** toda a interface. É chamado quando a tela é exibida e sempre que algo observado muda (ex.: após `setState` ou `notifyListeners` do provider). |
| 31 | `final provider = context.watch<BolsaProvider>();` | Obtém o `BolsaProvider` e **observa** ele: quando `novaBusca` ou `carregarMais` chamam `notifyListeners()`, o `build` roda de novo e a lista e o loading atualizam. |
| 33 | `return Scaffold(` | Retorna a estrutura base da tela: AppBar em cima e corpo (`body`) embaixo. |
| 34 | `appBar: AppBar( title:  const Text("Bolsa Familia 👀")),` | Barra superior com título fixo. |
| 35 | `body: Column(` | Corpo da tela: uma **coluna** que empilha os blocos na vertical (área de busca em cima, lista embaixo). |

### 5.2 Área de busca: Padding, Row, Dropdown e TextField (linhas 36-80)

| Linha | Código | Explicação |
|-------|--------|------------|
| 36 | `children: [` | Lista de filhos da Column (em ordem de cima para baixo). |
| 37 | `Padding(padding:  const EdgeInsets.all(8.0),` | Espaço de 8 pixels em volta da área de busca. |
| 38 | `child: Row(` | Uma **linha**: dropdown e campo de texto lado a lado. |
| 39 | `children: [` | Filhos da Row (da esquerda para a direita). |
| 40 | `Expanded(flex: 2,` | Primeiro filho: ocupa 2 partes de 5 (2/5 da largura). |
| 41 | `child: DropdownButtonFormField<GetBuscas>(` | Dropdown para escolher o tipo de busca (Nome, Município, NIS). |
| 42 | `initialValue: _tipoBuscaSelecionado,` | Valor exibido no dropdown. |
| 43-46 | `decoration: const InputDecoration(...)` | Label "Tipo de Busca" e borda. |
| 47-51 | `items: GetBuscas.values.map(...)` | Cria um item do dropdown para cada valor do enum (Nome, Município, NIS). |
| 52-58 | `onChanged: (novoGetBusca){ ... setState(...) }` | Quando o usuário muda a opção, atualiza `_tipoBuscaSelecionado` e pede reconstrução da tela. |
| 60 | `const SizedBox(width: 8),` | Espaço de 8 pixels entre dropdown e campo de texto. |
| 61-62 | `Expanded( flex: 3,` | Segundo filho: ocupa 3/5 da largura. |
| 64 | `controller: _textController,` | Liga o campo de texto ao controlador. |
| 65-76 | `decoration: InputDecoration(...)`, `suffixIcon: IconButton(...)` | Label "Escreva aqui!", botão de lupa que chama `provider.novaBusca(_textController.text, _tipoBuscaSelecionado)`. |
| 79 | `],` | Fecha os filhos da Row. |
| 80 | `),` | Fecha a Row e o Padding. |

### 5.3 Lista de resultados e loading (linhas 82-101)

```dart
          Expanded(child: ListView.builder(
            controller: _scrollController,
            itemCount: provider.lista.length + (provider.isLoading ? 1:0),
            itemBuilder: (context, index){
              if(index < provider.lista.length){
                final item = provider.lista[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(item.uf ?? "")),
                  title: Text(item.nomeFavorecido ?? ""),
                  subtitle: Text(
                    "${item.nomeMunicipio} - NIS: ${item.nisFavorecido}"),
                    trailing: Text("R\$ ${item.valorParcela}"),
                );
              } else{
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          ),
```

| Linha | Código | Explicação |
|-------|--------|------------|
| 82 | `Expanded(child: ListView.builder(` | Lista que ocupa o espaço restante da tela e constrói itens sob demanda (eficiente para muitos itens e para **scroll infinito**). |
| 83 | `controller: _scrollController,` | Associa a lista ao mesmo `_scrollController` usado no `initState`; assim o listener sabe quando o usuário está perto do fim. |
| 84 | `itemCount: provider.lista.length + (provider.isLoading ? 1:0),` | Número de itens: quantidade de resultados **mais** 1 se estiver carregando (esse item extra é o indicador de loading no fim). |
| 85 | `itemBuilder: (context, index){` | Constrói cada item da lista; chamado para cada `index` de 0 até `itemCount - 1`. |
| 86 | `if(index < provider.lista.length){` | Se for um índice de **resultado real** (não o item extra de loading). |
| 87 | `final item = provider.lista[index];` | Pega o beneficiário na posição `index`. |
| 88-94 | `return ListTile( leading: ..., title: ..., subtitle: ..., trailing: ... )` | Uma linha da lista: UF no círculo, nome no título, município e NIS no subtítulo, valor à direita. |
| 96 | `} else{` | Caso seja o **item extra** (só existe quando `isLoading` é true). |
| 97 | `return const Center(child: CircularProgressIndicator());` | Mostra o indicador de carregamento no fim da lista (usado tanto na busca inicial quanto no **scroll infinito** ao carregar mais). |
| 101 | `],` | Fecha os filhos da Column. |

### 5.4 Fechamento do build (linhas 102-104)

| Linha | Código | Explicação |
|-------|--------|------------|
| 102 | `),` | Fecha a Column. |
| 103 | `);` | Fecha o Scaffold e o `return`. |
| 104 | `}` | Fecha o método `build`. |

---

## 6. dispose (linhas 105-110)

```dart
  @override // sobreescreve o metodo dispose para liberar o controlador de scroll
    void dispose(){ // metodo que libera o controlador de scroll
      _scrollController.dispose(); // libera o controlador de scroll
      super.dispose(); // libera o controlador de texto
    }
}
```

| Linha | Código | Explicação |
|-------|--------|------------|
| 105 | `@override` | Sobrescreve o método `dispose` da classe pai. |
| 106 | `void dispose(){` | Chamado quando a tela é **removida** (ex.: usuário sai da tela). Serve para liberar recursos e evitar vazamento de memória. |
| 107 | `_scrollController.dispose();` | Libera o **ScrollController** (e o listener de scroll infinito deixa de ser usado). |
| 108 | `super.dispose();` | Chama o `dispose` da classe pai. *(Recomendado também chamar `_textController.dispose();` antes de `super.dispose();`.)* |
| 109 | `}` | Fecha o método `dispose`. |
| 110 | `}` | Fecha a classe `_PageOneState`. |

---

## Resumo da alteração: scroll infinito

1. **Onde:** no `initState`, é adicionado um **listener** ao `_scrollController`.
2. **Quando dispara:** sempre que o usuário rola a lista; dentro do listener, verifica se `pos.pixels >= pos.maxScrollExtent - 200`.
3. **O que faz:** chama `context.read<BolsaProvider>().carregarMais()`, que busca a próxima página na API e adiciona os itens à `lista`.
4. **O que o usuário vê:** ao chegar perto do fim, aparece o `CircularProgressIndicator` no fim da lista (por causa do `itemCount` com +1 quando `isLoading`) e, em seguida, os novos itens.

Assim, a tela passa a ter **scroll infinito**: rolar até perto do fim dispara o carregamento da próxima página automaticamente.

---

*Documento criado para fins didáticos e versionado no repositório do projeto.*
