import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_saas_starter/features/todos/domain/models/todo.dart';

void main() {
  group('Todo Model Tests', () {
    test('should create a todo with required fields', () {
      final todo = Todo(
        id: '1',
        userId: 'user1',
        title: 'Test Todo',
      );

      expect(todo.id, '1');
      expect(todo.userId, 'user1');
      expect(todo.title, 'Test Todo');
      expect(todo.description, '');
      expect(todo.completed, false);
    });

    test('should create a todo with all fields', () {
      final now = DateTime.now();
      final todo = Todo(
        id: '1',
        userId: 'user1',
        title: 'Test Todo',
        description: 'Description',
        completed: true,
        createdAt: now,
        updatedAt: now,
      );

      expect(todo.id, '1');
      expect(todo.userId, 'user1');
      expect(todo.title, 'Test Todo');
      expect(todo.description, 'Description');
      expect(todo.completed, true);
      expect(todo.createdAt, now);
      expect(todo.updatedAt, now);
    });

    test('should copy todo with updated fields', () {
      final todo = Todo(
        id: '1',
        userId: 'user1',
        title: 'Test Todo',
      );

      final updatedTodo = todo.copyWith(
        title: 'Updated Todo',
        completed: true,
      );

      expect(updatedTodo.id, '1');
      expect(updatedTodo.userId, 'user1');
      expect(updatedTodo.title, 'Updated Todo');
      expect(updatedTodo.completed, true);
    });

    test('should serialize and deserialize todo', () {
      final todo = Todo(
        id: '1',
        userId: 'user1',
        title: 'Test Todo',
        description: 'Description',
        completed: true,
      );

      final json = todo.toJson();
      final deserializedTodo = Todo.fromJson(json);

      expect(deserializedTodo.id, todo.id);
      expect(deserializedTodo.userId, todo.userId);
      expect(deserializedTodo.title, todo.title);
      expect(deserializedTodo.description, todo.description);
      expect(deserializedTodo.completed, todo.completed);
    });
  });
}

