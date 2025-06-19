import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../dao/lugar_dao.dart';
import '../model/cep.dart';
import '../services/cep_api_service.dart';
import 'atividades_page.dart';
import '../model/lugar.dart';
import 'package:trabalho_disiciplina/services/gps_service.dart';
import 'package:geolocator/geolocator.dart';

class AdicionarLugarPage extends StatefulWidget {
  @override
  _AdicionarLugarPageState createState() => _AdicionarLugarPageState();

}

class _AdicionarLugarPageState extends State<AdicionarLugarPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController atividadesController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController cepController = TextEditingController();

  final LugarDao _dao = LugarDao();
  final GpsService _gpsService = GpsService();
  final CepApiService _cepApiService = CepApiService(); // Instância do serviço de CEP
  bool _buscandoCep = false;

  final _cepMaskFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')},
  );

  DateTime? dataVisitaSelecionada;
  List<Lugar> lugares = [];

  void salvarLugar() async {
    final String nome = nomeController.text;
    final String descricao = descricaoController.text;
    final String atividades = atividadesController.text;
    final String localidade = localidadeController.text;
    final double? latitude = double.tryParse(latitudeController.text);
    final double? longitude = double.tryParse(longitudeController.text);

    if (nome.isNotEmpty && descricao.isNotEmpty && localidade.isNotEmpty && dataVisitaSelecionada != null) {
      final novoLugar = Lugar(
        nome: nome,
        descricao: descricao,
        dataVisita: dataVisitaSelecionada!,
        atividadesRealizadas: atividades.split(',').map((e) => e.trim()).toList(),
        localizacao: localidade,
        latitude: latitude,
        longitude: longitude,
        id: null,
      );

      final sucesso = await _dao.salvar(novoLugar);

      if (sucesso) {
        mostrarDialogo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar o lugar.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos obrigatórios: Nome, Descrição, Localidade e Data da Visita.")),
      );
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
      latitudeController.clear();
      longitudeController.clear();
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

  Future<void> _obterLocalizacaoAtual() async {
    Position? position = await _gpsService.getCurrentLocation(context);
    if (position != null) {
      setState(() {
        latitudeController.text = position.latitude.toString();
        longitudeController.text = position.longitude.toString();
        localidadeController.text = "Lat: ${position.latitude}, Lon: ${position.longitude}"; // Opcional: preencher localidade
      });
    }
  }

  Future<void> _buscarEnderecoPorCep() async {
    // Validação inicial do formato do CEP
    if (cepController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira um CEP.')),
      );
      return;
    }

    if (!_cepMaskFormatter.isFill()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Formato de CEP inválido. Use XXXXX-XXX.')),
      );
      return;
    }

    setState(() {
      _buscandoCep = true;
    });

    final cepValue = _cepMaskFormatter.getUnmaskedText();
    final Cep? cepInfo = await _cepApiService.fetchCep(cepValue);

    setState(() {
      _buscandoCep = false;
    });

    if (cepInfo != null && cepInfo.enderecoFormatado.trim().isNotEmpty) {
      setState(() {
        localidadeController.text = cepInfo.enderecoFormatado;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Endereço encontrado com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CEP inválido ou sem informações de endereço.')),
      );
    }}


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

                  // Campo de CEP com botão de busca
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("CEP (Opcional)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: cepController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [_cepMaskFormatter],
                                decoration: InputDecoration(
                                  hintText: "Digite o CEP",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            _buscandoCep
                                ? CircularProgressIndicator()
                                : IconButton(
                              icon: Icon(Icons.search, color: Colors.blueAccent),
                              onPressed: _buscarEnderecoPorCep,
                              tooltip: 'Buscar Endereço por CEP',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  campoTexto("Localidade", "Endereço completo (Ex: Rua, Nº, Bairro, Cidade - UF)", localidadeController, maxLines: 2), // Ajuste o hintText

                  Row(
                    children: [
                      Expanded(
                        child: campoTexto("Latitude", "Latitude (GPS)", latitudeController, readOnly: true),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: campoTexto("Longitude", "Longitude (GPS)", longitudeController, readOnly: true),
                      ),
                      IconButton(
                        icon: Icon(Icons.gps_fixed, color: Colors.blueAccent),
                        onPressed: _obterLocalizacaoAtual,
                        tooltip: 'Obter Localização GPS Atual',
                      )
                    ],
                  ),

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
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.blueAccent) : null,
            ),
          ),
        ],
      ),
    );
  }}