
class Subject{
  int id;
  String name;
  double averageMark;
  int marksKol;
  Subject({this.id, this.name, this.averageMark, this.marksKol});



  factory Subject.fromMap(Map <String, dynamic> json) => Subject(
    id: json['id'],
    name: json['name'],
    averageMark : json['averageMark'],
    marksKol: json['marksKol']
  );

  Map <String, dynamic> toMap(){
    return{
      'name' : name,
      'averageMark' : averageMark,
      'marksKol' : marksKol
    };
  }
}

