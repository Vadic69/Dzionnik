import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:school_diary/models/bell.dart';
import 'package:school_diary/models/book.dart';
import 'package:school_diary/models/hometask.dart';
import 'package:school_diary/models/mark.dart';
import 'package:school_diary/models/scheduleItem.dart';
import 'package:school_diary/models/subject.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper{
  static DatabaseHelper _dataBaseHelper;
  static Database _database;

  String subjects = "subjects";
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

  String fileName = "fileName";
  String author = "author";
  String language = "language";
  String form = "form";
  String books = "books";
  String subject = "subject";

  String hometask = "hometask";


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

  var migrationScripts = [
    'CREATE TABLE hometask(id INTEGER PRIMARY KEY, subject TEXT, dateTime TEXT, value TEXT)'
  ];

  Future<Database> inicializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'dzionnik.db';

    var DB = await openDatabase(
        path,
        version: migrationScripts.length+1,
        onCreate: _createDB,
        onUpgrade: (Database db, int oldV, int newV) async {
          print("Old version: $oldV, new: $newV");
          for (int i=oldV-1; i<newV; i++)
            await db.execute(migrationScripts[i]);
      }
    );
    return DB;
  }

  void _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE $subjects($id INTEGER PRIMARY KEY AUTOINCREMENT, $name TEXT, $averageScore FLOAT, $marksKol INTEGER)');
    await db.execute('CREATE TABLE $marks($markId INTEGER PRIMARY KEY AUTOINCREMENT, $value INTEGER, $subjectId INTEGER)');
    await db.execute('CREATE TABLE $scheduleitems($id INTEGER PRIMARY KEY AUTOINCREMENT, $weekday INTEGER, $name TEXT)');
    await db.execute('CREATE TABLE $bells($id INTEGER PRIMARY KEY AUTOINCREMENT, $begin INTEGER, $end INTEGER)');
    await db.execute('CREATE TABLE $books($id TEXT, $form INTEGER, $fileName TEXT, $author TEXT, $language INTEGER, $subject TEXT)');
    await db.execute('CREATE TABLE hometask(id INTEGER PRIMARY KEY, subject TEXT, dateTime TEXT, value TEXT)');
  }

  Future <List<Map<String,dynamic>>> getSubjectsMapList() async{
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $subjects order by $id ASC');
    return result;
  }

  Future <int> insertSubject(Subject subject) async {
    Database db = await this.database;
    var result = await db.insert(subjects, subject.toMap());
    return result;
  }

  Future<int> updateSubject(Subject subject) async
  {
    var db = await this.database;
    var result = await db.update(subjects, subject.toMap(), where: '$id = ?',whereArgs: [subject.id]);
    return result;
  }

  Future<int> deleteSubject(int rId) async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $subjects WHERE $id = $rId');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $subjects');
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


  Future <List<Map<String,dynamic>>> getBellsMapList() async{
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $bells order by $id ASC');
    return result;
  }

  Future<List<Bell>> getBells() async{
    var MapList = await getBellsMapList();
    int count = MapList.length;
    List<Bell> list = List<Bell>();
    for (int i=0; i<count; i++)
      list.add(Bell.fromMap(MapList[i]));
    return list;
  }

  Future<int> updateBell(Bell item) async
  {
    var db = await this.database;
    var result = await db.update(bells, item.toMap(), where: '$id = ?',whereArgs: [item.id]);
    return result;
  }

  Future <int> insertBell(Bell item) async {
    Database db = await this.database;
    var result = await db.insert(bells, item.toMap());
    return result;
  }

  Future<int> deleteBell(int sid) async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $bells WHERE $id = $sid');
    return result;
  }

  // helper for books

  Future <List<Map<String,dynamic>>> getBooksMapList() async{
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $books');
    return result;
  }

  Future <int> insertBook(Book book) async {
    Database db = await this.database;
    var result = await db.insert(books, book.toMap());
    return result;
  }

  Future<int> deleteBook(String rId) async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $books WHERE $id = "$rId"');
    return result;
  }

  Future<List<Book>> getBooksList() async {
    var bookMapList = await getBooksMapList();
    int count = bookMapList.length;
    List<Book> list = List<Book>();
    for (int i=0; i<count; i++)
      list.add(Book.fromMap(bookMapList[i]));
    return list;
  }

  // helper for hometask
  Future <List<Map<String,dynamic>>> getHometaskMapList() async{
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $hometask');
    return result;
  }

  Future <int> insertHometask(Hometask ht) async {
    Database db = await this.database;
    var result = await db.insert(hometask, ht.toMap());
    return result;
  }

  Future<int> deleteHometask(int rId) async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $hometask WHERE $id = "$rId"');
    return result;
  }

  Future<List<Hometask>> getHometaskList() async {
    var hometaskMapList = await getHometaskMapList();
    int count = hometaskMapList.length;
    List<Hometask> list = List<Hometask>();
    for (int i=0; i<count; i++)
      list.add(Hometask.fromMap(hometaskMapList[i]));
    return list;
  }

  // clear tables

  Future<int> clearBooksTable() async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $books');
    return result;
  }

  Future<int> clearSubjectsTable() async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $subjects');
    return result;
  }

  Future<int> clearMarksTable() async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $marks');
    var result2 = await db.rawUpdate('UPDATE $subjects SET $averageScore = 0.0');
    var result3 = await db.rawUpdate('UPDATE $subjects SET $marksKol = 0');
    return (result);
  }

  Future<int> clearScheduleTable() async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $scheduleitems');
    return result;
  }

  Future<int> clearBellsTable() async
  {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $bells');
    return result;
  }



}