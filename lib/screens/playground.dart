
import 'package:collection/collection.dart';


main(List<String> args) {
  var humans = [
    Human(name: "A", grade: 1),
    Human(name: "B", grade: 2),
    Human(name: "C", grade: 2),
    Human(name: "D", grade: 1),
    Human(name: "E", grade: 3),
    Human(name: "F", grade: 3),
  ];
  Map grouped = groupBy(humans,(Human elemen){
    return elemen.grade;
  });

  // grouped.forEach((key, List<String> value) {value.forEach()});
}

class Human{
  String name;
  int grade;
  Human({this.name, this.grade});
}