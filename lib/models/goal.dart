import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goald/models/milestone.dart';

class Goal {
  String title;
  String goal;
  String endDate;
  bool complete;
  List<Milestone> milestones;

  Goal(
      {@required this.title,
      this.goal,
      this.endDate,
      this.milestones,
      this.complete = false});

  Map<String, dynamic> toJson() {
    return {
      't': title,
      'g': goal,
      'e': endDate,
      'c': complete,
      'm': jsonEncode(milestones.map((e) => e.toJson()).toList())
    };
  }

  Goal.fromJson(Map<String, dynamic> json)
      : title = json['t'],
        goal = json['g'],
        endDate = json['e'],
        complete = json['c'],
        milestones = (jsonDecode(json['m']) as List<dynamic>)
            .map((e) => Milestone.fromJson(e))
            .toList();
}
