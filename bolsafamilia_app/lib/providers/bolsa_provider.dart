import 'package:flutter/material.dart';
import '../models/bolsafamilia_model.dart';
import '../services/api_services.dart';

class BolsaProvider with ChangeNotifier {
  final ApiServices _service = ApiServices();
  
  List<BolsaFamiliaModel> lista = [];
  bool isLoading = false;
  int paginaAtual = 0;
  String termoBuscaAtual = "";

  // Nova busca (limpa a lista e começa do zero)
  Future<void> novaBusca(String nome) async {
    termoBuscaAtual = nome;
    paginaAtual = 0;
    lista = [];
    isLoading = true;
    notifyListeners();

    lista = await _service.getBeneficiarios(nome: nome, pagina: paginaAtual);
    
    isLoading = false;
    notifyListeners();
  }

  // Carregar próxima página (adiciona ao fim da lista)
  Future<void> carregarMais() async {
    if (isLoading) return; // Evita chamadas duplicadas

    paginaAtual++;
    isLoading = true;
    notifyListeners();

    final novosDados = await _service.getBeneficiarios(
      nome: termoBuscaAtual, 
      pagina: paginaAtual
    );

    lista.addAll(novosDados); // Adiciona os novos itens à lista existente
    
    isLoading = false;
    notifyListeners();
  }
}