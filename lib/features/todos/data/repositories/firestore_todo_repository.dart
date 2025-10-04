import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_saas_starter/features/todos/domain/models/todo.dart';
import 'package:flutter_saas_starter/features/todos/domain/repositories/todo_repository.dart';
import 'package:flutter_saas_starter/core/constants/app_constants.dart';
import 'package:flutter_saas_starter/core/utils/logger.dart';

class FirestoreTodoRepository implements TodoRepository {
  final FirebaseFirestore _firestore;
  
  FirestoreTodoRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;
  
  CollectionReference<Map<String, dynamic>> get _todosCollection =>
      _firestore.collection(AppConstants.collectionTodos);
  
  @override
  Stream<List<Todo>> watchUserTodos(String userId) {
    return _todosCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Todo.fromJson({
          ...data,
          'id': doc.id,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    });
  }
  
  @override
  Future<List<Todo>> getUserTodos(String userId) async {
    try {
      final snapshot = await _todosCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Todo.fromJson({
          ...data,
          'id': doc.id,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e, stackTrace) {
      Logger.error('Failed to get user todos', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<Todo> getTodo(String todoId) async {
    try {
      final doc = await _todosCollection.doc(todoId).get();
      
      if (!doc.exists) {
        throw Exception('Todo not found');
      }
      
      final data = doc.data()!;
      return Todo.fromJson({
        ...data,
        'id': doc.id,
        'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
        'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
      });
    } catch (e, stackTrace) {
      Logger.error('Failed to get todo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<void> createTodo(Todo todo) async {
    try {
      await _todosCollection.add({
        'userId': todo.userId,
        'title': todo.title,
        'description': todo.description,
        'completed': todo.completed,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stackTrace) {
      Logger.error('Failed to create todo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      await _todosCollection.doc(todo.id).update({
        'title': todo.title,
        'description': todo.description,
        'completed': todo.completed,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stackTrace) {
      Logger.error('Failed to update todo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<void> deleteTodo(String todoId) async {
    try {
      await _todosCollection.doc(todoId).delete();
    } catch (e, stackTrace) {
      Logger.error('Failed to delete todo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  @override
  Future<int> getUserTodoCount(String userId) async {
    try {
      final snapshot = await _todosCollection
          .where('userId', isEqualTo: userId)
          .count()
          .get();
      
      return snapshot.count ?? 0;
    } catch (e, stackTrace) {
      Logger.error('Failed to get todo count', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

