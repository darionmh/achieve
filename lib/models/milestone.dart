import 'package:uuid/uuid.dart';

class Milestone {
  final id = Uuid().v4();
  bool done;
  String description;

  Milestone({this.done, this.description});
}
