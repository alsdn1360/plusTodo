class Todo {
  String title;
  String content;
  double urgency;
  double importance;
  bool isDone;

  Todo({
    required this.title,
    required this.content,
    required this.urgency,
    required this.importance,
    required this.isDone,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'urgency': urgency,
        'importance': importance,
        'isDone': isDone,
      };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json['title'],
        content: json['content'],
        urgency: json['urgency'],
        importance: json['importance'],
        isDone: json['isDone'],
      );
}
