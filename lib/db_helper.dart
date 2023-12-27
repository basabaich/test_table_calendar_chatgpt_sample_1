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

  //##
  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  // Future<void> initialiseDatabase() async {
  //   var _database = await openDatabase(
  //     join(await getDatabasesPath(), 'My_dataBase.db'),
  //     onCreate: (db, version) async {
  //       await db.execute('''CREATE TABLE IF NOT EXISTS users(
  //         id INTEGER PRIMARY KEY AUTOINCREMENT, noteName TEXT,
  //         noteQuery TEXT)''');
  //       await db.execute('''CREATE TABLE IF NOT EXISTS clickedNotes(
  //         id INTEGER PRIMARY KEY AUTOINCREMENT, clickedNoteName TEXT)''');
  //     },
  //     version: 1,
  //   );
  // }

  // Method to insert a clicked note
  // Future<void> insertClickedNote(String clickedNoteName) async {
  //   final db = await _openDatabase();
  //   final data = {
  //     'clickedNoteName': clickedNoteName,
  //   };
  //   await db.insert('clickedNotes', data);
  // }

  // Method to retrieve the last clicked note
  // Future<Map<String, dynamic>?> getLastClickedNote() async {
  //   final db = await _openDatabase();
  //   final List<Map<String, dynamic>> result = await db.query(
  //     'clickedNotes',
  //     orderBy:
  //         'id DESC', // Order by id in descending order to get the last clicked note
  //     limit: 1,
  //   );

  //   if (result.isNotEmpty) {
  //     return result.first;
  //   } else {
  //     return null;
  //   }
  // }

  // ... (rest of your code)
}
