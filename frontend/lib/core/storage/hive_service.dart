import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend/features/auth/models/user.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/meeting_notes/models/meeting_note.dart';
import 'package:frontend/features/tasks/models/task.dart';

class HiveService {
  static const String userBoxName = 'user_box';
  static const String customersBoxName = 'customers_box';
  static const String meetingsBoxName = 'meetings_box';
  static const String meetingNotesBoxName = 'meeting_notes_box';
  static const String tasksBoxName = 'tasks_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(CustomerAdapter());
    Hive.registerAdapter(MeetingAdapter());
    Hive.registerAdapter(MeetingStatusAdapter());
    Hive.registerAdapter(MeetingNoteAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskStatusAdapter());
    Hive.registerAdapter(TaskPriorityAdapter());

    // Open Boxes
    await Future.wait([
      Hive.openBox<User>(userBoxName),
      Hive.openBox<Customer>(customersBoxName),
      Hive.openBox<Meeting>(meetingsBoxName),
      Hive.openBox<MeetingNote>(meetingNotesBoxName),
      Hive.openBox<Task>(tasksBoxName),
    ]);
  }

  // Box Accessors
  static Box<User> get userBox => Hive.box<User>(userBoxName);
  static Box<Customer> get customersBox => Hive.box<Customer>(customersBoxName);
  static Box<Meeting> get meetingsBox => Hive.box<Meeting>(meetingsBoxName);
  static Box<MeetingNote> get meetingNotesBox =>
      Hive.box<MeetingNote>(meetingNotesBoxName);
  static Box<Task> get tasksBox => Hive.box<Task>(tasksBoxName);
}
