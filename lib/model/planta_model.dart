//representação do banco

String tabelaPlantas = "tabelaPlantas";
String colunaId = "colunaId";
String colunaNome = "colunaNome";
String colunaFamilia = "colunaFamilia";
String colunaGenero = "colunaGenero";
String colunaImagemUrl = "colunaImagemUrl";
String colunaComestivel = "colunaComestivel";
String colunaDescricao = "colunaDescricao";
String colunaTipo = "colunaTipo";
String colunaAmbiente = "colunaAmbiente";

class Planta {
  int? id;
  String nome;
  String familia;
  String genero;
  String imagemUrl;
  String comestivel;
  String descricao;
  String tipo;
  String ambiente;

  Planta({
    this.id,
    required this.nome,
    required this.familia,
    required this.genero,
    required this.imagemUrl,
    required this.comestivel,
    required this.descricao,
    required this.tipo,
    required this.ambiente,
  });

  //pega um Map vindo do SQLite e transforma em um objeto.
  Planta.doMap(Map<String, dynamic> map)
      : id = map[colunaId],
        nome = map[colunaNome],
        familia = map[colunaFamilia],
        genero = map[colunaGenero],
        imagemUrl = map[colunaImagemUrl],
        comestivel = map[colunaComestivel],
        descricao = map[colunaDescricao],
        tipo = map[colunaTipo],
        ambiente = map[colunaAmbiente];

  //pega um objeto e transforma em map
  Map<String, dynamic> paraMap() {
    Map<String, dynamic> map = {
      colunaNome: nome,
      colunaFamilia: familia,
      colunaGenero: genero,
      colunaImagemUrl: imagemUrl,
      colunaComestivel: comestivel,
      colunaDescricao: descricao,
      colunaTipo: tipo,
      colunaAmbiente: ambiente,
    };
    if (id != null) {
      map[colunaId] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Planta(id: $id, nome: $nome, familia: $familia, tipo: $tipo)";
  }
}