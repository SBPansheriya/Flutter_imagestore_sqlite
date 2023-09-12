import 'package:imagestore_sqlite/item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper.privateconstuctor(); // Private constructor to ensure a singleton instance
  static final DbHelper instance = DbHelper.privateconstuctor();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'your_database_name.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertItem(Item item) async {
    final db = await database;
    return await db!.insert('items', item.toMap());
  }

  Future<List<Item>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('items');
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }
}



