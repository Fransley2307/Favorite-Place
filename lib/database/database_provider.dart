import 'package:gerenciador_tarefas_26/model/lugar.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const _dbName = 'cadastro_lugar.db';
  static const _dbVersion = 4;

  DatabaseProvider.int(); //Construto

  static final DatabaseProvider instance = DatabaseProvider.int();

  Database? _database; // Variável que guarda obanco

  Future<Database> get database async {
    _database ??= await _initDatabase();
    // Caso o banco não exista ele inicializa o banco.
    return _database!; // Retorna o banco
  }

  Future<Database> _initDatabase() async{
    String databasePath = await getDatabasesPath();
    // Pega o caminho padrão onde o banco será salvo

    String dbPath = '$databasePath/$_dbName';
    // Monta o caminho com o nome do banco de dados

    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await db.execute(_createTableSql);
        // Garante que a tabela existe sempre que abrir
      },
    );
  }

  Future<void>_onCreate(Database db, int version) async{
    await db.execute(_createTableSql);
    // Cria as tabelas quando o banco for criado
  }

  // Se a versão antiga for menor que 2, adiciona coluna imagem
  Future<void>_onUpgrade(Database db, int oldVersion, int newVersion) async{

    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE ${Lugar.NOME_TABELA} ADD COLUMN ${Lugar.CAMPO_IMG} TEXT',
      );
    }

    // Se a versão do banco for menos que 4 ele adiciona o campo detalhe
    if (oldVersion < 4) {
      await db.execute(
        'ALTER TABLE ${Lugar.NOME_TABELA} ADD COLUMN ${Lugar.CAMPO_DETALHE} TEXT',
      );
    }
  }

  // Finaliza o banco se ele estiver aberto
  Future<void> close() async{
    if(_database != null){
      await _database!.close();

    }
  }
}

// SQL para criação da tabela
const _createTableSql = '''
CREATE TABLE IF NOT EXISTS ${Lugar.NOME_TABELA} (
  ${Lugar.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT, 
  ${Lugar.CAMPO_DESCRICAO} TEXT NOT NULL, 
  ${Lugar.CAMPO_DETALHE} TEXT, 
  ${Lugar.CAMPO_PRAZO} TEXT, 
  ${Lugar.CAMPO_IMG} TEXT 
)
''';