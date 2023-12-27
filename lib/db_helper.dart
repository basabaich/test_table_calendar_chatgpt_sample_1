import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  //
  //
  //Primarily open the database
  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "My_dataBase.db");
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  //Create a database where male & hasId variables are actually bool status
  //being converted to integer
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS users(
          id INTEGER PRIMARY KEY AUTOINCREMENT, noteName TEXT, 
          noteQuery TEXT)''');
  }

//
  //Adding new record in this database
  Future<int> insertUser(
    String noteName,
    String noteQuery,
    // String lastClickedNoteName,
    // double height,
    // double weight,
    // String complexion,
    // String citizenship,
    // int education,
    // int male,
    // int hasId,
    // int idNumber,
    // double salary
  ) async {
    final db = await _openDatabase();
    final data = {
      'noteName': noteName,
      'noteQuery': noteQuery,
      //'lastClickedNoteName': lastClickedNoteName,
      // 'height': height,
      // 'weight': weight,
      // 'complexion': complexion,
      // 'citizenship': citizenship,
      // 'education': education,
      // 'male': male,
      // 'hasId': hasId,
      // 'idNumber': idNumber,
      // 'salary': salary,
    };
    return await db.insert('users', data);
    //Name of the table in this database is "users" & values are it's
    //"data"
  }

  //Getting data from this database
  Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query('users');
  }
}
