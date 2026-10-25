// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nichollas_portfolio/main.dart';
import 'package:nichollas_portfolio/content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PortfolioContent fixture;
  setUpAll(() async {
    fixture = await PortfolioContent.load();
  });
  testWidgets('First visit language choice and interactive project search', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1366, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(PortfolioApp(content: fixture));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English  →'));
    await tester.pumpAndSettle();
    expect(find.text('From ideas\nto the real world.'), findsOneWidget);
    expect(
      (await SharedPreferences.getInstance()).getString('portfolio.language'),
      'en',
    );
    await tester.tap(find.text('Projects').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('project-search')), 'Fourier');
    await tester.pumpAndSettle();
    expect(find.text('2 projects'), findsOneWidget);
    expect(find.text('Fourier Series Calculator'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('project-search')),
      'no-such-project',
    );
    await tester.pumpAndSettle();
    expect(find.text('No projects match your search.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  test(
    'Content has bilingual descriptions, media and no excluded projects',
    () async {
      final c = fixture;
      expect(c.projects.length, greaterThanOrEqualTo(22));
      expect(c.projects.map((p) => p.id).toSet().length, c.projects.length);
      for (final p in c.projects) {
        for (final lang in ['pt', 'en']) {
          for (final field in ['title', 'text', 'details', 'role']) {
            expect(
              p.text(field, lang),
              isNotEmpty,
              reason: '${p.id} $lang $field',
            );
          }
        }
        expect(p.id, isNot(contains('pegasus')));
        expect(p.id, isNot(contains('riftweave')));
        for (final link in p.links) {
          expect(link[1].startsWith('https://'), isTrue);
          expect(link[1].contains('Modulo'), isFalse);
        }
      }
      expect(
        c.filtered(category: 'games').every((p) => p.category == 'games'),
        isTrue,
      );
      expect(
        c.filtered(query: 'Fourier').map((p) => p.id),
        contains('fourier'),
      );
      expect(c.filtered(technology: 'ESP32').first.id, 'safetrack');
      expect(c.filtered(query: 'zzzzzz'), isEmpty);
    },
  );
  for (final dimensions in [
    const Size(1920, 1080),
    const Size(1366, 768),
    const Size(768, 1024),
    const Size(390, 844),
    const Size(360, 800),
  ]) {
    testWidgets('Responsive routes ${dimensions.width}x${dimensions.height}', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = dimensions;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = fixture;
      await tester.pumpWidget(PortfolioApp(content: c, initialLanguage: 'pt'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final context = tester.element(find.byType(Scaffold).first);
      for (final route in [
        '/projects',
        '/about',
        '/experience',
        '/education',
        '/forge',
        '/contact',
        ...c.projects.map((p) => '/project/${p.id}'),
        '/unknown',
      ]) {
        Navigator.of(context).pushNamed(route);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: route);
        Navigator.of(context).pop();
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byKey(const Key('language-toggle')));
      await tester.pumpAndSettle();
      expect(find.text('From ideas\nto the real world.'), findsOneWidget);
      expect(
        (await SharedPreferences.getInstance()).getString('portfolio.language'),
        'en',
      );
    });
  }
}
