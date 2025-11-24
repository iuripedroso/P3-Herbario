import 'package:plantas/model/planta_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//singleton
class PlantaHelper {
  static final PlantaHelper _instancia = PlantaHelper.interno();
  factory PlantaHelper() => _instancia;
  PlantaHelper.interno();

  Database? _banco;
  
  //getter
  Future<Database> get banco async {
    if (_banco != null) {
      return _banco!;
    } else {
      _banco = await iniciarBanco(); 
      return _banco!;
    }
  }

  //incializa o bd
  Future<Database> iniciarBanco() async {
    
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "plantasDB.db");
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newVersion) async {
        await db.execute('''
          CREATE TABLE $tabelaPlantas(
            $colunaId INTEGER PRIMARY KEY,
            $colunaNome TEXT,
            $colunaFamilia TEXT,
            $colunaGenero TEXT,
            $colunaImagemUrl TEXT,
            $colunaComestivel TEXT,
            $colunaDescricao TEXT,
            $colunaTipo TEXT,
            $colunaAmbiente TEXT
          )
        ''');
      },
    );
  }

  Future<Planta> salvarPlanta(Planta planta) async {
    Database dbPlanta = await banco;
    planta.id = await dbPlanta.insert(tabelaPlantas, planta.paraMap());
    return planta;
  }

  Future<Planta?> buscarPlanta(int id) async {
    Database dbPlanta = await banco;
    List<Map<String, dynamic>> maps = await dbPlanta.query(
      tabelaPlantas,
      columns: [
        colunaId,
        colunaNome,
        colunaFamilia,
        colunaGenero,
        colunaImagemUrl,
        colunaComestivel,
        colunaDescricao,
        colunaTipo,
        colunaAmbiente,
      ],
      where: "$colunaId = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Planta.doMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Planta>> buscarTodasPlantas() async {
    Database dbPlanta = await banco;
    List<Map<String, dynamic>> listMap = await dbPlanta.query(tabelaPlantas);
    List<Planta> listPlanta = [];
    for (Map<String, dynamic> m in listMap) {
      listPlanta.add(Planta.doMap(m));
    }
    return listPlanta;
  }

  Future<int> deletarPlanta(int id) async {
    Database dbPlanta = await banco;
    return await dbPlanta.delete(
      tabelaPlantas,
      where: "$colunaId = ?",
      whereArgs: [id],
    );
  }

  Future<int> atualizarPlanta(Planta planta) async {
    Database dbPlanta = await banco;
    return await dbPlanta.update(
      tabelaPlantas,
      planta.paraMap(),
      where: "$colunaId = ?",
      whereArgs: [planta.id],
    );
  }
}