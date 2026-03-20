import 'package:bolsafamilia_app/models/buscas.dart';
import 'package:flutter/material.dart';
import '../models/bolsafamilia_model.dart';
import '../services/api_services.dart';

class BolsaProvider with ChangeNotifier { // classe utilizando notifiers para "avisar" quando algo mudar na tela, para poder ser recontruida
  final ApiServices _service = ApiServices(); // aqui estamos chamando a api usando um _ para indicar que é uma instancia privada da classe
  
  List<BolsaFamiliaModel> lista = []; // inicia uma lista de respostas da Api vazia inicial
  bool isLoading = false; // criei esse booleano para funcionar como um carregamento da api, para poder dizer quando estamso carregando dados e quando ja os temos
  int paginaAtual = 0; // todas as chamadas são padronizadas para iniciar na primeira pagina 
  String usuarioBuscaAtual = ""; // declara a instancia da variavel
  GetBuscas tipoBuscaAtual = GetBuscas.nomeFavorecido; // GetBuscas do enum nome que criamos em buscas.dart, assim a pesquisa padão sempre sera o nome

  Future<void> novaBusca(String usuarioDigitado, GetBuscas tipoBusca) async { // Metodo assíncrono para fazer nova busca, o que será chamado quando apertar algum botão
    usuarioBuscaAtual = usuarioDigitado; // aqui fazemos a captura do que foi digitado pelo usuario
    tipoBuscaAtual = tipoBusca; // aqui é o qua vai ser buscado na Api, qualo o tipo nome, municipio ou nis
    paginaAtual = 0; // caso tivero outra pesquisa anterios retaornamos para rpimeira pagina por padrão
    lista = []; // igualmente se tiver pesquisa limpa os dados
    isLoading = true; // aqui estou utilizando como uma forma de toda vez que for true vai aparecer uma loading na tela do usuario pra indicar que estamos buscando dados
    notifyListeners(); // esse metodo é do ChangeNotifier que sempre quando chamado recontroi toda a tela do usuario para aplicar mudanças

    lista = await _service.getBeneficiarios( // metodo assíncrono que chama Api e faz a requisição atraves do Getbenificiario que é um metodo do api_service.dart
      usuarioDigitado: usuarioBuscaAtual, // vai setar o que foi digitado pelo usuario
      busca: tipoBuscaAtual, // vai setar o tipo de busca declaradas lá no buscas.dart
      pagina: paginaAtual, // vai setar a pagiana, nesse caso a primeira
    );

    isLoading = false; // quando sair do metodo vai adicionar um false no nosso "carregamento" assim desaparecendo o icone de carregamento da tela
    notifyListeners(); // reconstroi toda a tela para adiconar a informação que pegamos do novaBusca()
  }

  Future<void> carregarMais() async{ // novamente um metodo assíncrono para carregar as demais informações obtidas anteriormente
    if (isLoading) return; // aqui um "machetizinho" para evitar chamar essa função varias vezes, se for true o nosso "carregamento" então saia do metodo

    paginaAtual++; // quando chamado vai pegar a pagina atual e acrecentar masi um para mudar a pagina da Api
    isLoading = true; // indica que precisa mostrar o carregamento na tela do usuario
    notifyListeners(); // reconstri a tela mostrando o carregamento

    final novosDados = await _service.getBeneficiarios( // aguarda a proxima pagina da Api carregar para retornar mais itens
      usuarioDigitado: usuarioBuscaAtual,  // vai setar o que foi digitado pelo usuario antertiormente, continua igual
      busca: tipoBuscaAtual, // vai setar o tipo de busca declaradas lá no buscas.dart, mas é o mesmo setado anteriormente
      pagina: paginaAtual, // vai setar a pagiana, nesse caso a proxima pagina se antes era 0 agora é 1
    );

    lista.addAll(novosDados); // aqui vai adicionar tudo de dados que foi recebido no carregarMais a lista
    isLoading = false; // termina o carregamento para esconder o CircularProgressIndicator
    notifyListeners(); // notifica a tela para reconstruir tudo e mostrar os novos dados
  }
}