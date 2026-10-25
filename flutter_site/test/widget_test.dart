import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nichollas_portfolio/main.dart';
import 'package:nichollas_portfolio/content.dart';
import 'package:nichollas_portfolio/pages.dart';
import 'package:nichollas_portfolio/components.dart';
import 'package:nichollas_portfolio/certificates.dart';
import 'package:nichollas_portfolio/media.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PortfolioContent content;
  setUpAll(() async {
    content = await PortfolioContent.load();
  });
  Future<void> boot(
    WidgetTester tester, {
    Size size = const Size(1366, 768),
    String? lang = 'pt',
  }) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      PortfolioApp(content: content, initialLanguage: lang),
    );
    await tester.pumpAndSettle();
  }

  ScrollController pageScroll(WidgetTester tester) => tester
      .widget<SingleChildScrollView>(
        find.byKey(const Key('single-page-scroll')),
      )
      .controller!;
  Future<void> section(WidgetTester tester, String route) async {
    final desktop = find.byKey(Key('nav-${route.substring(1)}'));
    if (desktop.evaluate().isNotEmpty) {
      await tester.tap(desktop);
    } else {
      await tester.tap(find.byKey(const Key('mobile-menu')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('drawer-$route')));
    }
    await tester.pumpAndSettle();
  }

  test(
    'All 22 projects, localized fields, safe links and real certificate metadata',
    () async {
      expect(content.projects.length, 22);
      expect(content.projects.map((p) => p.id).toSet().length, 22);
      for (final p in content.projects) {
        for (final lang in ['pt', 'en']) {
          for (final field in ['title', 'text', 'details', 'role']) {
            expect(p.text(field, lang), isNotEmpty);
          }
        }
        for (final link in p.links) {
          expect(Uri.parse(link[1]).scheme, 'https');
          expect(link[1].contains('Modulo'), isFalse);
        }
        expect(
          ['pegasus', 'riftweave', 'storage', 'api-quimico'].contains(p.id),
          isFalse,
        );
        for (final media in p.media) {
          expect(
            (await rootBundle.load('assets/media/${media[1]}')).lengthInBytes,
            greaterThan(0),
          );
        }
      }
      expect(content.filtered(category: 'personal').map((p) => p.id).toSet(), {
        'lembre',
        'forge',
        'quimera',
        'traverna',
        'neuro',
      });
      expect(content.filtered(category: 'forge').map((p) => p.id).toSet(), {
        'lembre',
        'forge',
        'quimera',
      });
      expect(
        content.filtered(query: 'Fourier').map((p) => p.id),
        contains('fourier'),
      );
      expect(content.filtered(technology: 'ESP32').first.id, 'safetrack');
      expect(content.certificates.length, 6);
      for (final c in content.certificates) {
        expect(c.file, endsWith('.webp'));
        expect(
          (await rootBundle.load('assets/media/${c.file}')).lengthInBytes,
          greaterThan(0),
        );
        for (final lang in ['pt', 'en']) {
          for (final field in ['name', 'type', 'note']) {
            expect(c.text(field, lang), isNotEmpty);
          }
        }
        expect(
          c.data.toString(),
          isNot(
            matches(r'\d{3}\.\d{3}\.\d{3}-\d{2}|\d{2}\.\d{3}\.\d{3}-[0-9X]'),
          ),
        );
      }
    },
  );
  testWidgets('First visit, persisted language and in-page search', (
    tester,
  ) async {
    await boot(tester, lang: null);
    expect(find.byType(SitePage), findsNothing);
    await tester.tap(find.text('English  →'));
    await tester.pumpAndSettle();
    expect(find.text('From ideas'), findsOneWidget);
    expect(
      (await SharedPreferences.getInstance()).getString('portfolio.language'),
      'en',
    );
    await section(tester, '/projects');
    expect(find.byType(SitePage), findsOneWidget);
    await tester.enterText(find.byKey(const Key('project-search')), 'Fourier');
    await tester.pumpAndSettle();
    expect(find.text('2 projects'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('project-search')),
      'no-such-project',
    );
    await tester.pumpAndSettle();
    expect(find.text('No projects match your search.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('language-toggle')));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum projeto corresponde à busca.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final size in [
    const Size(1920, 1080),
    const Size(1366, 768),
    const Size(768, 1024),
    const Size(390, 844),
    const Size(360, 800),
  ]) {
    testWidgets(
      'Single page navigation and project overlays ${size.width}x${size.height}',
      (tester) async {
        await boot(tester, size: size);
        expect(find.byType(CertificateCarousel), findsOneWidget);
        for (final route in [
          '/about',
          '/featured',
          '/projects',
          '/experience',
          '/education',
          '/forge',
          '/contact',
        ]) {
          await section(tester, route);
          expect(pageScroll(tester).offset, greaterThan(0));
          expect(find.byType(SitePage), findsOneWidget);
          expect(tester.takeException(), isNull, reason: route);
        }
        final list = size.width == 1366
            ? content.projects
            : [content.projects.first];
        for (final p in list) {
          final card = find
              .byWidgetPredicate(
                (w) => w is HoverCard && w.label == p.text('title', 'pt'),
              )
              .first;
          await tester.ensureVisible(card);
          await tester.pumpAndSettle();
          final before = pageScroll(tester).offset;
          await tester.tap(card);
          await tester.pumpAndSettle();
          expect(find.byKey(const Key('project-modal')), findsOneWidget);
          expect(find.byType(SitePage), findsOneWidget);
          expect(tester.takeException(), isNull, reason: p.id);
          await tester.tap(find.byKey(const Key('project-close')));
          await tester.pumpAndSettle();
          expect(find.byKey(const Key('project-modal')), findsNothing);
          expect(pageScroll(tester).offset, closeTo(before, .1));
        }
        await tester.tap(find.byKey(const Key('language-toggle')));
        await tester.pumpAndSettle();
        expect(find.text('From ideas'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets(
    'Certificate arrows, swipe and enlarged preview preserve position',
    (tester) async {
      await boot(tester, size: const Size(390, 844));
      await section(tester, '/education');
      final pager = find.byKey(const Key('certificate-pager'));
      final controller = tester.widget<PageView>(pager).controller!;
      await tester.tap(find.byKey(const Key('certificate-next')));
      await tester.pumpAndSettle();
      expect(controller.page, closeTo(1, .01));
      await tester.tap(find.byKey(const Key('certificate-previous')));
      await tester.pumpAndSettle();
      expect(controller.page, closeTo(0, .01));
      await tester.ensureVisible(pager);
      await tester.pumpAndSettle();
      await tester.drag(pager, const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(controller.page!, greaterThan(.8));
      final current = controller.page!;
      final before = pageScroll(tester).offset;
      final cards = find.byWidgetPredicate(
        (w) => w is HoverCard && w.label.startsWith('Ampliar'),
      );
      final card = cards.at(current.round());
      // PageView builds neighbors lazily; resolve the currently centered certificate by ID.
      final cert = content.certificates[current.round()];
      final currentCard = find.byKey(Key('certificate-${cert.id}'));
      expect(
        card.evaluate().isNotEmpty || currentCard.evaluate().isNotEmpty,
        isTrue,
      );
      await tester.tap(currentCard);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('certificate-preview')), findsOneWidget);
      await tester.tap(find.byKey(const Key('certificate-close')));
      await tester.pumpAndSettle();
      expect(controller.page, closeTo(current, .01));
      expect(pageScroll(tester).offset, closeTo(before, .1));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'Deep link opens a project overlay and gallery without replacing Home',
    (tester) async {
      tester.binding.platformDispatcher.defaultRouteNameTestValue =
          '/project/safetrack';
      addTearDown(
        tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
      );
      await boot(tester);
      expect(find.byType(SitePage), findsOneWidget);
      expect(find.byKey(const Key('project-modal')), findsOneWidget);
      final first = find.byKey(const Key('project-gallery-safetrack-0'));
      await tester.ensureVisible(first);
      await tester.pumpAndSettle();
      await tester.tap(first);
      await tester.pumpAndSettle();
      expect(find.byType(MediaGallery), findsOneWidget);
      await tester.tap(find.byTooltip('→'));
      await tester.pumpAndSettle();
      expect(find.text('2 / 10'), findsOneWidget);
      await tester.tap(find.byTooltip('Fechar'));
      await tester.pumpAndSettle();
      expect(find.byType(MediaGallery), findsNothing);
      expect(find.byKey(const Key('project-modal')), findsOneWidget);
      await tester.tap(find.byKey(const Key('project-close')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('single-page-scroll')), findsOneWidget);
      expect(find.byType(SitePage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('Desktop carousel reaches the last two certificates', (
    tester,
  ) async {
    await boot(tester);
    await section(tester, '/education');
    final next = find.byKey(const Key('certificate-next'));
    await tester.tap(next);
    await tester.pumpAndSettle();
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<PageView>(find.byKey(const Key('certificate-pager')))
          .controller!
          .page,
      2,
    );
    expect(tester.widget<IconButton>(next).onPressed, isNull);
    expect(find.byKey(const Key('certificate-bigdata')), findsOneWidget);
    expect(find.byKey(const Key('certificate-english')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Reduced motion disables reveal and carousel animations', (
    tester,
  ) async {
    tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(
      tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
    );
    await boot(tester);
    await section(tester, '/education');
    expect(
      MediaQuery.disableAnimationsOf(tester.element(find.byType(SitePage))),
      isTrue,
    );
    await tester.tap(find.byKey(const Key('certificate-next')));
    await tester.pump();
    expect(
      tester
          .widget<PageView>(find.byKey(const Key('certificate-pager')))
          .controller!
          .page,
      1,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is AnimatedSlide && w.duration != Duration.zero,
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });
}
