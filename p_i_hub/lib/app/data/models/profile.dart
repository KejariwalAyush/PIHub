// To parse this JSON data, do
//
//     final profile = profileFromMap(jsonString);

import 'dart:convert';

class Profile {
  Profile({
    required this.id,
    required this.name,
    required this.username,
    required this.imgUrl,
    required this.email,
    required this.hashtags,
    required this.links,
    this.private = false,
    required this.followers,
    required this.following,
    required this.languages,
    required this.saved,
    required this.liked,
    required this.projects,
    required this.ideas,
  });

  final String id;
  final String name;
  final String username;
  final String imgUrl;
  final String email;
  List<String> hashtags;
  final bool private;
  List<String> links;
  final List<String> followers;
  final List<String> following;
  List<String> languages;
  final PICombo saved;
  final PICombo liked;
  final List<String> projects;
  final List<String> ideas;

  factory Profile.fromJson(String str) => Profile.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        username: json["username"] == null ? null : json["username"],
        imgUrl: json["imgUrl"] == null
            ? "https://www.pctonics.com/blog/Content/Blog/images/Dummy-Profile.png"
            : json["imgUrl"],
        email: json["email"] == null ? null : json["email"],
        hashtags: json["hashtags"] == null
            ? List.empty()
            : List<String>.from(json["hashtags"].map((x) => x)),
        links: json["links"] == null
            ? List.empty()
            : List<String>.from(json["links"].map((x) => x)),
        private: json["private"] == null ? null : json["private"],
        followers: json["followers"] == null
            ? List.empty()
            : List<String>.from(json["followers"].map((x) => x)),
        following: json["following"] == null
            ? List.empty()
            : List<String>.from(json["following"].map((x) => x)),
        languages: json["languages"] == null
            ? List.empty()
            : List<String>.from(json["languages"].map((x) => x)),
        saved: json["saved"] == null
            ? PICombo(ideas: List.empty(), projects: List.empty())
            : PICombo.fromMap(json["saved"]),
        liked: json["liked"] == null
            ? PICombo(ideas: List.empty(), projects: List.empty())
            : PICombo.fromMap(json["liked"]),
        projects: json["projects"] == null
            ? List.empty()
            : List<String>.from(json["projects"].map((x) => x)),
        ideas: json["ideas"] == null
            ? List.empty()
            : List<String>.from(json["ideas"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "username": username,
        "imgUrl": imgUrl,
        "email": email,
        "hashtags": List<dynamic>.from(hashtags.map((x) => x)),
        "links": List<dynamic>.from(links.map((x) => x)),
        "private": private,
        "followers": List<dynamic>.from(followers.map((x) => x)),
        "following": List<dynamic>.from(following.map((x) => x)),
        "languages": List<dynamic>.from(languages.map((x) => x)),
        "saved": saved.toMap(),
        "liked": liked.toMap(),
        "projects": List<dynamic>.from(projects.map((x) => x)),
        "ideas": List<dynamic>.from(ideas.map((x) => x)),
      };
}

class PICombo {
  PICombo({
    required this.ideas,
    required this.projects,
  });

  factory PICombo.empty() => PICombo(ideas: [], projects: []);

  final List<String> ideas;
  final List<String> projects;

  factory PICombo.fromJson(String str) => PICombo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PICombo.fromMap(Map<String, dynamic> json) => PICombo(
        ideas: json["ideas"] == null
            ? List.empty()
            : List<String>.from(json["ideas"].map((x) => x)),
        projects: json["projects"] == null
            ? List.empty()
            : List<String>.from(json["projects"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "ideas": List<dynamic>.from(ideas.map((x) => x)),
        "projects": List<dynamic>.from(projects.map((x) => x)),
      };
}
