import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_26/model/tarefa.dart';
import 'package:gerenciador_tarefas_26/pages/filtro_pages.dart';
import 'package:gerenciador_tarefas_26/widgets/conteudo_form_dialog.dart';

class ListaTarefasPage extends StatefulWidget {
  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {

  static const ACAO_EDITAR = 'Editar';
  static const ACAO_DELETAR = 'Deletar';
  static const ACAO_VISUALIZAR = 'Visualizar';

  final _tarefas = <Tarefa>[];

  var ultimoId = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Novo Lugar Favorito',
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  AppBar _criarAppBar(){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      centerTitle: true,
      title: const Text('Favorite Place'),
      actions: [
        IconButton(
          onPressed: _abrirFiltro,
          icon: const Icon(Icons.list),
        )
      ],
    );
  }

  Widget _criarBody(){
    if(_tarefas.isEmpty){
      return const Center(
        child: Text(
          'Nenhum Lugar Favorito Encontrado!!!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _tarefas.length,
      itemBuilder: (BuildContext context, int index){
        final tarefa = _tarefas[index];

        return PopupMenuButton<String>(
          child: ListTile(
            title: Text('${tarefa.id} - ${tarefa.descricao}'),
            subtitle: Text(
                tarefa.prazo != null ? 'Dia: ${tarefa.prazoFormatado}' : ''
            ),
          ),
          itemBuilder: (BuildContext context) => criarItemMenuPopUp(),
          onSelected: (String valorSelecionado) {

            if (valorSelecionado == ACAO_EDITAR) {
              _abrirForm(tarefaAtual: tarefa, indice: index);

            } else if (valorSelecionado == ACAO_DELETAR) {
              _excluir(index);

            } else if (valorSelecionado == ACAO_VISUALIZAR) {
              _visualizarTarefa(tarefa);
            }

          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  List<PopupMenuEntry<String>> criarItemMenuPopUp(){
    return [
      const PopupMenuItem<String>(
          value: ACAO_EDITAR,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.black),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Editar'),
              )
            ],
          )
      ),

      const PopupMenuItem<String>(
          value: ACAO_VISUALIZAR,
          child: Row(
              children: [
                Icon(Icons.visibility, color: Colors.yellow),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Visualizar'),
                )
              ]
          )
      ),

      const PopupMenuItem<String>(
          value: ACAO_DELETAR,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Excluir'),
              )
            ],
          )
      )


    ];
  }

  void _excluir(int index){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning, color: Colors.amber),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Atenção'),
                )
              ],
            ),
            content: const Text('Esse registro será removido definitivamente!!!'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _tarefas.removeAt(index);
                    });
                  },
                  child: const Text('Ok')
              )
            ],
          );
        }
    );
  }

  void _visualizarTarefa(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Visualizar Lugar Favorito"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // MOSTRAR IMAGEM
              if (tarefa.imagem != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    tarefa.imagem!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 10),

              Text("Descrição: ${tarefa.descricao}"),

              if (tarefa.prazo != null)
                Text("Prazo: ${tarefa.prazoFormatado}")
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar"),
            )
          ],
        );
      },
    );
  }

  void _abrirFiltro(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValores){
      if (alterouValores == true){
      }
    });
  }

  void _abrirForm({Tarefa? tarefaAtual, int? indice}){
    final key = GlobalKey<ConteudoFormDialogState>();

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(
                tarefaAtual == null
                    ? 'Novo Lugar Favorito'
                    : 'Alterar o local: ${tarefaAtual.id}'
            ),
            content: ConteudoFormDialog(
                key: key,
                tarefaAtual: tarefaAtual
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')
              ),
              TextButton(
                child: const Text('Salvar'),
                onPressed: (){
                  if (key.currentState != null && key.currentState!.dadosValidados()){
                    setState(() {
                      final novaTarefa = key.currentState!.novaTarefa;

                      if (indice == null){
                        novaTarefa.id = ++ultimoId;
                        _tarefas.add(novaTarefa);
                      } else {
                        _tarefas[indice] = novaTarefa;
                      }
                    });

                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        }
    );
  }
}