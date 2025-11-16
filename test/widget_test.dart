import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:deltacode_elecciones_presidenciales_2026/main.dart';
import 'package:deltacode_elecciones_presidenciales_2026/providers/idioma_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => IdiomaProvider(),
        child: const EleccionesApp(),
      ),
    );

    // Verify that the app loads
    await tester.pumpAndSettle();
    
    // Basic test - just verify the app doesn't crash
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
