import 'package:flutter/material.dart';
import '../model/lugar.dart';
import '../widget/conteudo_form_dialog.dart';
 // Importe o formulário de conteúdo para o Lugar

class ListaLugaresPage extends StatefulWidget {
  @override
  _ListaLugaresPageState createState() => _ListaLugaresPageState();
}

class _ListaLugaresPageState extends State<ListaLugaresPage> {
  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final List<Lugar> _lugares = [];
  int _ultimoId = 0; // Acompanhar o último ID para garantir que não haja duplicatas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Novo Lugar Visitado',
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('Gerenciador de Lugares Visitados'),
    );
  }

  Widget _criarBody() {
    if (_lugares.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum lugar visitado cadastrado',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.separated(
      itemCount: _lugares.length,
      itemBuilder: (BuildContext context, int index) {
        final lugar = _lugares[index];
        return ListTile(
          title: Text('${lugar.id} - ${lugar.nome}'),
          subtitle: Text(lugar.dataVisita == null
              ? 'Status: Não visitado'
              : 'Status: Visitado em ${lugar.dataVisitaFormatada}'),
          trailing: PopupMenuButton<String>(
            onSelected: (String valorSelecionado) {
              if (valorSelecionado == ACAO_EDITAR) {
                _abrirForm(lugarAtual: lugar, indice: index);
              } else {
                _excluirLugar(index);
              }
            },
            itemBuilder: (BuildContext context) => _criarMenuPopup(),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  void _excluirLugar(int indice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text('Atenção'),
            ],
          ),
          content: const Text('Deseja realmente excluir este lugar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _lugares.removeAt(indice);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  List<PopupMenuEntry<String>> _criarMenuPopup() {
    return [
      const PopupMenuItem<String>(
        value: ACAO_EDITAR,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.black),
            SizedBox(width: 10),
            Text('Editar'),
          ],
        ),
      ),
      const PopupMenuItem<String>(
        value: ACAO_EXCLUIR,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            SizedBox(width: 10),
            Text('Excluir'),
          ],
        ),
      ),
    ];
  }

  void _abrirForm({Lugar? lugarAtual, int? indice}) {
    final key = GlobalKey<ConteudoFormDialogState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            lugarAtual == null ? 'Novo Lugar' : 'Editar Lugar ${lugarAtual.id}',
          ),
          content: ConteudoFormDialog(key: key, lugarAtual: lugarAtual),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                if (key.currentState != null && key.currentState!.dadosValidados()) {
                  setState(() {
                    final novoLugar = key.currentState!.novoLugar;
                    if (indice == null) {
                      // Atribui um ID único ao novo lugar
                      novoLugar.id = ++_ultimoId;
                      _lugares.add(novoLugar);
                    } else {
                      _lugares[indice] = novoLugar;
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
