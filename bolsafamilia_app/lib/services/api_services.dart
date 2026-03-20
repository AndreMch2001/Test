import 'package:bolsafamilia_app/models/buscas.dart';
import 'package:dio/dio.dart';
import '../models/bolsafamilia_model.dart';

class ApiServices {
  final Dio _dio = Dio();
 
  final String _url = "http://192.168.1.5:8080/api/Bolsafamiliamodel/busca"; // Pessoal! USEM A SUA IP LOCAL DO SEU COMPUTADOR PARA ACESSAR A API

  Future<List<BolsaFamiliaModel>> getBeneficiarios({ // Usado future para esperar a resposta da API
    String usuarioDigitado = "", // Nome do favorecido, município ou NIS
    GetBuscas busca = GetBuscas.nomeFavorecido, //Padrão é nome do favorecido
     int pagina = 0 // Padrão é a primeira página
     }) async { // Usado async poruqeu é uma função assíncrona
       try{ // Usado try para capturar erros
        final queryParameters = <String, dynamic>{ // Usado queryParameters para passar os parâmetros da busca
          "pagina": pagina, // Usado pagina para passar o número da página que defininimos por padão como 0
          "tamanho": 20, // Padrão é 20 resultados por página podemos aumentar ou diminuir conforme necessário
       };
       
       switch(busca){ // Usado switch para verificar a busca
        case GetBuscas.nomeFavorecido:
          queryParameters["nome"] = usuarioDigitado; // Usado nome para buscar por nome do favorecido
          break;
        case GetBuscas.nomeMunicipio:
          queryParameters["nomeMunicipio"] = usuarioDigitado; // Usado nomeMunicipio para buscar por município
          break;
        case GetBuscas.nisFavorecido:
          queryParameters["nisFavorecido"] = usuarioDigitado; // Usado nisFavorecido para buscar por NIS
          break;
       }

       final response = await _dio.get(_url, queryParameters: queryParameters); // Usado _dio.get para fazer a requisição GET
       
       List dados = response.data['content']; // Usado response.data['content'] para pegar os dados da resposta
       return dados.map((json) => BolsaFamiliaModel.fromJson(json)).toList(); // Usado map para converter os dados para o modelo BolsaFamiliaModel
       } catch(e){
        print("Erro na API: $e"); // Usado print para imprimir o erro
        return []; // Usado return para retornar a lista vazia caso ocorra um erro
       }
     }
     }