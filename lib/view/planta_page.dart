import 'package:flutter/material.dart';
import 'package:plantas/database/helper/planta_helper.dart';
import 'package:plantas/model/planta_model.dart';
import 'package:plantas/view/components/my_dropdown.dart';
import 'package:plantas/view/components/my_text.dart';

List<String> opcoesComestivel = [
  "Sim",
  "Não",
  "Parcialmente",
];

List<String> opcoesTipo = [
  "Flores",
  "Árvore",
  "Arbusto",
  "Erva",
  "Trepadeira",
  "Suculenta",
  "Cacto",
  "Samambaia",
  "Palmeira",
  "Gramínea",
  "Aquática",
];

List<String> opcoesAmbiente = [
  "Interno",
  "Externo",
  "Meia-sombra",
  "Sol pleno",
  "Sombra",
  "Aquático",
  "Desértico",
  "Tropical",
  "Temperado",
];

//editar | criar planta
class PlantaPage extends StatefulWidget {
  final Planta? planta;
  PlantaPage({Key? key, this.planta}) : super(key: key);

  @override
  State<PlantaPage> createState() => _PlantaPageState();
}

class _PlantaPageState extends State<PlantaPage> {

  Planta? _plantaEditada;
  final PlantaHelper _helper = PlantaHelper();
  
  final _controladorNome = TextEditingController();
  final _controladorFamilia = TextEditingController();
  final _controladorGenero = TextEditingController();
  final _controladorImagemUrl = TextEditingController();
  final _controladorDescricao = TextEditingController();

  String? _comestivelSelecionado;
  String? _tipoSelecionado;
  String? _ambienteSelecionado;
  
  bool _carregando = false; //desabilita o botão salvar durante o salvamento

  String? _erroNome;
  String? _erroFamilia;
  String? _erroGenero;
  String? _erroImagemUrl;
  String? _erroDescricao;
  String? _erroComestivel;
  String? _erroTipo;
  String? _erroAmbiente;

  @override
  void initState() {
    super.initState();
    if (widget.planta == null) {
      _plantaEditada = Planta(
        nome: "",
        familia: "",
        genero: "",
        imagemUrl: "",
        comestivel: opcoesComestivel.first,
        descricao: "",
        tipo: opcoesTipo.first,
        ambiente: opcoesAmbiente.first,
      );

      _comestivelSelecionado = opcoesComestivel.first;
      _tipoSelecionado = opcoesTipo.first;
      _ambienteSelecionado = opcoesAmbiente.first;

    } else {
    
      _plantaEditada = widget.planta;

      _controladorNome.text = _plantaEditada?.nome ?? "";
      _controladorFamilia.text = _plantaEditada?.familia ?? "";
      _controladorGenero.text = _plantaEditada?.genero ?? "";
      _controladorImagemUrl.text = _plantaEditada?.imagemUrl ?? "";
      _controladorDescricao.text = _plantaEditada?.descricao ?? "";
      
      _comestivelSelecionado = _plantaEditada?.comestivel;
      _tipoSelecionado = _plantaEditada?.tipo;
      _ambienteSelecionado = _plantaEditada?.ambiente;
    
    }
  }

  void _limparErros() {
    setState(() {
      _erroNome = null;
      _erroFamilia = null;
      _erroGenero = null;
      _erroImagemUrl = null;
      _erroDescricao = null;
      _erroComestivel = null;
      _erroTipo = null;
      _erroAmbiente = null;
    });
  }

  bool _validarCampos() {
    _limparErros();
    bool temErro = false;
    // istrim() pega os espaços em branco
    if (_controladorNome.text.trim().isEmpty) {
      setState(() => _erroNome = "O Nome é obrigatório.");
      temErro = true;
    }

    // if (_controladorFamilia.text.isEmpty) {
    //   setState(() => _erroFamilia = "A Família é obrigatória.");
    //   temErro = true;
    // }
    // if (_controladorGenero.text.isEmpty) {
    //   setState(() => _erroGenero = "O Gênero é obrigatório.");
    //   temErro = true;
    // }
    
    if (_controladorImagemUrl.text.isEmpty) {
      setState(() => _erroImagemUrl = "A URL da Imagem é obrigatória.");
      temErro = true;
    }
    // if (_controladorDescricao.text.isEmpty) {
    //   setState(() => _erroDescricao = "A Descrição é obrigatória.");
    //   temErro = true;
    // }

    if (_comestivelSelecionado == null) {
      setState(() => _erroComestivel = "Selecione se é comestível.");
      temErro = true;
    }
    if (_tipoSelecionado == null) {
      setState(() => _erroTipo = "Selecione um tipo.");
      temErro = true;
    }
    if (_ambienteSelecionado == null) {
      setState(() => _erroAmbiente = "Selecione um ambiente.");
      temErro = true;
    }
    return !temErro;
  }

