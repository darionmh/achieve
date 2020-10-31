import 'package:uuid/uuid.dart';

class EventEmitter {

  List<Subscriber> _subscribers = <Subscriber>[];

  String subscribe(Function callback) {
    final id = Uuid().v4();
    _subscribers.add(Subscriber(id: id, callback: callback));
    return id;
  }

  void unsubscribe(String id) {
    _subscribers.removeWhere((sub) => sub.id == id);
  }

  void emit() {
    _subscribers.forEach((subscriber) => subscriber.callback());
  }

}

class Subscriber {
  String id;
  Function callback;

  Subscriber({this.id, this.callback});
}