import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:goald/event_emitter.dart';
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

  List<Goal> getAllGoals();
  List<Goal> getUpcomingGoals();
  List<Goal> getOverdueGoals();
  List<Goal> getRecentlyCompletedGoals();
  List<Milestone> getMilestonesForGoal(Goal goal);
  Future<void> initData();
  EventEmitter getStoreUpdateEvent();
}

class GoalStore implements AbstractGoalService {
  AbstractAuthService _authService;
  FirebaseFirestore firestore;
  FirebaseAnalytics analytics;
  EventEmitter _storeUpdateEvent;

  List<Goal> _store;

  GoalStore() {
    _authService = locator<AbstractAuthService>();
    firestore = FirebaseFirestore.instance;
    analytics = FirebaseAnalytics();
    _storeUpdateEvent = EventEmitter();
  }

  EventEmitter getStoreUpdateEvent(){
    return _storeUpdateEvent;
  }

  Future<void> initData() async {
    var res = await _goalCollection().get();
    _store = (res.docs == null ? [] : res.docs).map((e) => Goal.fromSnapshot(e)).toList();
    print('done initing data');
  }

  @override
  List<Goal> getAllGoals() {
    return _store;
  }

  @override
  List<Goal> getOverdueGoals() {
    return _store.where((element) => element.complete == false
        && element.endDate.isBefore(DateTime.now())
    ).toList();
  }

  @override
  List<Goal> getUpcomingGoals() {
    return _store.where((element) => element.complete == false
        && element.endDate.isAfter(DateTime.now())
        && element.endDate.isBefore(DateTime.now().add(Duration(days: 30)))
    ).toList();
  }

  @override
  List<Goal> getRecentlyCompletedGoals() {
    return _store.where((element) => element.complete == true
        && element.dateCompleted != null
        && element.dateCompleted.isAfter(DateTime.now().subtract(Duration(days: 30)))
    ).toList();
  }

  @override
  List<Milestone> getMilestonesForGoal(Goal goal) {
    return _store.firstWhere((element) => element.id == goal.id).milestones;
  }

  @override
  Future<void> add(Goal goal) {
    _store.add(goal);
    _storeUpdateEvent.emit();

    return _goalCollection()
        .add(_mapGoalToObj(goal))
        .catchError((err) => analytics.logEvent(name: 'add_goal_failed'))
        .then((value) => analytics.logEvent(name: 'add_goal_succeeded'));
  }

  @override
  Future<void> delete(Goal goal) {
    _store.remove(goal);
    _storeUpdateEvent.emit();

    return _goalCollection()
        .doc(goal.id)
        .delete()
        .catchError((err) => analytics.logEvent(name: 'delete_goal_failed'))
        .then((value) => analytics.logEvent(name: 'delete_goal_succeeded'));
  }

  @override
  Future<void> update(Goal goal) {
    int index = _store.indexWhere((element) => element.id == goal.id);
    _store.removeAt(index);
    _store.insert(index, goal);
    _storeUpdateEvent.emit();

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
      'theme': goal.theme.value
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
