import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String userId,
    required String title,
    @Default('') String description,
    @Default(false) bool completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Todo;
  
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

