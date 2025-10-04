import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_saas_starter/shared/widgets/loading_overlay.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('LoadingOverlay shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingOverlay(
            isLoading: true,
            child: Scaffold(
              body: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('LoadingOverlay hides loading indicator when isLoading is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingOverlay(
            isLoading: false,
            child: Scaffold(
              body: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Content'), findsOneWidget);
    });
  });
}

