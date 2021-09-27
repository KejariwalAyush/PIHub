import 'dart:convert';

class Comment {
  Comment(
      {required this.id,
      required this.userName,
      required this.comment,
      required this.dateTime});

  final String id;
  final String userName;
  final String comment;
  final DateTime dateTime;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'comment': comment,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userName: map['userName'],
      comment: map['comment'],
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));
}
