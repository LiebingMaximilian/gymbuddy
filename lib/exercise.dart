class Exercise {
  String? name;
  double weight;
  int reps;
  int sets;

  Exercise(this.name, this.weight, this.reps, this.sets);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'reps': reps,
      'sets': sets,
    };
  }

  // Convert JSON to Exercise object
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      json['name'] as String?,
      json['weight'] as double,
      json['reps'] as int,
      json['sets'] as int,
    );
  }
}