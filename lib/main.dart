import 'package:flutter/material.dart';
import 'package:gymbuddy/storeDays.dart';
import 'Day.dart';
import 'exercise.dart';
import 'DaysDetailsPage.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gymbuddy',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow.shade300),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'WorkoutPlan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Day> days = [];

  @override
  void initState() {
    super.initState();
    // Load data from SharedPreferences when the widget is initialized
    _loadDays();
  }

  // Asynchronous function to load days from SharedPreferences
  Future<void> _loadDays() async {
    List<Day> loadedDays = await loadDays(); // Load days from SharedPreferences
    setState(() {
      days = loadedDays; // Update the state with the loaded days
    });
  }

  void addDay(Day day) {
    setState(() => days.add(day));
    saveDays(days); // Save the updated days list to SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly, // Evenly distribute space
                    children: days.asMap().entries.map((entry) {
                      int index = entry.key; // Index of the day
                      Day d = entry.value; // The actual Day object

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0), // Add spacing
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Space between buttons
                            children: [
                              // Navigate Button
                              Expanded(
                                child: DayButton(context, index, d),
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
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDayDialog(context),
        tooltip: 'Add day',
        child: const Icon(Icons.add),
      ),
    );
  }

  ElevatedButton DayButton(BuildContext context, int index, Day d) {
    return ElevatedButton(
      onLongPress: () => showDeleteDialog(context, index),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DayDetailsPage(day: d),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow.shade300, // Button color
        minimumSize: Size(250, 50),
        maximumSize: Size(250, 100), // Button size
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(children: [
        Text(
          'Day ${index + 1}',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        Text(
          '${d.name}',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ]),
    );
  }

  void _showAddDayDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Day Name'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Day Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String dayName = _controller.text.trim();
                if (dayName.isNotEmpty) {
                  addDay(Day(dayName, [])); // Add new day with entered name
                }
                Navigator.pop(context); // Close dialog after adding
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                this.days.removeAt(index);
                saveDays(
                    days); // Save the updated days list to SharedPreferences
                setState(() {});
                Navigator.of(dialogContext).pop(); // Close dialog
                // Code to delete the item should be implemented by the caller
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
