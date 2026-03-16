import 'package:intl/intl.dart';
import 'dart:io';

class Tarefa {

  static const CAMPO_ID = '_id';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_PRAZO = 'prazo';

  int id;
  String descricao;
  DateTime? prazo;
  File? imagem;

  Tarefa({
    required this.id,
    required this.descricao,
    this.prazo,
    this.imagem,
  });

  String get prazoFormatado {
    if (prazo == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(prazo!);
  }
}