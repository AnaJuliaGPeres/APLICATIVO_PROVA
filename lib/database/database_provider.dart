import 'package:sqflite/sqflite.dart';
import 'package:trabalho_disiciplina/model/lugar.dart';


class DatabaseProvider {

  static const _dbNome = 'cadastro_lugar.db';
  static const _dbVersion = 2;

  DatabaseProvider._init();

  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async{
    if (_database == null){
      _database = await _initDataBase();
    }
    return _database!;
  }

  Future<Database> _initDataBase() async {
    String databasePath = await getDatabasesPath();
    String dbPath = '${databasePath}/${_dbNome}';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${Lugar.nomeTabela} (
      ${Lugar.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Lugar.CAMPO_NOME} TEXT NOT NULL,
      ${Lugar.CAMPO_DESCRICAO} TEXT,
      ${Lugar.CAMPO_DATA_VISITA} TEXT,
      ${Lugar.CAMPO_ATIVIDADES_REALIZADAS} TEXT,
      ${Lugar.CAMPO_LOCALIZACAO} TEXT,
      ${Lugar.CAMPO_LATITUDE} REAL,
      ${Lugar.CAMPO_LONGITUDE} REAL
    );
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE ${Lugar.nomeTabela} ADD COLUMN ${Lugar.CAMPO_DESCRICAO} TEXT;');
      await db.execute(
          'ALTER TABLE ${Lugar.nomeTabela} ADD COLUMN ${Lugar.CAMPO_ATIVIDADES_REALIZADAS} TEXT;');
    }
    if (oldVersion < 3) {
      await db.execute(
          'ALTER TABLE ${Lugar.nomeTabela} ADD COLUMN ${Lugar.CAMPO_LATITUDE} REAL;');
      await db.execute(
          'ALTER TABLE ${Lugar.nomeTabela} ADD COLUMN ${Lugar.CAMPO_LONGITUDE} REAL;');
    }
  }

  Future<void> close() async {
    if(_database != null){
      await _database!.close();
    }
  }
}

