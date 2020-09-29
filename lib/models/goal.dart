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

  Goal({
    this.id,
    @required this.title,
    this.description,
    this.endDate,
    this.milestones,
    this.complete = false,
    this.dateCompleted,
  });

  static Goal fromSnapshot(QueryDocumentSnapshot docSnapshot) {
    return Goal(
        id: docSnapshot.id,
        title: docSnapshot.get('title'),
        description: docSnapshot.get('goal'),
        endDate: (docSnapshot.get('end_date') as Timestamp).toDate(),
        complete: docSnapshot.get('complete'),
        dateCompleted: docSnapshot.get('end_date') != null
            ? (docSnapshot.get('end_date') as Timestamp).toDate()
            : null,
        milestones: (docSnapshot.get('milestones') as List<dynamic>)
            .map((e) =>
                Milestone(done: e['done'], description: e['description']))
            .toList());
  }
}
