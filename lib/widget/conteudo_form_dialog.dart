import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/lugar.dart';

class ConteudoFormDialog extends StatefulWidget {
  final Lugar? lugarAtual;

  const ConteudoFormDialog({Key? key, this.lugarAtual}) : super(key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final dataVisitaController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.lugarAtual != null) {
      nomeController.text = widget.lugarAtual!.nome;
      descricaoController.text = widget.lugarAtual!.descricao;
      dataVisitaController.text = widget.lugarAtual!.dataVisitaFormatada;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nomeController,
            decoration: const InputDecoration(labelText: 'Nome do Lugar'),
            validator: (String? valor) {
              if (valor == null || valor.isEmpty) {
                return 'O campo nome é obrigatório';
              }
              return null;
            },
          ),
          TextFormField(
            controller: descricaoController,
            decoration: const InputDecoration(labelText: 'Descrição'),
            validator: (String? valor) {
              if (valor == null || valor.isEmpty) {
                return 'O campo descrição é obrigatório';
              }
              return null;
            },
          ),
          TextFormField(
            controller: dataVisitaController,
            decoration: InputDecoration(
              labelText: 'Data de Visita',
              prefixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _mostrarCalendario,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => dataVisitaController.clear(),
              ),
            ),
            readOnly: true,
          ),
        ],
      ),
    );
  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  void _mostrarCalendario() {
    final dataFormatada = dataVisitaController.text;
    var data = DateTime.now();
    if (dataFormatada.isNotEmpty && dataFormatada != 'Não visitado') {
      data = _dateFormat.parse(dataFormatada);
    }
    showDatePicker(
      context: context,
      initialDate: data,
      firstDate: data.subtract(const Duration(days: 5 * 365)),
      lastDate: data.add(const Duration(days: 5 * 365)),
    ).then((DateTime? dataSelecionada) {
      if (dataSelecionada != null) {
        setState(() {
          dataVisitaController.text = _dateFormat.format(dataSelecionada);
        });
      }
    });
  }

  Lugar get novoLugar => Lugar(
    id: widget.lugarAtual?.id ?? 0,
    nome: nomeController.text,
    descricao: descricaoController.text,
    dataVisita: dataVisitaController.text.isEmpty
        ? null
        : _dateFormat.parse(dataVisitaController.text),
  );
}
