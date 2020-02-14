
class Mark{
  int value;
  int markId;
  int subjectId;

  Mark({this.value, this.markId, this.subjectId});

  factory Mark.fromMap(Map <String, dynamic> json) => Mark(
    value: json['value'],
    markId: json['markId'],
    subjectId: json['subjectId'],
  );


  Map <String, dynamic> toMap(){
    return{
      'value' : value,
      'subjectId' : subjectId,
    };
  }
}