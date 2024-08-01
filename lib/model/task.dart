class Task {
  final String name;
  bool isDone;

  Task({
    required this.name,
    this.isDone = false,
  });

  void toggleDone() {
    isDone = !isDone;
  }

  // Convert a Task to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isDone': isDone,
    };
  }

  // Create a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      name: map['name'],
      isDone: map['isDone'],
    );
  }
}
