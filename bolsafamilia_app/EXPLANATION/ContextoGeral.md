# Contexto do Código Flutter – Bolsa Família App

**Data da captura:** 15/03/2026  
**Objetivo:** Documento de referência para análise futura do projeto.

---

## 1. Visão geral do projeto

- **Nome:** `bolsafamilia_app`
- **Descrição:** App Flutter que consulta uma API REST (Spring/Java) para buscar beneficiários do Bolsa Família.
- **SDK:** Dart ^3.10.3
- **Dependências principais:** `flutter`, `provider`, `dio`, `cupertino_icons`

### Estrutura de pastas (código fonte)

```
lib/
├── main.dart                 # Ponto de entrada, MultiProvider, MaterialApp
├── models/
│   ├── bolsafamilia_model.dart   # Modelo de dados do beneficiário
│   └── buscas.dart              # Enum GetBuscas + extensão (labels)
├── providers/
│   └── bolsa_provider.dart      # ChangeNotifier, chamadas à API, estado da lista
├── services/
│   └── api_services.dart        # Dio, GET na API com query params
└── views/
    └── page_one.dart            # Tela única: dropdown tipo busca + campo texto + ListView
test/
└── widget_test.dart             # Teste básico (ainda referência counter; não adaptado ao app)
```

---

## 2. Arquivos e responsabilidades

### 2.1 `lib/main.dart`

- `main()`: registra `BolsaProvider` via `MultiProvider` e inicia o app.
- `MyApp`: `MaterialApp` com `debugShowCheckedModeBanner: false`, tema azul, `home: PageOne()`.

### 2.2 `lib/models/bolsafamilia_model.dart`

- **Classe:** `BolsaFamiliaModel`
- **Campos:** `id`, `competencia`, `uf`, `nomeMunicipio`, `nomeFavorecido`, `valorParcela`, `nisFavorecido` (todos nullable).
- **Factory:** `BolsaFamiliaModel.fromJson(Map<String, dynamic>)` — converte JSON da API (Java/Spring) para o modelo; trata `valorParcela` como int ou double.

### 2.3 `lib/models/buscas.dart`

- **Enum:** `GetBuscas` com valores: `nomeFavorecido`, `nomeMunicipio`, `nisFavorecido`.
- **Extensão:** `ExtencaoBuscas` em `GetBuscas` com getter `label` retornando "Nome", "Município" ou "NIS" conforme o caso.

### 2.4 `lib/services/api_services.dart`

- **Classe:** `ApiServices`
- **Cliente HTTP:** `Dio` (instância privada `_dio`).
- **URL base:** `http://192.168.1.9:8080/api/Bolsafamiliamodel/busca` (IP local; comentário pede para ajustar).
- **Método:** `getBeneficiarios({ String usuarioDigitado = "", GetBuscas busca = GetBuscas.nomeFavorecido, int pagina = 0 })`
  - Monta `queryParameters`: `pagina`, `tamanho: 20`, e um terceiro parâmetro conforme `busca`:
    - `nome` (nomeFavorecido), `nomeMunicipio` ou `nisFavorecido`.
  - Faz GET, lê `response.data['content']`, mapeia para `BolsaFamiliaModel.fromJson`.
  - Em erro: `print("Erro na API: $e")` e retorna lista vazia.

### 2.5 `lib/providers/bolsa_provider.dart`

- **Classe:** `BolsaProvider` com `ChangeNotifier`.
- **Estado:** `lista` (List<BolsaFamiliaModel>), `isLoading`, `paginaAtual`, `usuarioBuscaAtual`, `tipoBuscaAtual` (GetBuscas).
- **Métodos:**
  - `novaBusca(String usuarioDigitado, GetBuscas tipoBusca)`: zera lista e página, seta loading, chama API, preenche `lista`, notifica.
  - `carregarMais()`: incrementa `paginaAtual`, chama API com mesmos filtros, adiciona resultado em `lista`; evita chamadas concorrentes checando `isLoading`.

### 2.6 `lib/views/page_one.dart`

- **Widget:** `PageOne` (StatefulWidget), estado `_PageOneState`.
- **Controladores:** `TextEditingController` (campo de busca), `ScrollController` (ListView).
- **Estado local:** `_tipoBuscaSelecionado` (GetBuscas), default `nomeFavorecido`.
- **Layout:** Scaffold com AppBar "Bolsa Familia 👀", body em Column:
  - Row: `DropdownButtonFormField<GetBuscas>` (Tipo de Busca) + `TextField` com suffixIcon (ícone de busca) que chama `provider.novaBusca(texto, tipo)`.
  - `Expanded` com `ListView.builder`: mostra `provider.lista` como `ListTile` (CircleAvatar com UF, title nomeFavorecido, subtitle "nomeMunicipio - NIS: nisFavorecido", trailing "R$ valorParcela"); se `provider.isLoading` adiciona um item extra com `CircularProgressIndicator`.
