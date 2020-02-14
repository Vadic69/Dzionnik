class Bell{
  int begin;
  int end;
  int order;

  Bell({this.begin, this.end, this.order});

  factory Bell.fromMap(Map<String, dynamic> json) => Bell(
    begin : json['begin'],
    end : json['end'],
    order : json['order'],
  );

  Map<String, dynamic> toMap(){
    return {
      'begin' : begin,
      'end' : end,
      'order' : order
    };
  }
}