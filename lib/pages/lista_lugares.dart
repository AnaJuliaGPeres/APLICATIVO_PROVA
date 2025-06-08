import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dao/lugar_dao.dart';
import '../model/lugar.dart';
import '../widget/conteudo_form_dialog.dart';
import 'adicionar_lugar_page.dart';
import 'detalhes_lugar_page.dart';


class ListaLugaresPage extends StatefulWidget {
  final List<Lugar> lugares;

  const ListaLugaresPage({Key? key, required this.lugares}) : super(key: key);

  @override
  _ListaLugaresPageState createState() => _ListaLugaresPageState();
}



class _ListaLugaresPageState extends State<ListaLugaresPage> {
  final LugarDao _dao = LugarDao();
  static const ACAO_EXCLUIR = 'excluir';
  static const ACAO_VISUALIZACAO = 'visualizar';

  final lugar = <Lugar>[];
  var _carregando = false;

  @override
  void initState() {
    super.initState();
    _atualizarLista(); // já faz o load direto
  }

  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });

    final lugaresDb = await _dao.listar();
    setState(() {
      lugar.clear();
      lugar.addAll(lugaresDb);
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      backgroundColor:   Colors.indigo[400],
      centerTitle: true,
      title: const Text(
        'Gerenciador de Lugares',
        style: TextStyle(color: Colors.black), // Alterando a cor do texto para preto
      ),
    );

  }

  Widget _criarBody() {
    if (_carregando) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          Text(
            'Carregando as suas Viagens!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      );
    }
    if (lugar.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum lugar cadastrado',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.separated(
      itemCount: lugar.length,
      itemBuilder: (BuildContext context, int index) {
        final lugares = lugar[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context) => _criarMenuPopUp(),
            onSelected: (String valorSelecionado) {
              if (valorSelecionado == ACAO_EXCLUIR) {
                _excluir(lugares);
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => DetalhesLugarPage(lugar: lugares),
                ));
              }
            },
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(
                '${lugares.nome}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descrição: ${lugares.descricao}'),
                  Text('Local: ${lugares.localizacao}'),
                  Text('Data da visita: ${lugares.dataVisitaFormatada}'),

                  if (lugares.atividadesRealizadas != null &&
                      lugares.atividadesRealizadas!.isNotEmpty)
                    Text('Atividades: ${lugares.atividadesRealizadas!.join(", ")}'),
                  Text("Latitude: ${lugares.latitude ?? 'N/A'}"),
                  Text("Longitude: ${lugares.longitude ?? 'N/A'}"),

                ],
              ),
              trailing: const Icon(Icons.more_vert),
            ),
          ),
        );

      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  List<PopupMenuEntry<String>> _criarMenuPopUp() {
    return [
      const PopupMenuItem<String>(
        value: ACAO_VISUALIZACAO,
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 10),
            Text('Visualizar'),
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


  void _excluir(Lugar lugar) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text('Atenção'),
            ],
          ),
          content: const Text('Deseja realmente excluir esse registro?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _dao.remover(lugar.id!).then((sucess) {
                  if (sucess) {
                    _atualizarLista();
                  }
                });
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }
}
