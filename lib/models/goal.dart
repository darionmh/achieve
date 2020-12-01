import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goald/models/milestone.dart';

class Goal {
  String id;
  String title;
  String description;
  DateTime endDate;
  bool complete;
  DateTime dateCompleted;
  List<Milestone> milestones;
  Color theme;

  Goal(
      {this.id,
      @required this.title,
      this.description,
      this.endDate,
      this.milestones,
      this.complete = false,
      this.dateCompleted,
      this.theme});

  static Goal fromSnapshot(QueryDocumentSnapshot docSnapshot) {
    var goal = Goal(
      id: docSnapshot.reference.id,
      title: docSnapshot.get('title'),
      description: docSnapshot.get('goal'),
      endDate: (docSnapshot.get('end_date') as Timestamp).toDate(),
      complete: docSnapshot.get('complete'),
      dateCompleted: docSnapshot.get('date_completed') != null
          ? (docSnapshot.get('date_completed') as Timestamp).toDate()
          : null,
      milestones: (docSnapshot.get('milestones') as List<dynamic>)
          .map((e) => Milestone(done: e['done'], description: e['description']))
          .toList(),
      theme: Color(docSnapshot.get('theme')),
    );
    return goal;
  }

  @override
  String toString() {
    return '{title: $title, description: $description, endDate: $endDate, milestones: $milestones, complete: $complete, dateComplete: $dateCompleted, id: $id}';
  }
}
