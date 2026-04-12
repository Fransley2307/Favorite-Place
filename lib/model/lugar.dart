
import 'package:intl/intl.dart';

class Lugar{
  static const NOME_TABELA = 'tarefas';
  static const CAMPO_ID = '_id';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_DETALHE = 'detalhe';
  static const CAMPO_PRAZO = 'prazo';
  static const CAMPO_IMG = 'imagem';

  int? id;
  String descricao;
  String? detalhe;
  DateTime? prazo;
  String? imagem;

  Lugar({this.id, required this.descricao, this.detalhe, this.prazo, this.imagem });

  String get prazoFormatado{
    if ( prazo == null){
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(prazo!);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    CAMPO_ID: id,
    CAMPO_DESCRICAO: descricao,
    CAMPO_DETALHE: detalhe,
    CAMPO_PRAZO: prazo == null ? null : DateFormat("yyyy-MM-dd").format(prazo!),
    CAMPO_IMG: imagem,
  };

  factory Lugar.fromMap(Map<String, dynamic> map) => Lugar(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
    detalhe: map[CAMPO_DETALHE] is String ? map[CAMPO_DETALHE] : null,
    prazo: map[CAMPO_PRAZO] == null ? null :
    DateFormat("yyyy-MM-dd").parse(map[CAMPO_PRAZO]),
    imagem: map[CAMPO_IMG],
  );

}
