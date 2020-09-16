import 'package:event/event.dart';
import 'package:goald/models/goal.dart';

abstract class AbstractGoalService {
  Future<List<Goal>> getGoals();
  void save(Goal goal);
}

class GoalService implements AbstractGoalService {
  final goalChangedEvent = Event<GoalChangedEventArgs>();
  List<Goal> _goalStore = [];

  @override
  Future<List<Goal>> getGoals() async {
    return _goalStore;
  }

  @override
  void save(Goal goal) {
    print(goal);
    _goalStore.add(goal);
    goalChangedEvent.broadcast(GoalChangedEventArgs(_goalStore));
  }
}

class GoalChangedEventArgs extends EventArgs {
  List<Goal> changedValue;

  GoalChangedEventArgs(this.changedValue);
}