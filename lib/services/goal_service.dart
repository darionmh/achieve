import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:goald/home/goal_list.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/models/milestone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';

abstract class AbstractGoalService {
  StreamBuilder<QuerySnapshot> getGoals();
  Future<void> add(Goal goal);
  Future<void> delete(Goal goal);
  Future<void> update(Goal goal);
}

class GoalStore implements AbstractGoalService {
  AbstractAuthService _authService;
  FirebaseFirestore firestore;
  FirebaseAnalytics analytics;

  GoalStore() {
    _authService = locator<AbstractAuthService>();
    firestore = FirebaseFirestore.instance;
    analytics = FirebaseAnalytics();
  }

  @override
  Future<void> add(Goal goal) {
    return firestore
        .collection('user')
        .doc(_authService.getUser().uid)
        .collection('goals')
        .add(_mapGoalToObj(goal))
        .catchError((err) => analytics.logEvent(name: 'add_goal_failed'))
        .then((value) => analytics.logEvent(name: 'add_goal_succeeded'));
  }

  @override
  Future<void> delete(Goal goal) {
    return firestore
        .collection('user')
        .doc(_authService.getUser().uid)
        .collection('goals')
        .doc(goal.id)
        .delete()
        .catchError((err) => analytics.logEvent(name: 'delete_goal_failed'))
        .then((value) => analytics.logEvent(name: 'delete_goal_succeeded'));
    ;
  }

  @override
  StreamBuilder<QuerySnapshot> getGoals() {
    CollectionReference goals = FirebaseFirestore.instance
        .collection('user')
        .doc(_authService.getUser().uid)
        .collection('goals');

    return StreamBuilder<QuerySnapshot>(
      stream: goals.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return GoalList(
          goalList: snapshot.data.docs.map(
            (QueryDocumentSnapshot docSnapshot) {
              return Goal(
                  id: docSnapshot.id,
                  title: docSnapshot.get('title'),
                  goal: docSnapshot.get('goal'),
                  endDate: docSnapshot.get('end_date'),
                  complete: docSnapshot.get('complete'),
                  milestones: (docSnapshot.get('milestones') as List<dynamic>)
                      .map((e) => Milestone.fromJson(e))
                      .toList());
            },
          ).toList(),
        );
      },
    );
  }

  @override
  Future<void> update(Goal goal) {
    firestore
        .collection('user')
        .doc(_authService.getUser().uid)
        .collection('goals')
        .doc(goal.id)
        .update(_mapGoalToObj(goal))
        .catchError((err) => analytics.logEvent(name: 'update_goal_failed'))
        .then((value) => analytics.logEvent(name: 'update_goal_succeeded'));
    ;
  }

  dynamic _mapGoalToObj(Goal goal) {
    return {
      'title': goal.title,
      'goal': goal.goal,
      'end_date': goal.endDate,
      'complete': goal.complete,
      'milestones': goal.milestones.map((e) => e.toJson()).toList(),
    };
  }
}
