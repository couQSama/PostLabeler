class Comment{
  String content;
  int? label;
  List<dynamic>? comments;
  List<int>? index;

  Comment({required this.content, required this.label, this.comments, this.index});

  factory Comment.fromJson(Map<String, dynamic> json, List<int>? index){
    return Comment(
      content: json['content'],
      label: json['label'],
      comments: json.containsKey('comments') ? json['comments'] : null,
      index: index
    );
  }
}