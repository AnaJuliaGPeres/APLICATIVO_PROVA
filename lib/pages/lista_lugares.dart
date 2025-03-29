import 'package:flutter/material.dart';
import '../model/lugar.dart';
import '../widget/conteudo_form_dialog.dart';

class ListaLugaresPage extends StatefulWidget {
  final List<Lugar> lugares;

  const ListaLugaresPage({Key? key, required this.lugares}) : super(key: key);

  @override
  _ListaLugaresPageState createState() => _ListaLugaresPageState();
}

class _ListaLugaresPageState extends State<ListaLugaresPage> {
  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  late List<Lugar> _lugares;

  @override
  void initState() {
    super.initState();
    _lugares = List.from(widget.lugares);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciador de Lugares Visitados')),
      body: _criarBody(),
    );
  }

  Widget _criarBody() {
    if (_lugares.isEmpty) {
      return const Center(
        child: Text('Nenhum lugar visitado cadastrado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );
    }
    return ListView.separated(
      itemCount: _lugares.length,
      itemBuilder: (context, index) {
        final lugar = _lugares[index];
        return ListTile(
          title: Text('${lugar.id} - ${lugar.nome}'),
          subtitle: Text(lugar.dataVisita == null
              ? 'Status: Não visitado'
              : 'Status: Visitado em ${lugar.dataVisitaFormatada}'),
          trailing: PopupMenuButton<String>(
            onSelected: (String valorSelecionado) {
              if (valorSelecionado == ACAO_EDITAR) {
                _editarLugar(index);
              } else {
                _excluirLugar(index);
              }
            },
            itemBuilder: (context) => _criarMenuPopup(),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  void _editarLugar(int index) async {
    final resultado = await showDialog<Lugar>(
      context: context,
      builder: (context) => ConteudoFormDialog(lugarAtual: _lugares[index]),
    );

    if (resultado != null) {
      setState(() {
        _lugares[index] = resultado;
      });
    }
  }

  void _excluirLugar(int index) {
    setState(() {
      _lugares.removeAt(index);
    });
  }

  List<PopupMenuEntry<String>> _criarMenuPopup() {
    return [
      const PopupMenuItem<String>(
        value: ACAO_EDITAR,
        child: Text('Editar'),
      ),
      const PopupMenuItem<String>(
        value: ACAO_EXCLUIR,
        child: Text('Excluir'),
      ),
    ];
  }
}
