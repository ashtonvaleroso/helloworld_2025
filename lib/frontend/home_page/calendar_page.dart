import 'package:flutter/foundation.dart';
import 'package:helloworld_2025/objectbox/event.dart';
import 'package:helloworld_2025/objectbox/repository.dart';

class CalendarPageModel extends ChangeNotifier {
  final Repository repository;

  CalendarPageModel(this.repository);

  Stream<List<Event>> streamEvents() => repository.streamEvents();

  List<Event> getEvents() => repository.getEvents();

  Future<void> addEvent(Event event) async {
    repository.insertEvent(event);
    notifyListeners();
  }
}
