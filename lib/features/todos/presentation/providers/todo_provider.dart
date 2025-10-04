import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_saas_starter/features/todos/data/repositories/firestore_todo_repository.dart';
import 'package:flutter_saas_starter/features/todos/domain/models/todo.dart';
import 'package:flutter_saas_starter/features/todos/domain/repositories/todo_repository.dart';
import 'package:flutter_saas_starter/features/auth/presentation/providers/auth_provider.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return FirestoreTodoRepository();
});

final userTodosProvider = StreamProvider<List<Todo>>((ref) {
  final user = ref.watch(currentUserProvider);
  
  if (user == null) {
    return Stream.value([]);
  }
  
  final todoRepository = ref.watch(todoRepositoryProvider);
  return todoRepository.watchUserTodos(user.id);
});

final userTodoCountProvider = FutureProvider<int>((ref) async {
  final user = ref.watch(currentUserProvider);
  
  if (user == null) {
    return 0;
  }
  
  final todoRepository = ref.watch(todoRepositoryProvider);
  return todoRepository.getUserTodoCount(user.id);
});

final todoControllerProvider = Provider<TodoController>((ref) {
  return TodoController(
    ref.watch(todoRepositoryProvider),
    ref.watch(currentUserProvider),
  );
});

class TodoController {
  final TodoRepository _todoRepository;
  final dynamic _currentUser;
  
  TodoController(this._todoRepository, this._currentUser);
  
  Future<void> createTodo({
    required String title,
    String description = '',
  }) async {
    if (_currentUser == null) throw Exception('User not authenticated');
    
    final todo = Todo(
      id: '',
      userId: _currentUser.id as String,
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    
    await _todoRepository.createTodo(todo);
  }
  
  Future<void> updateTodo(Todo todo) async {
    await _todoRepository.updateTodo(todo);
  }
  
  Future<void> toggleTodoComplete(Todo todo) async {
    final updatedTodo = todo.copyWith(completed: !todo.completed);
    await _todoRepository.updateTodo(updatedTodo);
  }
  
  Future<void> deleteTodo(String todoId) async {
    await _todoRepository.deleteTodo(todoId);
  }
  
  Future<Todo> getTodo(String todoId) async {
    return await _todoRepository.getTodo(todoId);
  }
}

