import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class EventEmitter {

  List<Subscriber> _subscribers = <Subscriber>[];

  VoidCallback subscribe(Function callback) {
    final id = Uuid().v4();
    _subscribers.add(Subscriber(id: id, callback: callback));
    return () => _unsubscribe(id);
  }

  void _unsubscribe(String id) {
    _subscribers.removeWhere((sub) => sub.id == id);
  }

  void emit() {
    _subscribers.forEach((subscriber) => subscriber.callback());
  }

  void destroy() {
    _subscribers.forEach((element) => _unsubscribe(element.id));
  }

}

class Subscriber {
  String id;
  Function callback;

  Subscriber({this.id, this.callback});
}