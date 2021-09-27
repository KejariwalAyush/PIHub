// To parse this JSON data, do
//
//     final project = projectFromMap(jsonString);

import 'dart:convert';

import 'comment.dart';

class Project {
  Project({
    required this.id,
    required this.title,
    required this.desc,
    required this.hashtags,
    required this.dateTime,
    required this.username,
    this.projectLink,
    this.productLink,
    required this.languages,
    required this.views,
    required this.comments,
    required this.likes,
    required this.screenshots,
  });

  final String id;
  final String title;
  final String desc;
  final List<String> hashtags;
  final String username;
  final String? projectLink;
  final String? productLink;
  final List<String> languages;
  final List<String> views;
  final List<String>? screenshots;
  final List<Comment> comments;
  final DateTime dateTime;
  int likes;

  factory Project.fromJson(String str) => Project.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Project.fromMap(Map<String, dynamic> json) => Project(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        likes: json['likes'] ?? 0,
        desc: json["desc"] == null ? null : json["desc"],
        hashtags: json["hashtags"] == null
            ? List<String>.empty()
            : List<String>.from(json["hashtags"].map((x) => x)),
        username: json["username"] == null ? null : json["username"],
        dateTime: json["dateTime"] == null
            ? DateTime.now()
            : DateTime.parse(json["dateTime"]),
        projectLink: json["projectLink"] == null ? null : json["projectLink"],
        productLink: json["productLink"] == null ? null : json["productLink"],
        languages: json["languages"] == null
            ? List<String>.empty()
            : List<String>.from(json["languages"].map((x) => x)),
        views: json["views"] == null
            ? List<String>.empty()
            : List<String>.from(json["views"].map((x) => x)),
        screenshots: json["screenshots"] == null
            ? null
            : List<String>.from(json["screenshots"].map((x) => x)),
        comments: json["comments"] == null
            ? List<Comment>.empty()
            : List<Comment>.from(
                json["comments"].map((x) => Comment.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "likes": likes,
        "desc": desc,
        "hashtags": List<dynamic>.from(hashtags.map((x) => x)),
        "username": username,
        "dateTime": dateTime.toIso8601String(),
        "projectLink": projectLink,
        "productLink": productLink,
        "languages": List<dynamic>.from(languages.map((x) => x)),
        "views": List<dynamic>.from(views.map((x) => x)),
        "screenshots": List<dynamic>.from(screenshots!.map((x) => x)),
        "comments": List<dynamic>.from(comments.map((x) => x.toMap())),
      };
}
