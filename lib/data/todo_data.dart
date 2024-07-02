class TodoData {
  String title;
  String content;
  double urgency;
  double importance;
  bool isDone;

  TodoData({
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

  factory TodoData.fromJson(Map<String, dynamic> json) => TodoData(
        title: json['title'],
        content: json['content'],
        urgency: json['urgency'],
        importance: json['importance'],
        isDone: json['isDone'],
      );
}
