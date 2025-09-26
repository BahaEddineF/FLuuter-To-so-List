import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --------------------
// 1. Provider (gestion de l'état)
// --------------------
class TaskProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;

  // Ajouter une tâche
  void addTask(String title) {
    _tasks.add({"title": title, "done": false});
    notifyListeners(); // avertir les widgets d'un changement
  }

  // Marquer comme terminée ou non
  void toggleTask(int index, bool value) {
    _tasks[index]["done"] = value;
    notifyListeners();
  }

  // Supprimer une tâche
  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}

// --------------------
// 2. Main
// --------------------
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

// --------------------
// 3. MyApp
// --------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      home: const TodoListPage(),
    );
  }
}

// --------------------
// 4. Page principale
// --------------------
class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ pour écrire une tâche
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Enter a task",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Liste des tâches
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return ListView.builder(
                    itemCount: taskProvider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = taskProvider.tasks[index];
                      return ListTile(
                        leading: Checkbox(
                          value: task["done"],
                          onChanged: (value) {
                            taskProvider.toggleTask(index, value ?? false);
                          },
                        ),
                        title: Text(
                          task["title"],
                          style: TextStyle(
                            decoration: task["done"]
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: task["done"] ? Colors.grey : Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            taskProvider.deleteTask(index);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bouton flottant pour ajouter une tâche
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.text.isNotEmpty) {
            Provider.of<TaskProvider>(context, listen: false)
                .addTask(controller.text);
            controller.clear();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
