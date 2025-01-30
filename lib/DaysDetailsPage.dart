import 'package:gymbuddy/storeDays.dart';

import 'Day.dart';
import 'exercise.dart';
import 'package:flutter/material.dart';

class DayDetailsPage extends StatefulWidget {
  final Day day;
  bool showDeleteButtons = true;
  DayDetailsPage({Key? key, required this.day, this.showDeleteButtons = true})
      : super(key: key);

  @override
  State<DayDetailsPage> createState() => _DayDetailsPageState();
}

class _DayDetailsPageState extends State<DayDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.day.name),
          backgroundColor: Colors.yellow.shade300,
          shadowColor: Colors.yellow.shade600),
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Evenly distribute space
                  children: widget.day.exercises.asMap().entries.map((entry) {
                    int index = entry.key; // Index of the day
                    Exercise e = entry.value; // The actual Day object

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0), // Add spacing
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Space between buttons
                          children: [
                            // Navigate Button
                            ExerciseButton(context, e, index),

                            SizedBox(width: 10), // Space between buttons

                            // Delete Button
                            if (widget.showDeleteButtons)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    showEditExerciseDialog(context, e, index);
                                  });
                                },
                                icon: Icon(Icons.edit, color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(), // Convert map results to a list
                ),
              ),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExerciseDialog(context),
        tooltip: 'Add day',
        child: const Icon(Icons.add),
      ),
    );
  }

  Expanded ExerciseButton(BuildContext context, Exercise e, int index) {
    return Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  showEditExerciseDialog(context, e, index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.yellow.shade300, // Button color
                                minimumSize: Size(250, 50),
                                maximumSize: Size(250, 100), // Button size
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Column(children: [
                                Text(
                                  '${e.name}',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                  Text(
                                    '${e.weight} kg',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  Text(
                                    '${e.reps} reps',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  Text(
                                    '${e.sets} sets',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ])
                              ]),
                            ),
                          );
  }

  void _showAddExerciseDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController repsController = TextEditingController();
    TextEditingController setsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Exercise Name Input
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Exercise Name'),
              ),

              // Weight Input
              TextField(
                controller: weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),

              // Reps Input
              TextField(
                controller: repsController,
                decoration: InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
              ),

              // Sets Input
              TextField(
                controller: setsController,
                decoration: InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('Cancel'),
            ),

            // Add Button
            ElevatedButton(
              onPressed: () {
                String name = nameController.text.trim();
                double? weight = double.tryParse(weightController.text);
                int? reps = int.tryParse(repsController.text);
                int? sets = int.tryParse(setsController.text);

                // Validate input
                if (name.isEmpty ||
                    weight == null ||
                    reps == null ||
                    sets == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter valid values')),
                  );
                  return;
                }

                // Create Exercise object
                Exercise newExercise = Exercise(name, weight, reps, sets);

                // Call callback function to add exercise
                widget.day.exercises.add(newExercise);

                saveDay(widget.day); // Save the updated day

                // Close dialog
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showEditExerciseDialog(
      BuildContext context, Exercise exercise, int index) {
    TextEditingController nameController =
        TextEditingController(text: exercise.name);
    TextEditingController weightController =
        TextEditingController(text: exercise.weight.toString());
    TextEditingController repsController =
        TextEditingController(text: exercise.reps.toString());
    TextEditingController setsController =
        TextEditingController(text: exercise.sets.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Exercise Name Input
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Exercise Name'),
              ),

              // Weight Input
              TextField(
                controller: weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),

              // Reps Input
              TextField(
                controller: repsController,
                decoration: InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
              ),

              // Sets Input
              TextField(
                controller: setsController,
                decoration: InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('Cancel'),
            ),

            // Save Button
            ElevatedButton(
              onPressed: () {
                String name = nameController.text.trim();
                double? weight = double.tryParse(weightController.text);
                int? reps = int.tryParse(repsController.text);
                int? sets = int.tryParse(setsController.text);

                // Validate input
                if (name.isEmpty ||
                    weight == null ||
                    reps == null ||
                    sets == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter valid values')),
                  );
                  return;
                }

                // Update Exercise object
                exercise.name = name;
                exercise.weight = weight;
                exercise.reps = reps;
                exercise.sets = sets;

                // Call callback function to update exercise
                widget.day.exercises[index] = exercise;

                // After editing, save the updated day
                saveDay(widget.day); // Save the updated day
                // Close dialog
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
  // This method should save the updated day list (widget.day) to SharedPreferences
  void saveDay(Day updatedDay) async {
    // Retrieve the current list of days from SharedPreferences or local storage
    List<Day> currentDays = await loadDays();

    // Update the current day in the list
    int index = currentDays.indexWhere((day) => day.name == updatedDay.name);
    if (index != -1) {
      currentDays[index] = updatedDay; // Replace the old day with the updated one
    }

    // Save the updated list of days back to SharedPreferences
    saveDays(currentDays);
  }


}
