// To parse this JSON data, do
//
//     final idea = ideaFromMap(jsonString);

import 'dart:convert';

import 'comment.dart';

class Idea {
  Idea({
    required this.id,
    required this.title,
    this.link,
    required this.username,
    required this.desc,
    required this.dateTime,
    required this.hashtags,
    required this.likes,
    required this.comments,
    required this.views,
  });

  final String id;
  final String title;
  final String username;
  final String? link;
  final String desc;
  final DateTime dateTime;
  final List<String> hashtags;
  int likes;
  final List<String> views;
  final List<Comment> comments;

  factory Idea.fromJson(String str) => Idea.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Idea.fromMap(Map<String, dynamic> json) => Idea(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        link: json["link"] ?? null,
        username: json["username"] == null ? null : json["username"],
        desc: json["desc"] == null ? null : json["desc"],
        dateTime: json["dateTime"] == null
            ? DateTime.now()
            : DateTime.parse(json["dateTime"]),
        hashtags: json["hashtags"] == null
            ? List<String>.empty()
            : List<String>.from(json["hashtags"].map((x) => x)),
        likes: json['likes'] ?? 0,
        views: json["views"] == null
            ? List<String>.empty()
            : List<String>.from(json["views"].map((x) => x)),
        comments: json["comments"] == null
            ? List<Comment>.empty()
            : List<Comment>.from(
                json["comments"].map((x) => Comment.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "username": username,
        "link": link,
        "desc": desc,
        "dateTime": dateTime.toIso8601String(),
        "hashtags": List<dynamic>.from(hashtags.map((x) => x)),
        "likes": likes,
        "views": List<dynamic>.from(views.map((x) => x)),
        "comments": List<dynamic>.from(comments.map((x) => x.toMap())),
      };
}
