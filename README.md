# Bolsa Família – API + App

Projeto full-stack para consulta de beneficiários do programa Bolsa Família: **API REST em Java (Spring Boot)** e **aplicativo móvel em Flutter** que consome essa API.

---

## Visão geral

| Componente | Descrição |
|------------|-----------|
| **bolsafamilia** | API REST em Java com Spring Boot, JPA e PostgreSQL. Expõe endpoint de busca com filtros e paginação. |
| **bolsafamilia_app** | App Flutter (Android) que consulta a API, permitindo buscar por nome, município ou NIS e exibir resultados em lista com carregamento sob demanda. |

```
┌─────────────────────┐         HTTP GET          ┌──────────────────────────┐
│  bolsafamilia_app   │  ──────────────────────►  │  bolsafamilia (API Java) │
│  (Flutter / Dart)   │  /api/Bolsafamiliamodel/  │  (Spring Boot)            │
│                     │  busca?nome=...&pagina=0  │                          │
└─────────────────────┘                           └────────────┬─────────────┘
                                                               │
                                                               ▼
                                                    ┌──────────────────────────┐
                                                    │  PostgreSQL              │
                                                    │  (tabela: governo)       │
                                                    └──────────────────────────┘
```

---

## Funcionalidades

- **API (Java)**
  - Busca de beneficiários com filtros: nome do favorecido, UF, município, competência, NIS, faixa de valor (mín/máx).
  - Paginação configurável (`pagina`, `tamanho`).
  - CORS habilitado para consumo pelo app.

- **App (Flutter)**
  - Escolha do tipo de busca: **Nome**, **Município** ou **NIS**.
  - Campo de texto + botão de busca.
  - Lista de resultados (nome, município, NIS, UF, valor da parcela).
  - Indicador de carregamento e paginação infinita (carrega mais ao rolar até o fim da lista).

---

## Estrutura do repositório

```
Test/
├── bolsafamilia/              # API Java (Spring Boot)
│   ├── src/main/java/.../
│   │   ├── controller/        # Bolsafamiliacontroller (REST)
│   │   ├── model/             # Bolsafamiliamodel (JPA)
│   │   ├── repository/        # BolsafamiliaRepository
│   │   └── BolsafamiliaApplication.java
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
│
├── bolsafamilia_app/          # App Flutter
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/            # bolsafamilia_model, buscas (enum)
│   │   ├── providers/         # BolsaProvider (estado + API)
│   │   ├── services/          # ApiServices (Dio)
│   │   └── views/             # page_one (tela de busca)
│   ├── pubspec.yaml
│   └── android/
│
└── README.md                  # Este arquivo
```

---

## Tecnologias

| Camada | Stack |
|--------|--------|
| **API** | Java 21, Spring Boot 4, Spring Data JPA, PostgreSQL, Lombok, Maven |
| **App** | Flutter, Dart ^3.10, Provider, Dio |

---

## Pré-requisitos

- **Java 21** e **Maven** (para a API)
- **PostgreSQL** (banco com a tabela `governo` e dados de Bolsa Família)
- **Flutter SDK** e **Dart** (para o app)
- **Android Studio** ou **VS Code** + emulador/dispositivo Android

---

## Como executar

### 1. API (bolsafamilia)

1. Crie o banco no PostgreSQL e ajuste `bolsafamilia/src/main/resources/application.properties`:
   - `spring.datasource.url`, `username`, `password`
   - Opcional: `spring.jpa.hibernate.ddl-auto` (ex.: `validate` ou `update`)

2. Na pasta do projeto da API:
   ```bash
   cd bolsafamilia
   ./mvnw spring-boot:run
   ```
   A API sobe em **http://localhost:8080**.

### 2. App Flutter (bolsafamilia_app)

1. Configure a URL da API no app. Em `bolsafamilia_app/lib/services/api_services.dart` altere a variável `_url` para o endereço da sua API (ex.: `http://SEU_IP:8080/api/Bolsafamiliamodel/busca`). Em emulador Android, use o IP da máquina (ex.: `http://192.168.x.x:8080/...`) para acessar o localhost do PC.

2. Na pasta do app:
   ```bash
   cd bolsafamilia_app
   flutter pub get
   flutter run
   ```

---

## API – Endpoint de busca

- **GET** `/api/Bolsafamiliamodel/busca`

| Parâmetro      | Tipo   | Descrição                          |
|----------------|--------|------------------------------------|
| `nome`         | string | Nome do favorecido (like)          |
| `uf`           | string | Sigla da UF (ex.: SP)              |
| `nomeMunicipio`| string | Nome do município (like)           |
| `competencia`  | string | Competência (ex.: 202401)          |
| `nisFavorecido`| string | NIS do favorecido                  |
| `valorMinimo`  | number | Valor mínimo da parcela            |
| `valorMaximo`  | number | Valor máximo da parcela            |
| `pagina`       | int    | Página (default: 0)                |
| `tamanho`      | int    | Itens por página (default: 20)     |

Resposta: JSON com estrutura de **Page** (Spring): `content` (lista de beneficiários), `totalElements`, `totalPages`, etc.

---

## Modelo de dados (beneficiário)

Campos utilizados na API e no app:

- `id`, `competencia`, `uf`, `nomeMunicipio`, `nomeFavorecido`, `valorParcela`, `nisFavorecido`

A tabela no banco se chama **governo** (mapeada em `Bolsafamiliamodel`).

---

## Licença

Uso pessoal/educacional. Ajuste conforme sua necessidade.
