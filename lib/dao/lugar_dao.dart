import 'package:gerenciador_tarefas_26/database/database_provider.dart';
import 'package:gerenciador_tarefas_26/model/lugar.dart';

class LugarDao{

  final dbProvider = DatabaseProvider.instance; // Instância única do banco

  Future<bool> salvar (Lugar lugar) async {
    final db = await dbProvider.database; // Obtém o banco de dados
    final valores = lugar.toMap(); // Converte o objeto Lugar para Map que seria as colunas do banco

    if(lugar.id == null){ // Se não tem ID -> ele registra um novo
      lugar.id = await db.insert(Lugar.NOME_TABELA, valores); // Insere no banco
      return true; // Retorna com sucesso
    }else{ // Se tem ID -> ele atualizar registro existente
      final registrosAtualizados = await db.update(
          Lugar.NOME_TABELA, valores, // traz a tabela e valor atualizado
          where: '${Lugar.CAMPO_ID} = ?', // Condição
          whereArgs: [lugar.id] // valor do ID
      );
      return registrosAtualizados > 0; // retorna verdadeiro se atualizou
    }
  }

  Future<bool> excluir (int id) async{
    final db = await dbProvider.database; // Obtém o banco

    final registrosAtualizados = await db.delete(
        Lugar.NOME_TABELA, // nome da tabela
        where: '${Lugar.CAMPO_ID} = ?', // Condição
        whereArgs: [id] // ID a ser excluído
    );

    return registrosAtualizados > 0; // Retorna verdadeiro se deletou
  }

  Future<List<Lugar>> listar ({
    String filtro = '', // Texto para filtro
    String campoOrdenacao = Lugar.CAMPO_ID, // Campo de ordenação
    bool usarOrdemDecrescente = false // Ordenação crescente ou decrescente
  }) async{

    String? where; // Variável para WHERE
    List<Object?>? whereArgs; // Argumentos do WHERE

    if(filtro.isNotEmpty){ // Se tiver filtro
      where = "UPPER(${Lugar.CAMPO_DESCRICAO}) LIKE ?"; // ele vai filtrar pela descrição
      whereArgs = ['${filtro.toUpperCase()}%']; // aqui faz uma busca com o que começa com texto
    }

    var orderBy = campoOrdenacao; // Define ordenação

    if(usarOrdemDecrescente){ // Se ordem decrescente
      orderBy += ' DESC'; // Adiciona DESC
    }

    final db = await dbProvider.database; // Obtém banco

    final resultado = await db.query(
        Lugar.NOME_TABELA, // Tabela
        columns: [ // as colunas que serão retornadas
          Lugar.CAMPO_ID,
          Lugar.CAMPO_DESCRICAO,
          Lugar.CAMPO_DETALHE,
          Lugar.CAMPO_PRAZO,
          Lugar.CAMPO_IMG
        ],
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy
    );

    return resultado
        .map((m) => Lugar.fromMap(m)) // Converte Map para objeto
        .toList(); // Retorna lista de objetos
  }

}