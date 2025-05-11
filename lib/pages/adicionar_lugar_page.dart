import 'package:flutter/material.dart';
import '../dao/lugar_dao.dart';
import 'atividades_page.dart';
import '../model/lugar.dart';
import 'package:trabalho_disiciplina/pages/home_page.dart'; // Importar a HomePage

class AdicionarLugarPage extends StatefulWidget {
  @override
  _AdicionarLugarPageState createState() => _AdicionarLugarPageState();


}

class _AdicionarLugarPageState extends State<AdicionarLugarPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController atividadesController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();

  final LugarDao _dao = LugarDao();


  DateTime? dataVisitaSelecionada;
  List<Lugar> lugares = [];

  void salvarLugar() async {
    final String nome = nomeController.text;
    final String descricao = descricaoController.text;
    final String atividades = atividadesController.text;
    final String localidade = localidadeController.text;

    if (nome.isNotEmpty && descricao.isNotEmpty && localidade.isNotEmpty && dataVisitaSelecionada != null) {
      final novoLugar = Lugar(
        nome: nome,
        descricao: descricao,
        dataVisita: dataVisitaSelecionada!,
        atividadesRealizadas: atividades.split(',').map((e) => e.trim()).toList(),
        localizacao: localidade, id: null,
      );

      final sucesso = await _dao.salvar(novoLugar);

      if (sucesso) {
        mostrarDialogo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar o lugar.')),
        );
      }
    }
  }


  Future<void> mostrarDialogo() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Lugar salvo com sucesso!"),
          content: Text("Deseja cadastrar outro lugar ou voltar para a tela inicial?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetarCampos();
              },
              child: Text("Cadastrar outro"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, true);
              },
              child: Text("Voltar à página inicial"),
            ),
          ],
        );
      },
    );
  }

  void resetarCampos() {
    setState(() {
      nomeController.clear();
      descricaoController.clear();
      atividadesController.clear();
      localidadeController.clear();
      dataVisitaSelecionada = null;
    });
  }

  Future<void> selecionarDataVisita() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (dataSelecionada != null) {
      setState(() {
        dataVisitaSelecionada = dataSelecionada;
      });
    }
  }

  Future<void> navegarParaAtividades() async {
    final atividadesSelecionadas = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AtividadesPage()),
    );

    if (atividadesSelecionadas != null) {
      setState(() {
        atividadesController.text = atividadesSelecionadas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo[300]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Image.asset(
                    'images/a_image_segundaTela.png',
                    width: 80,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'JourneyMap',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'FonteUsada',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Cadastro",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'FonteUsada',
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Registre os lugares visitados e suas anotações de viagem.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  campoTexto("Nome do Lugar", "Digite o nome do lugar", nomeController),
                  campoTexto("Descrição", "Digite a descrição", descricaoController, maxLines: 3),
                  campoTexto("Localidade", "Digite a localização", localidadeController),

                  campoTexto(
                    "Atividades Realizadas",
                    "Escolha as atividades realizadas",
                    atividadesController,
                    readOnly: true,
                    onTap: navegarParaAtividades,
                    suffixIcon: Icons.arrow_drop_down,
                  ),

                  // Campo de seleção de data
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data da Visita",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: selecionarDataVisita,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dataVisitaSelecionada != null
                                      ? "${dataVisitaSelecionada!.day}/${dataVisitaSelecionada!.month}/${dataVisitaSelecionada!.year}"
                                      : "Selecione a data",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                Icon(Icons.calendar_today, color: Colors.blueAccent),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Botão de salvar
                  Center(
                    child: ElevatedButton(
                      onPressed: salvarLugar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[100],
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Salvar Lugar",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget campoTexto(String label, String hint, TextEditingController controller,
      {bool readOnly = false, VoidCallback? onTap, int maxLines = 1, IconData? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }
}