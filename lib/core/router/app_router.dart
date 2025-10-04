import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_saas_starter/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_saas_starter/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_saas_starter/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flutter_saas_starter/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_saas_starter/features/home/presentation/pages/home_page.dart';
import 'package:flutter_saas_starter/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_saas_starter/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_saas_starter/features/todos/presentation/pages/todos_page.dart';
import 'package:flutter_saas_starter/features/todos/presentation/pages/add_todo_page.dart';
import 'package:flutter_saas_starter/features/todos/presentation/pages/edit_todo_page.dart';
import 'package:flutter_saas_starter/features/subscription/presentation/pages/subscription_page.dart';
import 'package:flutter_saas_starter/shared/widgets/dashboard_scaffold.dart';

enum AppRoute {
  login,
  register,
  forgotPassword,
  home,
  profile,
  settings,
  todos,
  addTodo,
  editTodo,
  subscription,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation.startsWith('/forgot-password');
      
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }
      
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: AppRoute.register.name,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: AppRoute.forgotPassword.name,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => DashboardScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: AppRoute.home.name,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/profile',
            name: AppRoute.profile.name,
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/settings',
            name: AppRoute.settings.name,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/todos',
        name: AppRoute.todos.name,
        builder: (context, state) => const TodosPage(),
      ),
      GoRoute(
        path: '/todos/add',
        name: AppRoute.addTodo.name,
        builder: (context, state) => const AddTodoPage(),
      ),
      GoRoute(
        path: '/todos/edit/:id',
        name: AppRoute.editTodo.name,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditTodoPage(todoId: id);
        },
      ),
      GoRoute(
        path: '/subscription',
        name: AppRoute.subscription.name,
        builder: (context, state) => const SubscriptionPage(),
      ),
    ],
  );
});

