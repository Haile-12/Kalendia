import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/event.dart';

class EventService with ChangeNotifier {
  late Box<Event> _eventBox;

  Future<void> init() async {
    // Open Hive box when app starts
    _eventBox = Hive.box<Event>('events');
  }

  List<Event> get events => _eventBox.values.toList();

  void addEvent(Event event) {
    if (_eventBox.isOpen) {
      _eventBox.add(event);
      notifyListeners();
    } else {
      // Log the error (you can see this in terminal)
      debugPrint("❌ Hive box is not open! Cannot add event.");
      // You could throw an exception if needed
    }
  }

  void deleteEventAt(int index) {
    _eventBox.deleteAt(index);
    notifyListeners();
  }

  void deleteAllEvents() {
    _eventBox.clear();
    notifyListeners();
  }
}
