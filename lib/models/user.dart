class User{
  String id;
  String name;
  String surname;
  String grade_id;
  String email;
  String password;

  User({this.email, this.password, this.grade_id, this.surname, this.name, this.id});

  User.fromMap(Map snapshot, String id):
    id = id,
    name = snapshot["name"],
    surname = snapshot["surname"],
    grade_id = snapshot["grade_id"];

  toJson(){
    return {
      "name" : name,
      "surname" : surname,
      "grade_id" : grade_id
    };
  }
}