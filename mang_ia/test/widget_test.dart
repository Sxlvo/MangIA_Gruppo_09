import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mang_ia/app/mangia_app.dart';

void main() {
  testWidgets('MangIA shows the redesigned safe-place navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MangiaApp()));

    expect(find.text('MangIA'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('IA'), findsOneWidget);
    expect(find.text('Esperti'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Scatta una foto chiara del tuo piatto'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });
}
