import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_saas_starter/features/todos/presentation/providers/todo_provider.dart';
import 'package:flutter_saas_starter/features/todos/domain/models/todo.dart';
import 'package:flutter_saas_starter/shared/widgets/loading_overlay.dart';

class EditTodoPage extends ConsumerStatefulWidget {
  final String todoId;

  const EditTodoPage({
    required this.todoId,
    super.key,
  });

  @override
  ConsumerState<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends ConsumerState<EditTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  Todo? _todo;

  @override
  void initState() {
    super.initState();
    _loadTodo();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadTodo() async {
    setState(() => _isLoading = true);

    try {
      final todo = await ref.read(todoControllerProvider).getTodo(widget.todoId);
      setState(() {
        _todo = todo;
        _titleController.text = todo.title;
        _descriptionController.text = todo.description;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load todo: $e'),
            backgroundColor: Colors.red,
          ),
        );
        context.pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSave() async {
    if (_todo == null || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedTodo = _todo!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      await ref.read(todoControllerProvider).updateTodo(updatedTodo);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todo updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update todo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleDelete() async {
    if (_todo == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(todoControllerProvider).deleteTodo(widget.todoId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todo deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete todo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Todo'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _handleDelete,
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _handleSave,
            ),
          ],
        ),
        body: _todo == null
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter todo title',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter todo description (optional)',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _handleSave,
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Save Changes'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _handleDelete,
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Delete Todo'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

