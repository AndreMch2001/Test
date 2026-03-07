import 'package:dio/dio.dart';
import '../models/bolsafamilia_model.dart';

class ApiServices {
  final Dio _dio = Dio();
  // Lembre-se de usar o seu IP do ipconfig aqui
  final String _url = "http://192.168.1.9:8080/api/Bolsafamiliamodel/busca";

  Future<List<BolsaFamiliaModel>> getBeneficiarios({String nome = "", int pagina = 0}) async {
    try {
      final response = await _dio.get(_url, queryParameters: {
        "nome": nome,
        "pagina": pagina,
        "tamanho": 20, // Buscamos de 20 em 20
      });

      List dados = response.data['content'];
      return dados.map((json) => BolsaFamiliaModel.fromJson(json)).toList();
    } catch (e) {
      print("Erro na API: $e");
      return [];
    }
  }
}