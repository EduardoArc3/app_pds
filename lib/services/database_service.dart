import 'package:app_pds/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._instance();
  static Database? _db;

  DatabaseService._instance();

  Future<Database> get db async {
    _db ??= await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'app_pds.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // crear tabla
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        color INTEGER,
        createdAt TEXT,
        isPinned INTEGER
      )
    ''');
  }

  // crear nota
  Future<int> insertNote(Note note) async {
    Database db = await instance.db;
    return await db.insert('notes', note.toMap());
  }

  // obtener todas las notas
  Future<List<Map<String, dynamic>>> queryAllNotes() async {
    Database db = await instance.db;
    return await db.query('notes');
  }

  // modificar nota
  Future<int> updateNote(Note note) async {
    Database db = await instance.db;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // borrar nota
  Future<int> deleteNote(int id) async {
    Database db = await instance.db;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
