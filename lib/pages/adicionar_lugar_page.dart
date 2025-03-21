import 'package:flutter/material.dart';
import '../model/lugar.dart'; // Certifique-se de que a importação está correta

class AdicionarLugarPage extends StatefulWidget {
  @override
  _AdicionarLugarPageState createState() => _AdicionarLugarPageState();
}

class _AdicionarLugarPageState extends State<AdicionarLugarPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  void salvarLugar() {
    final String nome = nomeController.text;
    final String descricao = descricaoController.text;

    if (nome.isNotEmpty && descricao.isNotEmpty) {
      final novoLugar = Lugar(
        id: 0, // Defina o id conforme necessário ou gerencie o id em outro lugar
        nome: nome,
        descricao: descricao,
        dataVisita: null, // Se você quiser adicionar uma data de visita, adicione aqui
      );
      Navigator.pop(context, novoLugar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Lugar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome do Lugar'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarLugar,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
