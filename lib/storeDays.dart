import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Day.dart';

// Save days list to shared preferences
Future<void> saveDays(List<Day> days) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> jsonDays = days.map((day) => json.encode(day.toJson())).toList();
  await prefs.setStringList('days', jsonDays); // Save the list of JSON strings
}


Future<List<Day>> loadDays() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonDays = prefs.getStringList('days'); // Get the stored JSON list

  if (jsonDays == null) {
    return []; // Return an empty list if no data is found
  }

  // Convert each JSON string back to a Day object
  List<Day> days = jsonDays.map((jsonStr) {
    return Day.fromJson(json.decode(jsonStr)); // Decode and create Day object
  }).toList();

  return days;
}
