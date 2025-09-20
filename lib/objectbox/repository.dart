import 'package:helloworld_2025/objectbox/event.dart';
import 'package:objectbox/objectbox.dart';

// run "flutter pub run build_runner build" to reconfigure data

class Repository {
  late final Box<Event> _eventBox;

  Repository(Store store) {
    _eventBox = store.box<Event>();
  }

  List<Event> getEvents() => _eventBox.getAll();

  int insertEvent(Event event) => _eventBox.put(event);

  bool deleteEvent(int id) => _eventBox.remove(id);

  Stream<List<Event>> streamEvents() => _eventBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
