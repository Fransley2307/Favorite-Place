import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../model/tarefa.dart';

class ConteudoFormDialog extends StatefulWidget {
  final Tarefa? tarefaAtual;

  ConteudoFormDialog({Key? key, this.tarefaAtual}) : super(key: key);

  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {
  final formkey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final descricao = TextEditingController();
  final prazoController = TextEditingController();
  final prazoFormat = DateFormat('dd/MM/yyyy');

  File? imagemSelecionada;
  final ImagePicker picker = ImagePicker();

  @override
  @override
  void initState() {
    super.initState();

    if (widget.tarefaAtual != null) {
      descricaoController.text = widget.tarefaAtual!.descricao;
      descricao.text = widget.tarefaAtual!.descricao;
      prazoController.text = widget.tarefaAtual!.prazoFormatado;

      // carregar imagem da tarefa
      imagemSelecionada = widget.tarefaAtual!.imagem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextFormField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Informe a Descrição';
                }
                return null;
              },
            ),

            TextFormField(
              controller: prazoController,
              decoration: InputDecoration(
                labelText: 'Dia',
                prefixIcon: IconButton(
                    onPressed: _mostrarCalendario,
                    icon: const Icon(Icons.calendar_today)),
                suffixIcon: IconButton(
                    onPressed: () => prazoController.clear(),
                    icon: const Icon(Icons.close)),
              ),
              readOnly: true,
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: _selecionarImagem,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imagemSelecionada == null
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 40),
                      SizedBox(height: 5),
                      Text("Selecionar imagem"),
                    ],
                  ),
                )
                    : Image.file(
                  imagemSelecionada!,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 10),

            if (imagemSelecionada != null)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    imagemSelecionada = null;
                  });
                },
                icon: const Icon(Icons.delete),
                label: const Text("Remover imagem"),
              ),

            TextFormField(
              controller: descricao,
              decoration: const InputDecoration(labelText: 'Descrição do Local'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Informe a Descrição do Local';
                }
                return null;
              },
            ),

          ],
        ));
  }

  Future<void> _selecionarImagem() async {
    final XFile? imagem = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imagem != null) {
      setState(() {
        imagemSelecionada = File(imagem.path);
      });
    }
  }

  void _mostrarCalendario() {
    final dataFormatada = prazoController.text;
    var data = DateTime.now();

    if (dataFormatada.isNotEmpty) {
      data = prazoFormat.parse(dataFormatada);
    }

    showDatePicker(
      context: context,
      initialDate: data,
      firstDate: data.subtract(const Duration(days: 61)),
      lastDate: data.add(const Duration(days: 61)),
    ).then((DateTime? dataSelecionada) {
      if (dataSelecionada != null) {
        setState(() {
          prazoController.text = prazoFormat.format(dataSelecionada);
        });
      }
    });
  }

  bool dadosValidados() => formkey.currentState?.validate() == true;

  Tarefa get novaTarefa => Tarefa(
    id: widget.tarefaAtual?.id ?? 0,
    descricao: descricaoController.text,
    prazo: prazoController.text.isEmpty
        ? null
        : prazoFormat.parse(prazoController.text),
    imagem: imagemSelecionada,
  );
}