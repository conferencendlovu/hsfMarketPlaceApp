import 'package:sliverapp/wishnote_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'WishNote.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE WishNote (id INTEGER PRIMARY KEY AUTOINCREMENT, note TEXT, product_id INTEGER, reminder TEXT)');
  }

  Future<WishNote> add(WishNote WishNote) async {
    var dbClient = await db;
    WishNote.id = await dbClient.insert('WishNote', WishNote.toMap());
    return WishNote;
  }

  Future<List<WishNote>> getWishNotes() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('WishNote', columns: ['id', 'note','product_id','reminder']);
    List<WishNote> WishNotes = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        WishNotes.add(WishNote.fromMap(maps[i]));
      }
    }
    return WishNotes;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'WishNote',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(WishNote WishNote) async {
    var dbClient = await db;
    return await dbClient.update(
      'WishNote',
      WishNote.toMap(),
      where: 'id = ?',
      whereArgs: [WishNote.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
