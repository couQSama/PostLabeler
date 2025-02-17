class Comment{
  String content;
  String? summary;
  int? label;
  List<dynamic>? comments;
  List<int>? index;

  Comment({required this.content, required this.summary,required this.label, this.comments, this.index});

  factory Comment.fromJson(Map<String, dynamic> json, List<int>? index){
    return Comment(
      content: json['content'],
      summary: json['summary'],
      label: json['label'],
      comments: json.containsKey('comments') ? json['comments'] : null,
      index: index
    );
  }
}