import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_26/dao/lugar_dao.dart';
import 'package:gerenciador_tarefas_26/model/lugar.dart';
import 'package:gerenciador_tarefas_26/pages/filtro_pages.dart';
import 'package:gerenciador_tarefas_26/widgets/conteudo_form_dialog.dart';

class ListaLugaresPage extends StatefulWidget {
  @override
  _ListaLugaresPageState createState() => _ListaLugaresPageState();
}

class _ListaLugaresPageState extends State<ListaLugaresPage> {

  static const ACAO_EDITAR = 'Editar';
  static const ACAO_DELETAR = 'Deletar';
  static const ACAO_VISUALIZAR = 'Visualizar';

  final _dao = LugarDao();
  final _lugares = <Lugar>[]; // que seria meu lugar favorito

  @override
  void initState() {
    super.initState();
    _carregarLugares();
  }

  Future<void> _carregarLugares() async {
    try {
      final lugares = await _dao.listar();
      if (!mounted) return;
      setState(() {
        _lugares
          ..clear()
          ..addAll(lugares);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _lugares.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton( // seria o botão de adicionar
        onPressed: _abrirForm, // vai abrir o formulario
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
// aqui aparece a msj na tela se não tiver nem um local encontrado
  Widget _criarBody(){
    if(_lugares.isEmpty){
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
      itemCount: _lugares.length,
      itemBuilder: (BuildContext context, int index){
        final lugares = _lugares[index];

        return PopupMenuButton<String>(
          child: ListTile(
            title: Text('${lugares.id ?? ''} - ${lugares.descricao}'),
            subtitle: Text(
                lugares.prazo != null ? 'Dia: ${lugares.prazoFormatado}' : ''
            ),
          ),
          itemBuilder: (BuildContext context) => criarItemMenuPopUp(),
          onSelected: (String valorSelecionado) {

            if (valorSelecionado == ACAO_EDITAR) {
              _abrirForm(lugarAtual: lugares, indice: index);

            } else if (valorSelecionado == ACAO_DELETAR) {
              _excluir(lugares);

            } else if (valorSelecionado == ACAO_VISUALIZAR) {
              _visualizarLugar(lugares);
            }

          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(), // aqui separa os itens por linha
    );
  }

  List<PopupMenuEntry<String>> criarItemMenuPopUp(){
    return [
      const PopupMenuItem<String>( // aqui seria o botão para editar os lugares
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

      const PopupMenuItem<String>( // botão para visualizar
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

      const PopupMenuItem<String>( // botão excluir
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

  void _excluir(Lugar lugar){
    showDialog( // vai aparecer um alerta para confirmar se deseja excluir mesmo
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
                    _excluirNoBanco(lugar);
                  },
                  child: const Text('Ok')
              )
            ],
          );
        }
    );
  }

  Future<void> _excluirNoBanco(Lugar lugar) async {
    final id = lugar.id;
    if (id == null) return;
    await _dao.excluir(id);
    await _carregarLugares();
  }

  void _visualizarLugar(Lugar lugares) {
    showDialog( // mostra o detalhe do lugar favorito
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Visualizar Lugar Favorito"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (lugares.imagem != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(lugares.imagem!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 10),
                Text("Descrição: ${lugares.descricao}"),
                if ((lugares.detalhe ?? '').trim().isNotEmpty)
                  Text("Descrição do Local: ${lugares.detalhe}"),
                if (lugares.prazo != null)
                  Text("Prazo: ${lugares.prazoFormatado}")
              ],
            ),
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

  void _abrirForm({Lugar? lugarAtual, int? indice}){
    final key = GlobalKey<ConteudoFormDialogState>();

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(
                lugarAtual == null
                    ? 'Novo Lugar Favorito'
                    : 'Alterar o local: ${lugarAtual.id ?? ''}'
            ),
            content: ConteudoFormDialog(
                key: key,
                lugarAtual: lugarAtual
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')
              ),
              TextButton(
                child: const Text('Salvar'),
                onPressed: () async {
                  if (key.currentState == null || !key.currentState!.dadosValidados()) {
                    return;
                  }

                  final novoLugar = key.currentState!.novoLugar;
                  await _dao.salvar(novoLugar);

                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                  await _carregarLugares();
                },
              )
            ],
          );
        }
    );
  }
}
