import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantas/service/planta_service.dart';
import 'package:plantas/model/planta_model.dart';
import 'package:plantas/view/planta_page.dart';
import 'package:plantas/view/detalhes_planta_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PlantaService _plantaService = PlantaService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _searchController = TextEditingController();
  String _termoPesquisa = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _termoPesquisa = _searchController.text.toLowerCase();
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
  }

  void _abrirFormulario({Planta? planta}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantaPage(planta: planta),
      ),
    );

    if (resultado != null) {
      setState(() {});
    }
  }

  void _abrirDetalhes(Planta planta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesPlantaPage(planta: planta),
      ),
    );
  }

  void _deletarPlanta(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deletar Planta"),
        content: const Text("Tem certeza que deseja deletar esta planta?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _plantaService.deletarPlanta(id);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Planta deletada com sucesso!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  setState(() {});
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erro ao deletar: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text("Deletar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Minhas Plantas"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.green[600],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearchBar(),
          ),
          Expanded(
            child: StreamBuilder<List<Planta>>(
              stream: _plantaService.buscarTodasPlantas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erro: ${snapshot.error}"),
                  );
                }

                final todasPlantas = snapshot.data ?? [];
                
                final plantasFiltradas = todasPlantas.where((planta) {
                  if (_termoPesquisa.isEmpty) {
                    return true;
                  }
                  return planta.nome.toLowerCase().contains(_termoPesquisa);
                }).toList();
                
                if (plantasFiltradas.isEmpty) {
                  return Center(
                    child: Text(_termoPesquisa.isEmpty 
                      ? "Nenhuma planta cadastrada." 
                      : "Nenhuma planta encontrada com o termo: \"${_searchController.text}\""),
                  );
                }

                return ListView.builder(
                  itemCount: plantasFiltradas.length,
                  itemBuilder: (context, index) {
                    final planta = plantasFiltradas[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            planta.imagemUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                child: const Icon(Icons.local_florist),
                              );
                            },
                          ),
                        ),
                        title: Text(planta.nome),
                        subtitle: Text(planta.tipo),
                        onTap: () => _abrirDetalhes(planta),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: const Text("Editar"),
                              onTap: () => _abrirFormulario(planta: planta),
                            ),
                            PopupMenuItem(
                              child: const Text("Deletar", style: TextStyle(color: Colors.red)),
                              onTap: () {
                                Future.delayed(Duration.zero, () => _deletarPlanta(planta.id!));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Pesquisar plantas...",
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          suffixIcon: _termoPesquisa.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _termoPesquisa = '';
                    });
                  },
                )
              : null,
        ),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}