import './exercise.dart';
import 'dart:convert';

class Day {
  String name;
  List<Exercise> exercises;
  Day(this.name, this.exercises);

  // Convert Day to JSON (map)
  Map<String, dynamic> toJson() => {
        'name': name,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  // Convert JSON to Day object
factory Day.fromJson(Map<String, dynamic> json) {
  return Day(
    json['name'] as String,
    (json['exercises'] as List)  // Cast to List
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))  // Map each element to an Exercise
        .toList(),  // Convert to a List
  );
}

}