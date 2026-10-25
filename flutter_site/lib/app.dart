import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'content.dart';
import 'pages.dart';

const ink = Color(0xFF090812);
const panel = Color(0xFF12101E);
const violet = Color(0xFF8C45E8);
const ice = Color(0xFF35C5F4);
const silver = Color(0xFFC4C5D1);
const line = Color(0xFF30293F);

class PortfolioApp extends StatefulWidget {
  final PortfolioContent content;
  final String? initialLanguage;
  const PortfolioApp({super.key, required this.content, this.initialLanguage});
  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late String lang = widget.initialLanguage == 'en' ? 'en' : 'pt';
  late bool choose = widget.initialLanguage == null;
  Future<void> language(String value) async {
    setState(() {
      lang = value;
      choose = false;
    });
    try {
      await (await SharedPreferences.getInstance()).setString(
        'portfolio.language',
        value,
      );
    } catch (_) {
      /* Storage may be unavailable in private browser contexts. */
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Nichollas F. L. Santos | Portfolio',
    debugShowCheckedModeBanner: false,
    locale: Locale(lang),
    supportedLocales: const [Locale('pt'), Locale('en')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: ink,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFBA8AFF),
        secondary: ice,
        surface: panel,
        onSurface: Color(0xFFF1EDF8),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16, height: 1.6, color: silver),
      ),
      dividerColor: line,
      visualDensity: VisualDensity.standard,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: violet,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: line),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: panel,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: line),
        ),
      ),
    ),
    builder: (context, child) => PortfolioScope(
      lang: lang,
      content: widget.content,
      changeLanguage: language,
      child: Stack(
        children: [
          if (!choose) child!,
          if (choose)
            Positioned.fill(
              child: ColoredBox(
                color: ink.withValues(alpha: .96),
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 520),
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: panel,
                        border: Border.all(color: line),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'N.',
                              style: TextStyle(
                                fontSize: 64,
                                color: ice,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'BEM-VINDO / WELCOME',
                              style: TextStyle(color: silver, letterSpacing: 2),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Escolha seu idioma.\nChoose your language.',
                              style: TextStyle(fontSize: 28, height: 1.25),
                            ),
                            const SizedBox(height: 28),
                            FilledButton(
                              onPressed: () => language('pt'),
                              child: const Text('Português (BR)  →'),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () => language('en'),
                              child: const Text('English  →'),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Você pode alterar depois.\nYou can change this anytime.',
                              style: TextStyle(color: silver),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    onGenerateInitialRoutes: (initial) => [
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/'),
        builder: (_) => SitePage(path: initial),
      ),
    ],
    onGenerateRoute: (settings) => MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => SitePage(path: settings.name ?? '/'),
    ),
  );
}

class PortfolioScope extends InheritedWidget {
  final String lang;
  final PortfolioContent content;
  final ValueChanged<String> changeLanguage;
  const PortfolioScope({
    super.key,
    required this.lang,
    required this.content,
    required this.changeLanguage,
    required super.child,
  });
  static PortfolioScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PortfolioScope>()!;
  String bi(String pt, String en) => lang == 'pt' ? pt : en;
  String t(String key) => content.translate(key, lang);
  @override
  bool updateShouldNotify(PortfolioScope oldWidget) => oldWidget.lang != lang;
}
