class Note {
  int? id;
  String title;
  String description;
  int color;
  DateTime createdAt;
  bool isPinned;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.createdAt,
    required this.isPinned,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'color': color,
    'createdAt': createdAt.toIso8601String(),
    'isPinned': isPinned ? 1 : 0,
  };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    color: map['color'],
    createdAt: DateTime.parse(map['createdAt']),
    isPinned: map['isPinned'] == 1,
  );
}
