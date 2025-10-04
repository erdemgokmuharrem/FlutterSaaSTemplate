import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_saas_starter/core/router/app_router.dart';
import 'package:flutter_saas_starter/features/todos/domain/models/todo.dart';
import 'package:flutter_saas_starter/features/todos/presentation/providers/todo_provider.dart';

class TodoListItem extends ConsumerWidget {
  final Todo todo;

  const TodoListItem({
    required this.todo,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (_) {
            ref.read(todoControllerProvider).toggleTodoComplete(todo);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            color: todo.completed
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : null,
          ),
        ),
        subtitle: todo.description.isNotEmpty
            ? Text(
                todo.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: todo.completed ? TextDecoration.lineThrough : null,
                  color: todo.completed
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : null,
                ),
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            context.goNamed(
              AppRoute.editTodo.name,
              pathParameters: {'id': todo.id},
            );
          },
        ),
        onTap: () {
          context.goNamed(
            AppRoute.editTodo.name,
            pathParameters: {'id': todo.id},
          );
        },
      ),
    );
  }
}

