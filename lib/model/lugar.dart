import 'package:intl/intl.dart';

class Lugar {
  static const CAMPO_ID = '_id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_DESCRICAO = 'descricao';

  int id;
  String nome;
  String descricao;
  DateTime? dataVisita;

  Lugar({
    required this.id,
    required this.nome,
    required this.descricao,
    this.dataVisita,
  });

  // Método para formatar a data de visita, caso exista.
  String get dataVisitaFormatada {
    if (dataVisita == null) {
      return 'Não visitado';
    }
    return DateFormat('dd/MM/yyyy').format(dataVisita!);
  }
}
