package com.projeto.bolsafamilia.model;

import java.math.BigDecimal;

import jakarta.persistence.*; // Importa a classe Entity, Table, Column, Id, GeneratedValue e GenerationType do JPA para criar a tabela e as colunas da API
import lombok.Getter; // Importa a classe Getter do Lombok para gerar os getters da classe
import lombok.Setter; // Importa a classe Setter do Lombok para gerar os setters da classe

@Entity // Anotação que indica que a classe é uma entidade JPA ou seja uma tabela no banco de dados
@Table(name = "governo") // Anotação que indica que a classe é uma tabela no banco de dados
@Getter @Setter // Anotações que indicam que a classe é uma entidade JPA e que deve ser gerada os getters e setters da classe
public class Bolsafamiliamodel { // Classe que representa a tabela no banco de dados

    @Id // Anotação que indica que o campo id é a chave primária da tabela

    @GeneratedValue(strategy = GenerationType.IDENTITY) // Anotação que indica que o campo id é gerado automaticamente pelo banco de dados quando um novo registro é inserido
    private Long id; // Variável que armazenará o id do registro

    private String competencia; // Variável que armazenará a competência do registro
    private String uf; // Variável que armazenará a UF do registro  
    
    @Column(name = "nome_municipio") // Anotação que indica que o campo nomeMunicipio é uma coluna na tabela
    private String nomeMunicipio; // Variável que armazenará o nome do município do registro da tabela
    
    @Column(name = "nome_favorecido") // Anotação que indica que o campo nomeFavorecido é uma coluna na tabela
    private String nomeFavorecido; // Variável que armazenará o nome do favorecido do registro da tabela
    
    @Column(name = "valor_parcela") // Anotação que indica que o campo valorParcela é uma coluna na tabela
    private BigDecimal valorParcela; // Variável que armazenará o valor da parcela do registro da tabela
    
    @Column(name = "nis_favorecido") // Anotação que indica que o campo nisFavorecido é uma coluna na tabela
    private String nisFavorecido; // Variável que armazenará o NIS do favorecido do registro da tabela    
}