import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/models/milestone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';

abstract class AbstractGoalService {
  Future<void> add(Goal goal);
  Future<void> delete(Goal goal);
  Future<void> update(Goal goal);
  Stream<List<Goal>> allGoals();
  Stream<List<Goal>> upcomingGoals();
  Stream<List<Goal>> recentlyCompleted();
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
    return _goalCollection()
        .add(_mapGoalToObj(goal))
        .catchError((err) => analytics.logEvent(name: 'add_goal_failed'))
        .then((value) => analytics.logEvent(name: 'add_goal_succeeded'));
  }

  @override
  Future<void> delete(Goal goal) {
    return _goalCollection()
        .doc(goal.id)
        .delete()
        .catchError((err) => analytics.logEvent(name: 'delete_goal_failed'))
        .then((value) => analytics.logEvent(name: 'delete_goal_succeeded'));
  }

  @override
  Future<void> update(Goal goal) {
    return _goalCollection()
        .doc(goal.id)
        .update(_mapGoalToObj(goal))
        .catchError((err) => analytics.logEvent(name: 'update_goal_failed'))
        .then((value) => analytics.logEvent(name: 'update_goal_succeeded'));
    ;
  }

  dynamic _mapGoalToObj(Goal goal) {
    return {
      'title': goal.title,
      'goal': goal.description,
      'end_date': Timestamp.fromDate(goal.endDate),
      'complete': goal.complete,
      'date_completed': goal.dateCompleted != null
          ? Timestamp.fromDate(goal.dateCompleted)
          : null,
      'milestones': goal.milestones.map((e) => _mapMilestoneToObj(e)).toList(),
    };
  }

  dynamic _mapMilestoneToObj(Milestone milestone) {
    return {
      'done': milestone.done,
      'description': milestone.description,
    };
  }

  @override
  Stream<List<Goal>> allGoals() {
    return _goalCollection().snapshots().map((event) => event.docs == null
        ? []
        : event.docs.map((e) => Goal.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<Goal>> upcomingGoals() {
    return _goalCollection()
        .where(
          'end_date',
          isLessThanOrEqualTo: Timestamp.fromDate(
            DateTime.now().add(
              Duration(days: 30),
            ),
          ),
        )
        .where('complete', isEqualTo: false)
        .snapshots()
        .map((event) => event.docs == null
            ? []
            : event.docs.map((e) => Goal.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<Goal>> recentlyCompleted() {
    return _goalCollection()
        .where(
          'date_completed',
          isGreaterThanOrEqualTo: Timestamp.fromDate(
            DateTime.now().subtract(
              Duration(days: 30),
            ),
          ),
        )
        .where('complete', isEqualTo: true)
        .snapshots()
        .map((event) => event.docs == null
            ? []
            : event.docs.map((e) => Goal.fromSnapshot(e)).toList());
  }

  Future<int> dashboardStats() async {
    int thirtyDays = await _goalCollection().where('complete', isEqualTo: true).where(
      'date_completed',
      isGreaterThanOrEqualTo: Timestamp.fromDate(
        DateTime.now().subtract(
          Duration(days: 30),
        ),
      ),
    ).snapshots().length;

    int twelveMonths = await _goalCollection().where('complete', isEqualTo: true).where(
      'date_completed',
      isGreaterThanOrEqualTo: Timestamp.fromDate(
        DateTime.now().subtract(
          Duration(days: 365),
        ),
      ),
    ).snapshots().length;
  }

  CollectionReference _goalCollection() {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(_authService.getUser().uid)
        .collection('goals');
  }
}
