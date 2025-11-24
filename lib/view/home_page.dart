import 'package:flutter/material.dart';
import 'package:plantas/database/helper/planta_helper.dart';
import 'package:plantas/view/planta_page.dart';
import 'package:plantas/model/planta_model.dart';
import 'package:plantas/view/detalhes_planta_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlantaHelper helper = PlantaHelper();
  List<Planta> _listaCompletaPlantas = [];
  List<Planta> _plantasFiltradas = [];
  final _controladorBusca = TextEditingController();

  @override
  void initState() {
    super.initState();
    _atualizarListaPlantas();
    _controladorBusca.addListener(() {
      _filtrarPlantas(_controladorBusca.text);
    });
  }

  @override
  void dispose() {
    _controladorBusca.dispose();
    super.dispose();
  }

  void _atualizarListaPlantas() {
    helper.buscarTodasPlantas().then((list) {
      setState(() {
        _listaCompletaPlantas = list;
        _plantasFiltradas = list;
        _controladorBusca.clear();
      });
    });
  }

  void _filtrarPlantas(String query) {
    List<Planta> listaFiltrada;
    if (query.isEmpty) {
      listaFiltrada = List.from(_listaCompletaPlantas);
    } else {
      listaFiltrada = _listaCompletaPlantas.where((planta) {
        return planta.nome.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    setState(() {
      _plantasFiltradas = listaFiltrada;
    });
  }

  Future<bool?> _confirmarExcluir({
    required BuildContext context,
    required String nomePlanta,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.grey[800], fontSize: 20, fontWeight: FontWeight.bold),
          contentTextStyle: TextStyle(color: Colors.grey[700]),
          title: Text('Excluir Planta?'),
          content: Text(
            'Tem certeza que deseja excluir a planta "$nomePlanta"?\n\nEsta ação não pode ser desfeita.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.grey[600])),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: Text('Excluir'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Text("Herbário"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.green[400],
              radius: 16,
              child: Icon(Icons.eco, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarPaginaPlanta();
        },
        backgroundColor: Colors.green[600],
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _controladorBusca,
              style: TextStyle(color: Colors.grey[800]),
              decoration: InputDecoration(
                hintText: "Buscar no herbário...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                  onPressed: () {
                    _controladorBusca.clear();
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green[600]!),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
              itemCount: _plantasFiltradas.length,
              itemBuilder: (context, index) {
                return _cartaoPlanta(context, index, _plantasFiltradas[index]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartaoPlanta(BuildContext context, int index, Planta planta) {
    return GestureDetector(
      onTap: () {
        _mostrarOpcoes(context, planta);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Image.network(
                planta.imagemUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.local_florist,
                      color: Colors.grey[400],
                      size: 50,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.green[600],
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planta.nome,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    planta.tipo,
                    style: TextStyle(fontSize: 12.0, color: Colors.green[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarOpcoes(BuildContext context, Planta planta) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  planta.nome,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(color: Colors.grey[300], height: 1),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _mostrarPaginaDetalhes(planta: planta);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.green[600]),
                      SizedBox(width: 16.0),
                      Text(
                        "Ver Detalhes",
                        style: TextStyle(color: Colors.grey[800], fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _mostrarPaginaPlanta(planta: planta);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.green[600]),
                      SizedBox(width: 16.0),
                      Text(
                        "Editar",
                        style: TextStyle(color: Colors.grey[800], fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  final bool? shouldDelete = await _confirmarExcluir(
                    context: context,
                    nomePlanta: planta.nome,
                  );
                  if (shouldDelete == true) {
                    if (planta.id != null) {
                      await helper.deletarPlanta(planta.id!);
                      _atualizarListaPlantas();
                    }
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.redAccent),
                      SizedBox(width: 16.0),
                      Text(
                        "Excluir",
                        style: TextStyle(color: const Color.fromARGB(255, 12, 10, 10), fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _mostrarPaginaPlanta({Planta? planta}) async {
    final plantaAtualizada = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlantaPage(planta: planta)),
    );
    if (plantaAtualizada != null) {
      _atualizarListaPlantas();
    }
  }

  void _mostrarPaginaDetalhes({required Planta planta}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalhesPlantaPage(planta: planta)),
    );
  }
}
