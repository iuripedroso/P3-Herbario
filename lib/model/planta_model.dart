class Planta {
  String? id;
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

  factory Planta.fromMap(Map<String, dynamic> map, String docId) {
    return Planta(
      id: docId,
      nome: map['nome'] ?? '',
      familia: map['familia'] ?? '',
      genero: map['genero'] ?? '',
      imagemUrl: map['imagemUrl'] ?? '',
      comestivel: map['comestivel'] ?? 'Não',
      descricao: map['descricao'] ?? '',
      tipo: map['tipo'] ?? 'Flores',
      ambiente: map['ambiente'] ?? 'Interno',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'familia': familia,
      'genero': genero,
      'imagemUrl': imagemUrl,
      'comestivel': comestivel,
      'descricao': descricao,
      'tipo': tipo,
      'ambiente': ambiente,
    };
  }

  @override
  String toString() {
    return 'Planta(id: $id, nome: $nome, familia: $familia, tipo: $tipo)';
  }
}