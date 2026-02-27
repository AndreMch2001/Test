package com.projeto.bolsafamilia.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.web.bind.annotation.*;

import com.projeto.bolsafamilia.model.Bolsafamiliamodel;
import com.projeto.bolsafamilia.repository.BolsafamiliaRepository;

import jakarta.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

@RestController
@RequestMapping("/api/Bolsafamiliamodel")
@CrossOrigin(origins = "*")
public class Bolsafamiliacontroller {

    @Autowired
    private BolsafamiliaRepository repository;

    @GetMapping("/busca")
    public Page<Bolsafamiliamodel> listar(
            @RequestParam(required = false) String nome,
            @RequestParam(required = false) String uf,
            @RequestParam(required = false) String nomeMunicipio,
            @RequestParam(required = false) String competencia,
            @RequestParam(required = false) String nisFavorecido,
            @RequestParam(required = false) BigDecimal valorMinimo,
            @RequestParam(required = false) BigDecimal valorMaximo,
            @RequestParam(defaultValue = "0") int pagina,
            @RequestParam(defaultValue = "20") int tamanho) {
        
        Specification<Bolsafamiliamodel> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            
            if (nome != null && !nome.isEmpty()) {
                predicates.add(cb.like(cb.lower(root.get("nomeFavorecido")), "%" + nome.toLowerCase() + "%"));
            }
            
            if (uf != null && !uf.isEmpty()) {
                predicates.add(cb.equal(cb.upper(root.get("uf")), uf.toUpperCase()));
            }
            
            if (nomeMunicipio != null && !nomeMunicipio.isEmpty()) {
                predicates.add(cb.like(cb.lower(root.get("nomeMunicipio")), "%" + nomeMunicipio.toLowerCase() + "%"));
            }
            
            if (competencia != null && !competencia.isEmpty()) {
                predicates.add(cb.equal(root.get("competencia"), competencia));
            }
            
            if (nisFavorecido != null && !nisFavorecido.isEmpty()) {
                predicates.add(cb.equal(root.get("nisFavorecido"), nisFavorecido));
            }
            
            if (valorMinimo != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("valorParcela"), valorMinimo));
            }
            
            if (valorMaximo != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("valorParcela"), valorMaximo));
            }
            
            return cb.and(predicates.toArray(new Predicate[0]));
        };
        
        return repository.findAll(spec, PageRequest.of(pagina, tamanho));
    }
}
