import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'content.dart';
export 'app.dart' show PortfolioApp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final content = await PortfolioContent.load();
  String? language;
  try {
    language = (await SharedPreferences.getInstance()).getString(
      'portfolio.language',
    );
  } catch (_) {
    /* Storage preference falls back to session memory. */
  }
  runApp(PortfolioApp(content: content, initialLanguage: language));
}
