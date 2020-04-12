import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_diary/models/book.dart';

final CollectionReference booksCollection = Firestore.instance.collection('books');

class FirestoreHelper {
  static final FirestoreHelper _instance = new FirestoreHelper.internal();
 
  factory FirestoreHelper() => _instance;
 
  FirestoreHelper.internal();

  Stream<QuerySnapshot> getBooksList() {
    Stream<QuerySnapshot> snapshots = booksCollection.snapshots();
    return snapshots;
  }

}