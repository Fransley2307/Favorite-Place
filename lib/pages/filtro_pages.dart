
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_26/model/lugar.dart';

class FiltroPage extends StatefulWidget{
  static const ROUTE_NAME = '/filtro';
  static const CHAVE_CAMPO_ORDENACAO = 'campoOrdenacao';
  static const USAR_ORDEM_DECRESCENTE = 'usarOrdemDecrescente';
  static const CHAVE_FILTRO_DESCRICAO = 'filtroDescricao';

  @override
  _FiltroPageState createState() => _FiltroPageState();

}

class _FiltroPageState extends State<FiltroPage>{

  final _camposParaOrdenacao = {
    Lugar.CAMPO_ID: 'Código',
    Lugar.CAMPO_DESCRICAO: 'Descrição',
    Lugar.CAMPO_PRAZO: 'Dia'
  };

  final descricaoController = TextEditingController();
  String campoOrdenacao = Lugar.CAMPO_ID;
  bool usarOrdemDecrescente = false;
  bool alterouValores = false;

  @override
  Widget build ( BuildContext context){
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text('Filtro e Ordenação'),),
        body: _criarBody(),
      ),
      onWillPop: null,
    );
  }

  Widget _criarBody(){
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Text('Campos para ordenação'),
        ),
        for (final campo in _camposParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                value: campo,
                groupValue: _camposParaOrdenacao,
                onChanged: null,
              ),
              Text(_camposParaOrdenacao[campo] ?? ''),
            ],
          ),
        const Divider(),
        Row(
          children: [
            Checkbox(
              value: usarOrdemDecrescente,
              onChanged: null,
            ),
            const Text('Usar ordem decrescente')
          ],
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: const InputDecoration(labelText: 'Descrição começa com:'),
            controller: descricaoController,
            onChanged: null,
          ),
        )
      ],
    );
  }
}