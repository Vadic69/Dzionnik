class ScheduleItem{
  int weekday;
  String name;
  int id;

  ScheduleItem({this.weekday, this.name, this.id});

  factory ScheduleItem.fromMap(Map <String,dynamic> json) => ScheduleItem(
    weekday: json['weekday'],
    name: json['name'],
    id: json['id'],
  );

  Map<String, dynamic> toMap(){
    return {
      'weekday' : weekday,
      'name' : name,
    };
  }
}