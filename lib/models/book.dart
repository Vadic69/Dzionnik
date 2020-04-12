import 'package:cloud_firestore/cloud_firestore.dart';

class Book{
  String id, subject, fileName, author;
  int language;
  int form;

  Book({this.id, this.fileName, this.form, this.subject, this.author});


  Book.fromMap(Map snapshot):
    id =  snapshot['id'],
    subject = snapshot['subject'],
    fileName = snapshot['fileName'],
    author = snapshot['author'],
    language = snapshot['language'],
    form = snapshot['form'];

  Book.fromFirestore(DocumentSnapshot snapshot):
    id = snapshot.documentID,
    subject = snapshot.data['subject'],
    fileName = snapshot['fileName'],
    author = snapshot['author'],
    language = snapshot['language'],
    form = snapshot['form'];


  toMap() {
    return {
      'id' : id,
      'subject' : subject,
      'fileName' : fileName,
      'author' : author,
      'language' : language,
      'form' : form,
    };
  }
}