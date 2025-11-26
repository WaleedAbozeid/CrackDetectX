import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../widgets/app_button.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _addTodo() {
    if (_titleController.text.isNotEmpty) {
      Provider.of<AppState>(context, listen: false).addTodo(
        _titleController.text,
        _descController.text,
      );
      _titleController.clear();
      _descController.clear();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final activeTodos = appState.activeTodos;
    final completedTodos = appState.completedTodos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المهام', style: TextStyle(fontFamily: 'Cairo')),
        actions: [
          if (completedTodos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => appState.clearCompletedTodos(),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (activeTodos.isEmpty && completedTodos.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Center(
                child: Text(
                  'لا توجد مهام',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
                ),
              ),
            )
          else ...[
            if (activeTodos.isNotEmpty) ...[
              const Text('المهام النشطة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              const SizedBox(height: 8),
              ...activeTodos.map((todo) => _buildTodoTile(context, todo, appState)),
              const SizedBox(height: 16),
            ],
            if (completedTodos.isNotEmpty) ...[
              const Text('المهام المكتملة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: Colors.grey)),
              const SizedBox(height: 8),
              ...completedTodos.map((todo) => _buildTodoTile(context, todo, appState)),
            ],
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoTile(BuildContext context, dynamic todo, AppState appState) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => appState.toggleTodo(todo.id),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontFamily: 'Cairo',
            decoration: todo.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: todo.description.isNotEmpty
            ? Text(todo.description, style: const TextStyle(fontFamily: 'Cairo'))
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => appState.removeTodo(todo.id),
        ),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة مهمة جديدة', style: TextStyle(fontFamily: 'Cairo')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'العنوان',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                hintText: 'الوصف (اختياري)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 2,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          AppButton(
            title: 'إضافة',
            onPressed: _addTodo,
          ),
        ],
      ),
    );
  }
}
