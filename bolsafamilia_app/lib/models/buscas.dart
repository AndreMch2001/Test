enum GetBuscas { // Um conjunto fixo de "opções de tipo de busca", facilmente escalavel e seguro
nomeFavorecido, // temos por enquanto três opçoes de busca que serão usados para fazer um GET na Api
nomeMunicipio, // por exemplo aqui buscamos pelo nome do municipio, a varialvel está declarada igual a coluna do banco
nisFavorecido, // se quisermos colocar mais buscas, basta adicionar a variavel aqui e depois criar o metodo abaixo na extencion
}

extension ExtencaoBuscas on GetBuscas { // uma extençõo do enum acima, tudo para grantir que a entrada de dados seja consistente e escalavel
String get label{ // aqui é um getter que vai retornar uma String do tipo de busca solicitado
  switch(this){ // por enquanto vou usar o switch para fazer requisições, se torna um pouco mais facil de inicio
    case GetBuscas.nomeFavorecido:
      return "Nome";
    case GetBuscas.nomeMunicipio: // aqui temos os casos, com retorno correspondente
      return "Município";
    case GetBuscas.nisFavorecido:
      return "NIS";
  }
}
}