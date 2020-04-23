class Hometask{
  String dateTime;
  String subject;
  String value;
  int id;

  Hometask({this.id, this.dateTime, this.subject, this.value});

  factory Hometask.fromMap(Map <String, dynamic> json) => Hometask(
    value: json['value'],
    dateTime: json['dateTime'],
    subject: json['subject'],
    id: json['id']
  );


  Map <String, dynamic> toMap(){
    return{
      'value' : value,
      'dateTime' : dateTime,
      'subject' : subject
    };
  }
}