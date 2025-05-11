


import '../database/database_provider.dart';
import '../model/lugar.dart';

class LugarDao{
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Lugar lugar) async{
    final db = await dbProvider.database;
    final valores = lugar.toMap();
    if (lugar.id == null){
      lugar.id = await db.insert(Lugar.nomeTabela, valores);
      return true;
    }else{
      final registrosAtualizados = await db.update(Lugar.nomeTabela, valores,
          where: '${Lugar.CAMPO_ID} = ?', whereArgs: [lugar.id]);
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover (int id) async{
    final db = await dbProvider.database;
    final registrosAtualizados = await db.delete(Lugar.nomeTabela,
        where:  '${Lugar.CAMPO_ID} = ?', whereArgs: [id]);
    return registrosAtualizados > 0;
  }

  Future<List<Lugar>> listar() async {
    final db = await dbProvider.database;
    final resultado = await db.query(
      Lugar.nomeTabela,
      columns: [
        Lugar.CAMPO_ID,
        Lugar.CAMPO_NOME,
        Lugar.CAMPO_DESCRICAO,
        Lugar.CAMPO_DATA_VISITA,
        Lugar.CAMPO_ATIVIDADES_REALIZADAS,
        Lugar.CAMPO_LOCALIZACAO,
      ],
    );
    return resultado.map((m) => Lugar.fromMap(m)).toList();
  }
}