import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:summit2/models/calendar/calendar_event.dart';

import 'dart:collection';

class EventData extends ChangeNotifier {
  Map<DateTime, List<dynamic>> _events = {};

  UnmodifiableMapView<DateTime, List<dynamic>> get events {
    return UnmodifiableMapView(_events);
  }

  void addEvent(
      {@required String newEventTitle,
      @required DateTime date,
      @required DateTime dateTime}) {

    Event event = Event(
      name: newEventTitle,
      eventDate: date,
      eventDateTime: dateTime,
    );

    if (_events[date] == null) {
      _events[date] = [
        event,
      ];
    } else {
      _events[date].add(event);
    }
    notifyListeners();
  }

  void deleteEvent(Event event) {
    _events[event.eventDate].remove(event);
    notifyListeners();
  }
}

//class EventData extends ChangeNotifier {
//  List<Event> _events = [];
//
//  UnmodifiableListView<Event> get events {
//    return UnmodifiableListView(_events);
//  }
//
//  int get eventCount {
//    return _events.length;
//  }
//
//  void addEvent({String newEventTitle, DateTime date}) {
//    final event = Event(name: newEventTitle, eventDate: date);
//    _events.add(event);
//    notifyListeners();
//  }
//
//
//  void deleteEvent(Event event) {
//    _events.remove(event);
//    notifyListeners();
//  }
//
//}
