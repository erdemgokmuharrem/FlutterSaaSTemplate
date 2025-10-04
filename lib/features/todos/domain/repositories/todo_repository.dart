import 'package:flutter_saas_starter/features/todos/domain/models/todo.dart';

abstract class TodoRepository {
  Stream<List<Todo>> watchUserTodos(String userId);
  Future<List<Todo>> getUserTodos(String userId);
  Future<Todo> getTodo(String todoId);
  Future<void> createTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String todoId);
  Future<int> getUserTodoCount(String userId);
}

