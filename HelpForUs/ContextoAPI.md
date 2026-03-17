# Contexto da API Java – Bolsa Família

Documento de referência para análise futura do código da API REST em Spring Boot.

---

## 1. Visão geral do projeto

- **Nome:** bolsafamilia  
- **Tipo:** API REST Spring Boot  
- **Java:** 21  
- **Spring Boot:** 4.0.3  
- **Build:** Maven  
- **Banco:** PostgreSQL (driver JDBC)  
- **Pacote base:** `com.projeto.bolsafamilia`

---

## 2. Estrutura de arquivos Java

```
bolsafamilia/
├── pom.xml
├── src/main/
│   ├── java/com/projeto/bolsafamilia/
│   │   ├── BolsafamiliaApplication.java      # Entry point
│   │   ├── controller/
│   │   │   └── Bolsafamiliacontroller.java   # REST endpoints
│   │   ├── model/
│   │   │   └── Bolsafamiliamodel.java        # Entidade JPA
│   │   └── repository/
│   │       └── BolsafamiliaRepository.java   # Acesso a dados
│   └── resources/
│       └── application.properties
└── src/test/java/.../
    └── BolsafamiliaApplicationTests.java     # Teste de contexto
```

---

## 3. Dependências principais (pom.xml)

- **spring-boot-starter-actuator** – monitoramento/saúde  
- **spring-boot-starter-data-jpa** – JPA/Hibernate  
- **spring-boot-starter-webmvc** – REST/HTTP  
- **postgresql** – driver JDBC (runtime)  
- **lombok** – getters/setters e redução de boilerplate  
- **spring-boot-starter-data-jpa-test** e **spring-boot-starter-webmvc-test** – testes  

---

## 4. Configuração (application.properties)

- **App:** `spring.application.name=bolsafamilia`  
- **Datasource:** URL, usuário e senha definidos em `application.properties` (JDBC PostgreSQL).  
- **JPA:**  
  - `spring.jpa.hibernate.ddl-auto=validate` (não altera schema).  
  - `spring.jpa.show-sql=true` e `hibernate.format_sql=true` para SQL formatado no log.  

---

## 5. Entidade de domínio – Bolsafamiliamodel

- **Tabela:** `governo`  
- **Campos:**

| Campo Java       | Coluna DB        | Tipo        |
|------------------|------------------|-------------|
| id               | (PK, identity)   | Long        |
| competencia      | competencia      | String      |
| uf               | uf               | String      |
| nomeMunicipio    | nome_municipio   | String      |
| nomeFavorecido   | nome_favorecido  | String      |
| valorParcela     | valor_parcela    | BigDecimal  |
| nisFavorecido    | nis_favorecido   | String      |

- **Anotações:** `@Entity`, `@Table(name = "governo")`, `@Getter`/`@Setter` (Lombok), `@Id`/`@GeneratedValue(strategy = GenerationType.IDENTITY)` em `id`.

---

## 6. Repository – BolsafamiliaRepository

- **Interface:** estende `JpaRepository<Bolsafamiliamodel, Long>` e `JpaSpecificationExecutor<Bolsafamiliamodel>`.  
- **Métodos derivados (além dos do JpaRepository):**
  - `Page<Bolsafamiliamodel> findByNomeFavorecidoContainingIgnoreCase(String nome, Pageable pageable)`  
  - `Page<Bolsafamiliamodel> findByNomeMunicipioIgnoreCase(String municipio, Pageable pageable)`  

Uso principal: `findAll(Specification<Bolsafamiliamodel>, Pageable)` no controller, com filtros dinâmicos.

---

## 7. Controller – Bolsafamiliacontroller

- **Rota base:** `GET /api/Bolsafamiliamodel`  
- **CORS:** `@CrossOrigin(origins = "*")`  
- **Injeção:** `@Autowired BolsafamiliaRepository repository`  

### Endpoint único

- **Método e path:** `GET /api/Bolsafamiliamodel/busca`  
- **Retorno:** `Page<Bolsafamiliamodel>` (JSON com conteúdo + metadados de paginação).  

### Parâmetros de query (todos opcionais)

| Parâmetro     | Tipo       | Uso no filtro                                      |
|---------------|------------|----------------------------------------------------|
| nome          | String     | LIKE em `nomeFavorecido` (case-insensitive)        |
| uf            | String     | Igualdade em `uf` (case-insensitive)               |
| nomeMunicipio | String     | LIKE em `nomeMunicipio` (case-insensitive)         |
| competencia   | String     | Igualdade em `competencia`                         |
| nisFavorecido | String     | Igualdade em `nisFavorecido`                       |
| valorMinimo   | BigDecimal | `valorParcela >= valorMinimo`                     |
| valorMaximo   | BigDecimal | `valorParcela <= valorMaximo`                     |
| pagina        | int        | Número da página (default: 0)                      |
| tamanho       | int        | Tamanho da página (default: 20)                    |

### Lógica de filtro

- Usa `Specification<Bolsafamiliamodel>`: para cada parâmetro não nulo/não vazio é adicionado um `Predicate` (criteria).  
- Predicates são combinados com `AND`.  
- Chamada final: `repository.findAll(spec, PageRequest.of(pagina, tamanho))`.

---

## 8. Application e testes

- **BolsafamiliaApplication:** classe com `@SpringBootApplication` e `main` que executa `SpringApplication.run(BolsafamiliaApplication.class, args)`.  
- **BolsafamiliaApplicationTests:** `@SpringBootTest`, um `@Test void contextLoads()` para validar carga do contexto Spring.

---

## 9. Resumo para análise futura

- API REST em Spring Boot 4, Java 21, Maven.  
- Uma entidade: `Bolsafamiliamodel` (tabela `governo`).  
- Um endpoint de leitura: `GET /api/Bolsafamiliamodel/busca` com filtros opcionais e paginação.  
- Persistência via JPA (PostgreSQL), Repository com `JpaRepository` + `JpaSpecificationExecutor`.  
- Configuração de banco e JPA em `application.properties`; credenciais não devem ser versionadas em produção.

*Documento gerado para guardar o contexto do código Java da API e facilitar análises futuras.*
