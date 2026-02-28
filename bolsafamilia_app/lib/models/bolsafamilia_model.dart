class BolsaFamiliaModel {
  final int? id;
  final String? competencia;
  final String? uf;
  final String? nomeMunicipio;
  final String? nomeFavorecido;
  final double? valorParcela;
  final String? nisFavorecido;

  BolsaFamiliaModel({
    this.id,
    this.competencia,
    this.uf,
    this.nomeMunicipio,
    this.nomeFavorecido,
    this.valorParcela,
    this.nisFavorecido,
  });

  // Converte o JSON do Java (Spring) para o Objeto Flutter
  factory BolsaFamiliaModel.fromJson(Map<String, dynamic> json) {
    return BolsaFamiliaModel(
      id: json['id'],
      competencia: json['competencia'],
      uf: json['uf'],
      nomeMunicipio: json['nomeMunicipio'],
      nomeFavorecido: json['nomeFavorecido'],
      valorParcela: json['valorParcela'] is int 
          ? (json['valorParcela'] as int).toDouble() 
          : json['valorParcela'],
      nisFavorecido: json['nisFavorecido'],
    );
  }
}