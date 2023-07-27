import 'package:sqflite/sqflite.dart';

import '../../features/models/movie_model.dart';

class DatabaseService {
  final String _databaseName = "movie";
  final int version = 1;
  final String tableName = "movie";
  Database? _db;
  final String tableId = "id";
  final String tableMovie = "movie";

  Future<Database> get _database async {
    final path = await getDatabasesPath();
    _db ??= await openDatabase("$path/$_databaseName", version: version,
        onCreate: (db, version) {
      db.execute(
        'CREATE TABLE $tableName ($tableId INTEGET PRIMARY KEY, $tableMovie TEXT)',
      );
    });
    return _db!;
  }

  Future<void> addToFavorite(MovieModel movie) async {
    final database = await _database;
    await database.insert(tableName, {
      tableId: movie.id,
      tableMovie: movie.copyWith(favorite: true).toJson(),
    });
  }

  Future<List<MovieModel>> getAllFavorite() async {
    final database = await _database;
    final res = await database.query(tableName);
    return res
        .where((e) => e[tableMovie] != null)
        .map((e) => MovieModel.fromJson(e[tableMovie] as String))
        .toList();
  }

  Future<void> unFavorite(int id) async {
    final database = await _database;
    await database.delete(tableName, where: "$tableId = ?", whereArgs: [id]);
  }

  Future<bool> isFavorite(int id) async {
    final database = await _database;
    final res =
        await database.query(tableName, where: "$tableId = ?", whereArgs: [id]);
    return res.isNotEmpty;
  }
}
