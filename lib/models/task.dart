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
  // if task is created completed
  final bool isCompleted;
  bool get isTaskCompleted => completedAt != null;

  TaskModel({
    this.id,
    @required this.title,
    @required this.isCompleted,
    @required this.description,
    this.completedAt,
  }) {
    id = id ?? Uuid().v4();
  }

  TaskModel copyWith({
    String id,
    String title,
    String description,
    Timestamp completedAt,
    bool isCompleted
  }) {
    return TaskModel(
      id: id ?? this.id,
      isCompleted: isCompleted,
      title: title ?? this.title,
      description: description ?? this.description,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completedAt': isCompleted ? Timestamp.now() : null,
      "isCompleted": isCompleted
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        completedAt: map['completedAt'],
        isCompleted: map["isCompleted"]);
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
