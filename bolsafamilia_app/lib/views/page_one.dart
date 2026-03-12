import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bolsa_provider.dart';
import '../models/buscas.dart';

class PageOne  extends StatefulWidget{
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
   final TextEditingController _textController = TextEditingController();
   final ScrollController _scrollController = ScrollController();

 GetBuscas _tipoBuscaSelecionado = GetBuscas.nomeFavorecido;

  @override
  Widget build(BuildContext context){
    final provider = context.watch<BolsaProvider>();

    return Scaffold(
      appBar: AppBar( title: Text("Consultas 😁")),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(flex: 2,
              child: DropdownButtonFormField<GetBuscas>(
                value: _tipoBuscaSelecionado,
                decoration: InputDecoration(
                  labelText: "Tipo de Busca",
                  border: OutlineInputBorder(),
                  ),
                  items: GetBuscas.values.map((tipo){
                    return DropdownMenuItem(value: tipo,
                    child:  Text(tipo.label),);
                  })
              ))
            ],
          ),)
        ],
      ),
    )
  }
}