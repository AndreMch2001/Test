# Projeto de consultas a banco de dados

Este projeto consiste em uma API RESTful robusta, desenvolvida para fornecer serviços de consulta de dados com alta performance e escalabilidade. O sistema utiliza uma arquitetura moderna e camadas bem definidas, garantindo facilidade na manutenção e integração com front-ends.

## 🛠 Tecnologias Utilizadas

* **Linguagem:** Java
* **Framework:** Spring Boot (Configuração simplificada, injeção de dependência, servidor embarcado)
* **Persistência:** Jakarta Persistence (JPA) com Hibernate
* **Abstração de Dados:** Spring Data JPA
* **Padrão Arquitetural:** REST

## 🗄️ Base de Dados e Infraestrutura

O projeto foi validado utilizando dados reais e volumosos, garantindo que a arquitetura suporte cenários de alta demanda.

- **Fonte de Dados:** Dados abertos do **Portal da Transparência do Governo Federal**, especificamente referentes ao **Novo Bolsa Família**.
- **Banco de Dados:** **PostgreSQL** (instância local de ~2GB).
- **Escalabilidade de Dados:** A aplicação foi projetada para processar grandes volumes de registros (Big Data) sem perda de performance, utilizando técnicas de paginação e critérios de busca otimizados.

## ⚙️ Flexibilidade e Reutilização

Embora o domínio atual seja focado no Bolsa Família, a arquitetura baseada em **Generics** e **Spring Data Specifications** permite que o sistema seja facilmente adaptado:

* **Multitemático:** O motor de busca dinâmico pode ser acoplado a qualquer outro banco de dados de dados abertos ou sistemas legados (Ex: Saúde, Educação, Segurança).
* **Portabilidade de Banco:** Graças ao uso do **Hibernate/JPA**, a migração para outros bancos de dados relacionais (MySQL, Oracle, SQL Server) exige o mínimo de alteração nas configurações.
* **Preparado para Nuvem:** A estrutura está pronta para ser escalada horizontalmente em ambientes cloud, conectando-se a instâncias de banco de dados gerenciadas (como AWS RDS ou Google Cloud SQL).

## 🏗 Arquitetura do Sistema

A aplicação foi estruturada em camadas para promover a separação de responsabilidades (Separation of Concerns):

1.  **Controller:** Gerencia os endpoints da API e a comunicação com o cliente.
2.  **Repository:** Camada de persistência e regras de negócio.
3.  **Entity:** Mapeamento de objetos (ORM) para o banco de dados relacional.

## 🚀 Principais Funcionalidades

### 1. API RESTful e Integração
* **Endpoints:** Implementação padrão REST. Exemplo: `GET /api/Bolsafamiliamodel/busca`.
* **CORS:** Suporte a requisições externas via `@CrossOrigin`, permitindo integração com front-ends como React, Angular e Vue.js.

### 2. Consultas Dinâmicas (Specifications)
Utilizamos a API de **Specifications** do Spring Data JPA para maior flexibilidade. Isso permite a construção dinâmica de cláusulas `WHERE` via `CriteriaBuilder`, evitando a criação de múltiplos métodos fixos no repositório.

**Filtros implementados:**
* Nome do favorecido (busca parcial)
* Unidade Federativa (UF)
* Município
* Competência
* NIS
* Intervalo de valor da parcela

### 3. Paginação
Implementação via `Page` e `PageRequest` para gerenciar grandes volumes de dados. A aplicação utiliza lógica de `LIMIT` e `OFFSET` para:
* Reduzir consumo de memória.
* Diminuir tempo de resposta (latência).
* Evitar sobrecarga no banco de dados.

## 💡 Por que escolhemos esta Stack?

A combinação **Spring Boot + JPA + Hibernate** foi escolhida pelos seguintes fatores:

* **Produtividade:** Configuração rápida e ambiente padronizado.
* **Escalabilidade:** Arquitetura pensada para expansão futura.
* **Manutenibilidade:** O uso de Specifications reduz drasticamente a complexidade do código de busca.
* **Mercado:** Tecnologias consolidadas com ampla documentação e comunidade ativa.

---