- **dispose:** libera `_scrollController` e chama `super.dispose()` (o TextEditingController não está sendo disposed explicitamente no trecho documentado — ponto de atenção para análise futura).

**Observação:** O `DropdownButtonFormField` usa `initialValue`; em Flutter o correto para valor controlado é geralmente `value` + `onChanged`. Pode ser outro ponto para revisão.

### 2.7 `test/widget_test.dart`

- Teste de fumaça que espera texto "0" e "1" e ícone `Icons.add` — herança do template counter; **não reflete o fluxo do Bolsa Família** e tende a falhar no app atual.

---

## 3. Fluxo de dados

1. Usuário escolhe tipo de busca (Nome/Município/NIS) e digita no campo; ao clicar no ícone de busca chama `BolsaProvider.novaBusca(texto, tipo)`.
2. Provider zera lista e página, seta loading, chama `ApiServices.getBeneficiarios(...)` e atualiza `lista`.
3. A UI observa o provider com `context.watch<BolsaProvider>()` e reage a `notifyListeners()`.
4. Paginação: existe `carregarMais()` no provider, mas na `PageOne` documentada **não há** chamada a `carregarMais()` (ex.: scroll listener no ListView) — a paginação não está ligada na UI.

---

## 4. Pontos para análise futura

- **API:** URL com IP fixo (`192.168.1.9:8080`); considerar env/config ou constantes por ambiente.
- **Tratamento de erro:** apenas `print` e retorno de lista vazia; sem feedback visual ou mensagem ao usuário.
- **Paginação:** `carregarMais()` implementado no provider mas não utilizado na tela (sem scroll listener ou botão “Carregar mais”).
- **Dispose:** `TextEditingController` em `PageOne` não está no `dispose` documentado (pode já estar em outro trecho; confirmar no código atual).
- **Dropdown:** uso de `initialValue` em `DropdownButtonFormField`; verificar se o valor selecionado está sendo atualizado corretamente em todos os casos.
- **Testes:** `widget_test.dart` desatualizado em relação ao app; adaptar ou adicionar testes para PageOne e provider.

---

## 5. Código fonte completo (referência)

<details>
<summary>main.dart</summary>

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/bolsa_provider.dart';
import 'views/page_one.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BolsaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PageOne(),
    );
  }
}
```

</details>

<details>
<summary>bolsafamilia_model.dart</summary>

```dart
class BolsaFamiliaModel {
  final int? id;
  final String? competencia;
  final String? uf;
  final String? nomeMunicipio;
  final String? nomeFavorecido;
  final double? valorParcela;
  final String? nisFavorecido;

  BolsaFamiliaModel({
    this.id,
    this.competencia,
    this.uf,
    this.nomeMunicipio,
    this.nomeFavorecido,
    this.valorParcela,
    this.nisFavorecido,
  });

  factory BolsaFamiliaModel.fromJson(Map<String, dynamic> json) {
    return BolsaFamiliaModel(
      id: json['id'],
      competencia: json['competencia'],
      uf: json['uf'],
      nomeMunicipio: json['nomeMunicipio'],
      nomeFavorecido: json['nomeFavorecido'],
      valorParcela: json['valorParcela'] is int 
          ? (json['valorParcela'] as int).toDouble() 
          : json['valorParcela'],
      nisFavorecido: json['nisFavorecido'],
    );
  }
}
```

</details>

<details>
<summary>buscas.dart</summary>

```dart
enum GetBuscas {
  nomeFavorecido,
  nomeMunicipio,
  nisFavorecido,
}

extension ExtencaoBuscas on GetBuscas {
  String get label {
    switch(this) {
      case GetBuscas.nomeFavorecido:
        return "Nome";
      case GetBuscas.nomeMunicipio:
        return "Município";
      case GetBuscas.nisFavorecido:
        return "NIS";
    }
  }
}
```

</details>

<details>
<summary>api_services.dart</summary>

```dart
import 'package:bolsafamilia_app/models/buscas.dart';
import 'package:dio/dio.dart';
import '../models/bolsafamilia_model.dart';

