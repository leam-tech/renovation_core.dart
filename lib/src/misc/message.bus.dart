import 'package:rxdart/rxdart.dart';

/// Class for handling the Message Bus used in the front-end mostly
class MessageBus {
  /// Map holding the buses with a String id as key and the [BehaviorSubject] as value.
  final Map<String, BehaviorSubject<dynamic>> _buses = {};

  /// Post message onto a bus with [id].
  ///
  /// If the id is not defined, the function exits by returning.
  void post(String id, dynamic data) {
    if (!_buses.containsKey(id)) return;

    _buses[id]!.add(data);
  }

  /// Returns the stream of a certain [id].
  ///
  /// If there's no stream [BehaviorSubject] defined for [id], a new [BehaviorSubject] is created and assigned.
  ///
  /// In all cases a [BehaviorSubject] is returned.
  BehaviorSubject<dynamic>? getSubject(String id) {
    _buses[id] ??= BehaviorSubject<dynamic>();
    return _buses[id];
  }
}
