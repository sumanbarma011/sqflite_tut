import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_app/models/task_model.dart';

class SqlService {
  static final SqlService sqlDataBase =
      SqlService._privateConst(); // making singleton
  static Database? _db;
  final String _taskTableName = "task"; //creating table name
  final String _taskIdColumnName = "id"; // creating column id
  final String _taskContentName = "content"; // creating column content
  final String _taskStatusColumnName = "status"; // creating column status

  SqlService._privateConst();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await getDatabase();
      return _db!;
    }
  }
// creating the path for the database and opening it

  Future<Database> getDatabase() async {
    final datapath = await getDatabasesPath();
    final dataBasepath = join(datapath, 'master_db.db');
    final database = await openDatabase(
      dataBasepath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          ''' CREATE TABLE $_taskTableName ($_taskIdColumnName INTEGER PRIMARY KEY, $_taskContentName TEXT NOT NULL, $_taskStatusColumnName INTEGER NOT NULL)  ''',
        );
      },
    );
    return database;
  }

// <   -----------------   Adding data on the database   ---------------------------------  >

  void addTask(String content) async {
    final db = await database;
    await db.insert(
      _taskTableName,
      {_taskContentName: content, _taskStatusColumnName: 0},
    );
  }
// < -----------------   Get data from the database   ---------------------------------  >

  Future<List<Task>> getTask() async {
    final db = await database;
    final taskList = await db.query(_taskTableName);
    print(taskList);
    List<Task> tasks = taskList
        .map(
          (e) => Task(
              taskId: e[_taskIdColumnName] as int,
              taskContent: e[_taskContentName] as String,
              taskStatus: e[_taskStatusColumnName] as int),
        )
        .toList();
    // print('inside get task function');
    // print(tasks[4].taskId);
    return tasks;
  }
// < -----------------   Update data from the database   ---------------------------------  >

  void updateDatabase(int id, int status) async {
    final db = await database;
    await db.update(
        _taskTableName, {_taskIdColumnName: id, _taskStatusColumnName: status},
        where: 'id=?',
        whereArgs: [
          id,
        ]);
  }
// < -----------------   Delete data from the database   ---------------------------------  >
  void deleteDatabase(int id)async{
    final db = await database;
 
    await db.delete(_taskTableName,where:'id = ?',whereArgs: [id,] );
    



}

}