class ApiServices {
  final Dio _dio = Dio();
  final String _url = "http://192.168.1.9:8080/api/Bolsafamiliamodel/busca";

  Future<List<BolsaFamiliaModel>> getBeneficiarios({
    String usuarioDigitado = "",
    GetBuscas busca = GetBuscas.nomeFavorecido,
    int pagina = 0
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        "pagina": pagina,
        "tamanho": 20,
      };
      switch(busca) {
        case GetBuscas.nomeFavorecido:
          queryParameters["nome"] = usuarioDigitado;
          break;
        case GetBuscas.nomeMunicipio:
          queryParameters["nomeMunicipio"] = usuarioDigitado;
          break;
        case GetBuscas.nisFavorecido:
          queryParameters["nisFavorecido"] = usuarioDigitado;
          break;
      }
      final response = await _dio.get(_url, queryParameters: queryParameters);
      List dados = response.data['content'];
      return dados.map((json) => BolsaFamiliaModel.fromJson(json)).toList();
    } catch(e) {
      print("Erro na API: $e");
      return [];
    }
  }
}
```

</details>

<details>
<summary>bolsa_provider.dart</summary>

```dart
import 'package:bolsafamilia_app/models/buscas.dart';
import 'package:flutter/material.dart';
import '../models/bolsafamilia_model.dart';
import '../services/api_services.dart';

class BolsaProvider with ChangeNotifier {
  final ApiServices _service = ApiServices();

  List<BolsaFamiliaModel> lista = [];
  bool isLoading = false;
  int paginaAtual = 0;
  String usuarioBuscaAtual = "";
  GetBuscas tipoBuscaAtual = GetBuscas.nomeFavorecido;

  Future<void> novaBusca(String usuarioDigitado, GetBuscas tipoBusca) async {
    usuarioBuscaAtual = usuarioDigitado;
    tipoBuscaAtual = tipoBusca;
    paginaAtual = 0;
    lista = [];
    isLoading = true;
    notifyListeners();

    lista = await _service.getBeneficiarios(
      usuarioDigitado: usuarioBuscaAtual,
      busca: tipoBuscaAtual,
      pagina: paginaAtual,
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> carregarMais() async {
    if (isLoading) return;
    paginaAtual++;
    isLoading = true;
    notifyListeners();

    final novosDados = await _service.getBeneficiarios(
      usuarioDigitado: usuarioBuscaAtual,
      busca: tipoBuscaAtual,
      pagina: paginaAtual,
    );

    lista.addAll(novosDados);
    isLoading = false;
    notifyListeners();
  }
}
```

</details>

<details>
<summary>page_one.dart</summary>

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bolsa_provider.dart';
import '../models/buscas.dart';

class PageOne  extends StatefulWidget{
  const PageOne({super.key});

  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
   final TextEditingController _textController = TextEditingController();
   final ScrollController _scrollController = ScrollController();

 GetBuscas _tipoBuscaSelecionado = GetBuscas.nomeFavorecido;

  @override
  Widget build(BuildContext context){
    final provider = context.watch<BolsaProvider>();

    return Scaffold(
      appBar: AppBar( title: const Text("Bolsa Familia 👀")),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(flex: 2,
              child: DropdownButtonFormField<GetBuscas>(
                initialValue: _tipoBuscaSelecionado,
                decoration: const InputDecoration(
                  labelText: "Tipo de Busca",
                  border: OutlineInputBorder(),
                  ),
                  items: GetBuscas.values.map((tipo){
                    return DropdownMenuItem(value: tipo,
                    child:  Text(tipo.label),
                    );
                  }).toList(),
                  onChanged: (novoGetBusca){
                    if (novoGetBusca != null){
                      setState(() {
                        _tipoBuscaSelecionado = novoGetBusca;
                      });
                    }
                  },
              ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: "Escreva aqui!",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => provider.novaBusca(
                        _textController.text,
                        _tipoBuscaSelecionado,
                        ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          ),
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
        ],
      ),
    );
  }
  @override
    void dispose(){
      _scrollController.dispose();
      super.dispose();
    }
}
```

</details>

<details>
<summary>widget_test.dart</summary>

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bolsafamilia_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget( const MyApp());
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
```

</details>

---

## 6. pubspec.yaml (referência)

```yaml
name: bolsafamilia_app
description: "A new Flutter project."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.10.3

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.1
  dio: ^5.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

---

*Documento gerado para preservar o contexto do código Flutter do bolsafamilia_app para análise futura.*
