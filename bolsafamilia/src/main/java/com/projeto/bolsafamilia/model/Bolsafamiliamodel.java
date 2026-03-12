package com.projeto.bolsafamilia.model;

import java.math.BigDecimal;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "governo")
@Getter @Setter
public class Bolsafamiliamodel {

    @Id

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String competencia;
    private String uf;
    
    @Column(name = "nome_municipio")
    private String nomeMunicipio;
    
    @Column(name = "nome_favorecido")
    private String nomeFavorecido;
    
    @Column(name = "valor_parcela")
    private BigDecimal valorParcela;
    
    @Column(name = "nis_favorecido")
    private String nisFavorecido;
}