class FeedBackModel {
  String title;
  String email;
  String content;
  FeedBackModel({
    required this.title,
    required this.email,
    required this.content,
  });
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'email': email,
      'content': content,
    };
  }
}
