class Bell{
  int begin;
  int end;
  int id;

  Bell({this.begin, this.end, this.id});

  factory Bell.fromMap(Map<String, dynamic> json) => Bell(
    begin : json['begin'],
    end : json['end'],
    id : json['id'],
  );

  Map<String, dynamic> toMap(){
    return {
      'begin' : begin,
      'end' : end,
    };
  }
}