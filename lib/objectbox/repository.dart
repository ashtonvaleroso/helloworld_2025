import 'package:helloworld_2025/objectbox/event.dart';
import 'package:helloworld_2025/objectbox/task.dart';
import 'package:objectbox/objectbox.dart';

// run "flutter pub run build_runner build" to reconfigure data

class Repository {
  late final Box<Event> _eventBox;
  late final Box<Task> _taskBox;

  Repository(Store store) {
    _eventBox = store.box<Event>();
    _taskBox = store.box<Task>();
  }

  List<Event> getEvents() => _eventBox.getAll();

  int insertEvent(Event event) => _eventBox.put(event);

  bool deleteEvent(int id) => _eventBox.remove(id);

  Stream<List<Event>> streamEvents() => _eventBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  List<Task> getTasks() => _taskBox.getAll();

  int insertTask(Task task) => _taskBox.put(task);

  bool deleteTask(int id) => _taskBox.remove(id);

  Stream<List<Task>> streamTasks() => _taskBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}
