package com.projeto.bolsafamilia.repository;
import com.projeto.bolsafamilia.model.Bolsafamiliamodel;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;


@Repository // Anotação que indica que a classe é um repositório JPA ou seja uma classe que contém os métodos para buscar os dados da API
public interface BolsafamiliaRepository extends JpaRepository<Bolsafamiliamodel, Long>, JpaSpecificationExecutor<Bolsafamiliamodel> { // Interface que extende a classe JpaRepository e a classe JpaSpecificationExecutor
}