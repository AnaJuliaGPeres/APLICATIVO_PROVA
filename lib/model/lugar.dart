import 'package:intl/intl.dart';

class Lugar {
  static const CAMPO_ID = '_id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_ATIVIDADES_REALIZADAS = 'atividades_realizadas';
  static const CAMPO_LOCALIZACAO = 'localizacao';
  static const CAMPO_DATA_VISITA = 'dataVisita';
  static const nomeTabela = 'tarefa';

  int ? id;
  String nome;
  String descricao;
  DateTime? dataVisita;
  List<String> atividadesRealizadas;
  String? localizacao;

  // Remover o parâmetro 'atividades' desnecessário
  Lugar({
    required this.id,
    required this.nome,
    required this.descricao,
    this.dataVisita,
    required this.atividadesRealizadas,

    this.localizacao,
  });

  // Método para formatar a data de visita, caso exista.
  String get dataVisitaFormatada {
    if (dataVisita == null) {
      return 'Não visitado';
    }
    return DateFormat('dd/MM/yyyy').format(dataVisita!);
  }

  // Método para converter a lista de atividades em string
  String get atividadesFormatadas {
    return atividadesRealizadas.join(', ');
  }

  Map<String, dynamic> toMap() {
    return {
      CAMPO_ID: id,
      CAMPO_NOME: nome,
      CAMPO_DESCRICAO: descricao,
      CAMPO_DATA_VISITA: dataVisita?.toIso8601String(),
      CAMPO_ATIVIDADES_REALIZADAS: atividadesRealizadas.join(','),
      CAMPO_LOCALIZACAO: localizacao,
    };
  }

  factory Lugar.fromMap(Map<String, dynamic> map) {
    return Lugar(
      id: map[CAMPO_ID],
      nome: map[CAMPO_NOME],
      descricao: map[CAMPO_DESCRICAO],
      dataVisita: map[CAMPO_DATA_VISITA] != null
          ? DateTime.parse(map[CAMPO_DATA_VISITA])
          : null,
      atividadesRealizadas: (map[CAMPO_ATIVIDADES_REALIZADAS] as String)
          .split(',')
          .where((a) => a.isNotEmpty)
          .toList(),
      localizacao: map[CAMPO_LOCALIZACAO],
    );
  }
}
