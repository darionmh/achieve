import 'package:uuid/uuid.dart';

class Milestone {
  final id = Uuid().v4();
  bool done;
  String description;

  Milestone({this.done = false, this.description});

  @override
  String toString() {
    return '{desc: $description, done: $done, id: $id}';
  }
}