  Future<void> _salvarPlanta() async {
    setState(() => _carregando = true);
    if (!_validarCampos()) {
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Por favor, corrija os campos em vermelho."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _plantaEditada?.nome = _controladorNome.text.trim();
    _plantaEditada?.familia = _controladorFamilia.text;
    _plantaEditada?.genero = _controladorGenero.text;
    _plantaEditada?.imagemUrl = _controladorImagemUrl.text;
    _plantaEditada?.descricao = _controladorDescricao.text;
    _plantaEditada?.comestivel = _comestivelSelecionado!;
    _plantaEditada?.tipo = _tipoSelecionado!;
    _plantaEditada?.ambiente = _ambienteSelecionado!;

    if (_plantaEditada?.id != null) {
      await _helper.atualizarPlanta(_plantaEditada!);
    } else {
      await _helper.salvarPlanta(_plantaEditada!);
    }

    setState(() => _carregando = false);
    if (mounted) Navigator.pop(context, _plantaEditada);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Text(
          _plantaEditada?.nome.isEmpty ?? true
              ? "Nova Planta"
              : _plantaEditada!.nome,
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            MyText(
              controlador: _controladorNome,
              textoLabel: "Nome",
              textoErro: _erroNome,
              icone: Icons.local_florist,
            ),
            SizedBox(height: 10),
            MyText(
              controlador: _controladorFamilia,
              textoLabel: "Família",
              textoErro: _erroFamilia,
              icone: Icons.account_tree,
            ),
            SizedBox(height: 10),
            MyText(
              controlador: _controladorGenero,
              textoLabel: "Gênero",
              textoErro: _erroGenero,
              icone: Icons.category,
            ),
            SizedBox(height: 10),
            MyText(
              controlador: _controladorImagemUrl,
              textoLabel: "URL da Imagem",
              textoErro: _erroImagemUrl,
              icone: Icons.image,
            ),
            SizedBox(height: 10),
            MyText(
              controlador: _controladorDescricao,
              textoLabel: "Descrição",
              textoErro: _erroDescricao,
              icone: Icons.description,
              maxLinhas: 3,
            ),
            SizedBox(height: 20),
            MyDropdown(
              textoLabel: "Comestível",
              valor: _comestivelSelecionado,
              itens: opcoesComestivel,
              textoErro: _erroComestivel,
              icone: Icons.restaurant,
              aoMudar: (novoValor) {
                if (novoValor != null) {
                  setState(() {
                    _comestivelSelecionado = novoValor;
                  });
                }
              },
            ),
            SizedBox(height: 10),
            MyDropdown(
              textoLabel: "Tipo",
              valor: _tipoSelecionado,
              itens: opcoesTipo,
              textoErro: _erroTipo,
              icone: Icons.nature,
              aoMudar: (novoValor) {
                if (novoValor != null) {
                  setState(() {
                    _tipoSelecionado = novoValor;
                  });
                }
              },
            ),
            SizedBox(height: 10),
            MyDropdown(
              textoLabel: "Ambiente",
              valor: _ambienteSelecionado,
              itens: opcoesAmbiente,
              textoErro: _erroAmbiente,
              icone: Icons.wb_sunny,
              aoMudar: (novoValor) {
                if (novoValor != null) {
                  setState(() {
                    _ambienteSelecionado = novoValor;
                  });
                }
              },
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,

              // antigo floatingbutton
              child: ElevatedButton(
                onPressed: _carregando ? null : _salvarPlanta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  disabledBackgroundColor: Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: _carregando
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Salvar Planta",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}