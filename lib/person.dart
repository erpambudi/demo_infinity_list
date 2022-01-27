class DataResponse {
  int? userId;
  int? id;
  String? title;
  String? body;

  DataResponse({this.userId, this.id, this.title, this.body});

  DataResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }
}
