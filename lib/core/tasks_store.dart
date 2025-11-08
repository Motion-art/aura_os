class TasksStore {
  // In-memory static store that persists for the app session.
  static final List<Map<String, dynamic>> _tasks = [];

  static List<Map<String, dynamic>> get tasks => _tasks;

  // Initialize with mock tasks if empty
  static void initMockTasks() {
    // Intentionally left blank so the app starts with an empty task list.
    // Callers can add tasks via TasksStore.addTask when the user creates them.
  }

  static void addTask(Map<String, dynamic> task) {
    _tasks.insert(0, task);
  }

  static void removeTask(String id) {
    _tasks.removeWhere((t) => t['id'] == id);
  }

  static void clear() {
    _tasks.clear();
  }
}
