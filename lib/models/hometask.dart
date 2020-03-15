import 'package:firebase_database/firebase_database.dart';

class Hometask{
  bool answered;
  String author_id;
  String id;
  bool this_week;
  int weekday;
  String author;
  String subject;
  String value;
  String class_id;

  Hometask({this.author, this.weekday, this.subject, this.value, this.class_id, this.this_week, this.id, this.author_id, this.answered});

  factory Hometask.fromSnapshot(DataSnapshot snapshot) => Hometask(
    author: snapshot.value['author'],
    subject: snapshot.value['subject'],
    value: snapshot.value['value'],
    weekday: snapshot.value['weekday'],
    class_id: snapshot.value['class_id'],
    this_week: snapshot.value['this_week'],
    author_id: snapshot.value['author_id'],
    answered: snapshot.value['answered'],
    id: snapshot.key
  );


  toJson(){
    return{
      'answered' : answered,
      'weekday' : weekday,
      'author' : author,
      'subject' : subject,
      'value' : value,
      'class_id' : class_id,
      'this_week' : this_week,
      'author_id' : author_id
    };
  }
}