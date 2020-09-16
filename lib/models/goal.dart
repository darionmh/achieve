import 'package:goald/models/milestone.dart';

class Goal {
  String title;
  String goal;
  String endDate;
  bool complete;
  List<Milestone> milestones;

  Goal({this.title, this.goal, this.endDate, this.milestones, this.complete = false});
}