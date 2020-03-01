import 'dart:async';
import 'dart:io';

//import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_diary/models/mark.dart';
import 'package:school_diary/models/scheduleItem.dart';
import 'package:sqflite/sqflite.dart';
import 'models/subject.dart';
import 'models/mark.dart';


class DatabaseHelper{
  static DatabaseHelper _dataBaseHelper;
  static Database _database;

  String tableName = "subjects";
  String name = "name";
  String id = "id";
  String averageScore = "averageMark";
  String marksKol = "marksKol";

  String marks = "marks";
  String markId = "markId";
  String value = "value";
  String subjectId = "subjectId";

  String order = 'order';
  String weekday = 'weekday';
  String scheduleitems = 'scheduleitems';

  String begin = 'begin';
  String end = 'end';
  String bells = 'bells';


  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if (_dataBaseHelper == null)
      {
        _dataBaseHelper = DatabaseHelper._createInstance();
      }
    return _dataBaseHelper;
  }

  Future<Database> get database async{
    if (_database == null){
      _database = await inicializeDatabase();
    }

    return _database;
  }

  Future<Database> inicializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'schoolDiary.db';

    var subjDB = await openDatabase(path, version: 2, onCreate: _createDB);
    return subjDB;
  }

  void _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE $tableName($id INTEGER PRIMARY KEY AUTOINCREMENT, $name TEXT, $averageScore FLOAT, $marksKol INTEGER)');
    await db.execute('CREATE TABLE $marks($markId INTEGER PRIMARY KEY AUTOINCREMENT, $value INTEGER, $subjectId INTEGER)');
    await db.execute('CREATE TABLE $scheduleitems($id INTEGER PRIMARY KEY AUTOINCREMENT, $weekday INTEGER, $name TEXT)');
    await db.execute('CREATE TABLE $bells($order INTEGER, $begin INTEGER, $end INTEGER)');
  }

  Future <List<Map<String,dynamic>>> getSubjectsMapList() async{
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $tableName order by $id ASC');
    return result;
  }

  Future <int> insertSubject(Subject subject) async {
    Database db = await this.database;
    var result = await db.insert(tableName, subject.toMap());
    return result;
  }

  Future<int> updateSubject(Subject subject) async
  {
    var db = await this.database;
    var result = await db.update(tableName, subject.toMap(), where: '$id = ?',whereArgs: [subject.id]);
    return result;
  }

  Future<int> deleteSubject(int rId) async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $tableName WHERE $id = $rId');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $tableName');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Subject>> getSubjectsList() async{
    var subjMapList = await getSubjectsMapList();
    int count = subjMapList.length;
    List<Subject> list = List<Subject>();
    for (int i=0; i<count; i++)
      list.add(Subject.fromMap(subjMapList[i]));
    return list;
  }

  //Helper for marks

  Future <List<Map<String,dynamic>>> getMarksMapList(Subject subject) async{
    int sId = subject.id;
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $marks WHERE $subjectId = $sId');
    return result;
  }

  Future <int> insertMark(Mark mark) async {
    Database db = await this.database;
    var result = await db.insert(marks, mark.toMap());
    return result;
  }

  Future<int> deleteMarks(int sId) async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $marks WHERE $subjectId = $sId');
    return result;
  }

  Future<int> deleteMark(int mId) async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $marks WHERE $markId = $mId');
    return result;
  }

  Future<int> getMarksCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $marks');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> getMarksSum(Subject subject) async{
    int sId = subject.id;
    Database db = await this.database;
    var result = await db.rawQuery('SELECT SUM(value) FROM $marks WHERE $subjectId = $sId');
    int value = result[0]["SUM(value)"];
    return value;
  }

  Future<List<Mark>> getMarksList(Subject subject) async{
    var marksMapList = await getMarksMapList(subject);
    int count = marksMapList.length;
    List<Mark> list = List<Mark>();
    for (int i=0; i<count; i++)
      list.add(Mark.fromMap(marksMapList[i]));
    return list;
  }

  //Helper for schedule

  Future <List<Map<String,dynamic>>> getScheduleMapList() async{
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $scheduleitems order by $id ASC');
    return result;
  }

  Future<List<ScheduleItem>> getScheduleItems() async{
    var MapList = await getScheduleMapList();
    int count = MapList.length;
    List<ScheduleItem> list = List<ScheduleItem>();
    for (int i=0; i<count; i++)
      list.add(ScheduleItem.fromMap(MapList[i]));
    return list;
  }

  Future<int> updateSchedule(ScheduleItem item) async
  {
    var db = await this.database;
    var result = await db.update(scheduleitems, item.toMap(), where: '$id = ?',whereArgs: [item.id]);
    return result;
  }

  Future <int> insertScheduleItem(ScheduleItem item) async {
    Database db = await this.database;
    var result = await db.insert(scheduleitems, item.toMap());
    return result;
  }

  Future<int> deleteScheduleItem(int sid) async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $scheduleitems WHERE $id = $sid');
    return result;
  }

  //Bells

  

}