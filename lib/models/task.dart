import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  String id;
  String title;
  String description;
  // timestamp because  the users device date might be incorrect
  Timestamp completedAt;

  bool get isTaskCompleted => completedAt != null;

  TaskModel({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.completedAt,
  });

  TaskModel copyWith({
    String id,
    String title,
    String description,
    Timestamp completedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': Uuid().v4(),
      'title': title,
      'description': description,
      'completedAt': completedAt,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      completedAt: map['completedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        completedAt.hashCode;
  }
}
