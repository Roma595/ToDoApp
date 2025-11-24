class Task {
  final String id;
  String title;
  DateTime date;
  String category;
  String notes;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.category,
    this.notes = '',
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'category': category,
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      category: map['category'],
      notes: map['notes'],
      isCompleted: map['isCompleted'],
    );
  }

  Task copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? category,
    String? notes,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}