import 'dart:convert';

import 'package:event/event.dart';
import 'package:goald/models/goal.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AbstractGoalService {
  Future<List<Goal>> getGoals();
  void save(Goal goal);
  void delete(Goal goal);
}

class GoalService implements AbstractGoalService {
  final goalChangedEvent = Event<GoalChangedEventArgs>();
  List<Goal> _goalStore;

  @override
  Future<List<Goal>> getGoals() async {
    if (_goalStore == null) {
      final prefs = await _prefs();

      if (prefs.containsKey('goal_store')) {
        _goalStore =
            (jsonDecode(prefs.getString('goal_store')) as List<dynamic>)
                .map((e) => Goal.fromJson(e))
                .toList();
      } else {
        _goalStore = [];
        await updateGoalStore();
      }
    }

    return _goalStore;
  }

  @override
  void save(Goal goal) async {
    _goalStore.add(goal);
    await updateGoalStore();
    goalChangedEvent.broadcast(GoalChangedEventArgs(_goalStore));
  }

  @override
  void delete(Goal goal) async {
    _goalStore.remove(goal);
    await updateGoalStore();
    goalChangedEvent.broadcast(GoalChangedEventArgs(_goalStore));
  }

  Future updateGoalStore() async {
    final prefs = await _prefs();
    return prefs.setString('goal_store', jsonEncode(_goalStore));
  }

  Future<SharedPreferences> _prefs() async {
    return SharedPreferences.getInstance();
  }
}

class GoalChangedEventArgs extends EventArgs {
  List<Goal> changedValue;

  GoalChangedEventArgs(this.changedValue);
}
