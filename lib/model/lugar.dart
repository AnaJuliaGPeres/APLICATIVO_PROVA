import 'package:intl/intl.dart';

class Lugar {
  static const CAMPO_ID = '_id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_ATIVIDADES_REALIZADAS = 'atividades_realizadas';
  static const CAMPO_COMPANHIA = 'companhia';
  static const CAMPO_RECOMENDACAO = 'recomendacao';
  static const CAMPO_LOCALIZACAO = 'localizacao';

  int id;
  String nome;
  String descricao;
  DateTime? dataVisita;
  List<String> atividadesRealizadas;
  String? companhia;
  String? recomendacao;
  String? localizacao;

  // Remover o parâmetro 'atividades' desnecessário
  Lugar({
    required this.id,
    required this.nome,
    required this.descricao,
    this.dataVisita,
    required this.atividadesRealizadas,
    this.companhia,
    this.recomendacao,
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
}
