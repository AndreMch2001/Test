import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bolsa_provider.dart';
import '../models/buscas.dart';

class PageOne  extends StatefulWidget{ //classe que representa a tela de busca
  const PageOne({super.key}); // construtor da classe desnecessário, mas é bom deixar para futuras extensões

  @override // poliformismo para criar o estado da tela
  _PageOneState createState() => _PageOneState(); // cria o estado da tela que será usado para controlar a tela
}

class _PageOneState extends State<PageOne> { // classe que representa o estado da tela de busca
   final TextEditingController _textController = TextEditingController(); // controlador de texto para o campo de busca
   final ScrollController _scrollController = ScrollController(); // controlador de scroll para a lista de resultados

 GetBuscas _tipoBuscaSelecionado = GetBuscas.nomeFavorecido; // variavel que controla o tipo de busca selecionado

  @override
  Widget build(BuildContext context){ // metodo que constrói a tela de busca
    final provider = context.watch<BolsaProvider>(); // contexto que observa o provider de busca para atualizar a tela

    return Scaffold( // tela de busca com appBar e body
      appBar: AppBar( title: const Text("Bolsa Familia 👀")), // appBar com titulo fixo
      body: Column( // body com coluna para organizar os elementos da tela
        children: [ // lista de elementos da tela
          Padding(padding: const EdgeInsets.all(8.0), //  padding para criar um espaçamento entre os elementos da tela
          child: Row( // linha para organizar os elementos da tela
            children: [ // lista de elementos da linha
              Expanded(flex: 2, // elemento que ocupa 2/3 da linha
              child: DropdownButtonFormField<GetBuscas>( // dropdown para selecionar o tipo de busca
                initialValue: _tipoBuscaSelecionado, // valor inicial do dropdown
                decoration: const InputDecoration( // decoração do dropdown
                  labelText: "Tipo de Busca", // label do dropdown que mostra o tipo de busca selecionado
                  border: OutlineInputBorder(), // borda do dropdown
                  ),
                  items: GetBuscas.values.map((tipo){ // lista de itens do dropdown
                    return DropdownMenuItem(value: tipo, // item do dropdown
                    child:  Text(tipo.label), // texto do item do dropdown
                    );
                  }).toList(), // lista de itens do dropdown
                  onChanged: (novoGetBusca){ // metodo que atualiza o tipo de busca selecionado
                    if (novoGetBusca != null){ // verifica se o novo tipo de busca é diferente de null
                      setState(() { // atualiza o tipo de busca selecionado
                        _tipoBuscaSelecionado = novoGetBusca; // atualiza o tipo de busca selecionado
                      });
                    }
                  },
              ),
              ),
              const SizedBox(width: 8), // espaçamento entre os elementos da linha
              Expanded( // é um widget que ocupa o espaço restante da linha
                flex: 3, // elemento que ocupa 3/3 da linha
                child: TextField( // campo de texto para digitar a busca
                  controller: _textController, // controlador de texto para o campo de busca
                  decoration: InputDecoration( // decoração do campo de texto
                    labelText: "Escreva aqui!", // label do campo de texto
                    suffixIcon: IconButton( // botão de busca
                      icon: const Icon(Icons.search), // ícone do botão de busca
                      onPressed: () => provider.novaBusca( // metodo que faz a busca
                        _textController.text, // texto do campo de busca
                        _tipoBuscaSelecionado, // tipo de busca selecionado
                        ),
                    ),
                    border: const OutlineInputBorder(), // borda do campo de texto
                  ),
                ),
              ),
            ],
          ),
          ),
          Expanded(child: ListView.builder( // lista de resultados
            controller: _scrollController, // controlador de scroll para a lista de resultados
            itemCount: provider.lista.length + (provider.isLoading ? 1:0), // quantidade de itens na lista
            itemBuilder: (context, index){ // metodo que constrói cada item da lista
              if(index < provider.lista.length){ // verifica se o índice é menor que a quantidade de itens na lista
                final item = provider.lista[index]; // item da lista
                return ListTile( // item da lista
                  leading: CircleAvatar(child: Text(item.uf ?? "")), // ícone do item da lista
                  title: Text(item.nomeFavorecido ?? ""), // titulo do item da lista
                  subtitle: Text( // subtitulo do item da lista
                    "${item.nomeMunicipio} - NIS: ${item.nisFavorecido}"), // texto do subtitulo do item da lista
                    trailing: Text("R\$ ${item.valorParcela}"), // texto do trailing do item da lista
                );
              } else{ // se o índice não for menor que a quantidade de itens na lista
                return const Center(child: CircularProgressIndicator()); // mostra um loading na tela
              }
            },
          ),
          ),
        ],
      ),
    );
  }
  @override // sobreescreve o metodo dispose para liberar o controlador de scroll
    void dispose(){ // metodo que libera o controlador de scroll
      _scrollController.dispose(); // libera o controlador de scroll
      super.dispose(); // libera o controlador de texto
    }
}