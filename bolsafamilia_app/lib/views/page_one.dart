import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bolsa_provider.dart';

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Detetando o final do scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        // Se estiver a 200 pixels do fim, carrega mais
        context.read<BolsaProvider>().carregarMais();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BolsaProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Consulta Bolsa Família")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: "Nome do favorecido",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => provider.novaBusca(_textController.text),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Vincula o controller aqui
              itemCount: provider.lista.length + (provider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < provider.lista.length) {
                  final item = provider.lista[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(item.uf ?? "")),
                    title: Text(item.nomeFavorecido ?? ""),
                    subtitle: Text("${item.nomeMunicipio} - NIS: ${item.nisFavorecido}"),
                    trailing: Text("R\$ ${item.valorParcela}"),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}