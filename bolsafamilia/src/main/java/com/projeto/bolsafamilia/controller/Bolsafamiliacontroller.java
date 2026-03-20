package com.projeto.bolsafamilia.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification; // Importa a classe Specification do JPA para criar filtros na consulta
import org.springframework.web.bind.annotation.*; 

import com.projeto.bolsafamilia.model.Bolsafamiliamodel;
import com.projeto.bolsafamilia.repository.BolsafamiliaRepository;

import jakarta.persistence.criteria.Predicate; // Importa a classe Predicate do JPA para criar filtros na consulta
import java.util.ArrayList; // Importa a classe ArrayList do Java para criar uma lista de filtros
import java.util.List; // Importa a classe List do Java para criar uma lista de filtros
import java.math.BigDecimal; // Importa a classe BigDecimal do Java para criar filtros numéricos

@RestController // Anotação que indica que a classe é um controlador REST (receber e enviar requisições HTTP)
@RequestMapping("/api/Bolsafamiliamodel") // Anotação que define a rota base para as requisições que serão feitas na API
@CrossOrigin(origins = "*") // Anotação que permite que requisições de origens diferentes sejam feitas na API
public class Bolsafamiliacontroller { // Classe que contém os métodos para buscar os dados da API

    @Autowired // É uma anotação que indica que o Spring deve injetar uma instância da classe BolsafamiliaRepository dentro da classe Bolsafamiliacontroller automaticamente
    private BolsafamiliaRepository repository; // Variável que armazenará a instância da classe BolsafamiliaRepository

    @GetMapping("/busca") // Anotação que define o método HTTP GET para a rota /busca ou seja quando o usuário fizer uma requisição GET para a rota /busca, o método listar será executado
    public Page<Bolsafamiliamodel> listar( // Método que lista os dados da API responsavel por buscar os dados da API
            @RequestParam(required = false) String nome, // Parâmetro que recebe o nome do favorecido e é opcional
            @RequestParam(required = false) String uf, // Parâmetro que recebe a UF e é opcional
            @RequestParam(required = false) String nomeMunicipio, // Parâmetro que recebe o nome do município e é opcional
            @RequestParam(required = false) String competencia, // Parâmetro que recebe a competência e é opcional
            @RequestParam(required = false) String nisFavorecido, // Parâmetro que recebe o NIS do favorecido e é opcional
            @RequestParam(required = false) BigDecimal valorMinimo, // Parâmetro que recebe o valor mínimo da parcela e é opcional
            @RequestParam(required = false) BigDecimal valorMaximo, // Parâmetro que recebe o valor máximo da parcela e é opcional
            @RequestParam(defaultValue = "0") int pagina, // Parâmetro que recebe o número da página e é opcional
            @RequestParam(defaultValue = "20") int tamanho) { // Parâmetro que recebe o tamanho da página e é opcional
        
        Specification<Bolsafamiliamodel> spec = (root, query, cb) -> { // Specification é uma interface que define o filtro da consulta de forma flexivel e escalavel
            List<Predicate> predicates = new ArrayList<>(); // Lista que armazenará os filtros da consulta
            
            if (nome != null && !nome.isEmpty()) { // Se o nome não for nulo e não for vazio, adiciona o filtro na lista
                predicates.add(cb.like(cb.lower(root.get("nomeFavorecido")), "%" + nome.toLowerCase() + "%")); // Adiciona o filtro na lista ( traduz para SQL: LIKE '%nome%' ( case-insensitive ) )
            }
            
            if (uf != null && !uf.isEmpty()) { // Se a UF não for nula e não for vazia, adiciona o filtro na lista
                predicates.add(cb.equal(cb.upper(root.get("uf")), uf.toUpperCase())); // Adiciona o filtro na lista ( traduz para SQL: UPPER(uf) = 'UF' )
            }
            
            if (nomeMunicipio != null && !nomeMunicipio.isEmpty()) { // Se o nome do município não for nulo e não for vazio, adiciona o filtro na lista
                predicates.add(cb.like(cb.lower(root.get("nomeMunicipio")), "%" + nomeMunicipio.toLowerCase() + "%")); // Adiciona o filtro na lista ( traduz para SQL: LIKE '%nomeMunicipio%' ( case-insensitive ) )
            }
            
            if (competencia != null && !competencia.isEmpty()) { // Se a competência não for nula e não for vazia, adiciona o filtro na lista
                predicates.add(cb.equal(root.get("competencia"), competencia)); // Adiciona o filtro na lista ( traduz para SQL: competencia = 'COMPETENCIA' )
            }
            
            if (nisFavorecido != null && !nisFavorecido.isEmpty()) { // Se o NIS do favorecido não for nulo e não for vazio, adiciona o filtro na lista
                predicates.add(cb.equal(root.get("nisFavorecido"), nisFavorecido)); // Adiciona o filtro na lista ( traduz para SQL: nisFavorecido = 'NIS' )
            }
            
            if (valorMinimo != null) { // Se o valor mínimo da parcela não for nulo, adiciona o filtro na lista
                predicates.add(cb.greaterThanOrEqualTo(root.get("valorParcela"), valorMinimo)); // Adiciona o filtro na lista ( traduz para SQL: valorParcela >= valorMinimo )
            }
            
            if (valorMaximo != null) { // Se o valor máximo da parcela não for nulo, adiciona o filtro na lista
                predicates.add(cb.lessThanOrEqualTo(root.get("valorParcela"), valorMaximo)); // Adiciona o filtro na lista ( traduz para SQL: valorParcela <= valorMaximo )
            }
            
            return cb.and(predicates.toArray(new Predicate[0])); // Combina todos os filtros com AND
        };
        
        return repository.findAll(spec, PageRequest.of(pagina, tamanho)); // Adiciona todos os filtros obtidos acima e os parametros de pagina e tamanho e retorna a lista de dados da API
    }
}
