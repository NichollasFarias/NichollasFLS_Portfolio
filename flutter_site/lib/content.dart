import 'dart:convert';
import 'package:flutter/services.dart';

class Project {
  final Map<String, dynamic> data;
  const Project(this.data);
  String get id => data['id'] as String;
  String get category => data['category'] as String;
  String get status => data['status'] as String;
  String get year => data['year'] as String;
  String? get image => data['image'] as String?;
  List<String> get tech => List<String>.from(data['tech'] as List);
  List<List<String>> get media => (data['media'] as List? ?? [])
      .map((e) => List<String>.from(e as List))
      .toList();
  List<List<String>> get links => (data['links'] as List? ?? [])
      .map((e) => List<String>.from(e as List))
      .toList();
  String text(String field, String language) =>
      (data[field] as Map?)?[language] as String? ?? '';
}

class Certificate {
  final Map<String, dynamic> data;
  const Certificate(this.data);
  String get id => data['id'] as String;
  String get file => data['file'] as String;
  String get year => data['year'] as String;
  String get institution => data['institution'] as String;
  String text(String field, String lang) =>
      (data[field] as Map)[lang] as String;
}

class PortfolioContent {
  final List<Project> projects;
  final Map<String, dynamic> translations;
  final List<Certificate> certificates;
  const PortfolioContent(
    this.projects,
    this.translations, [
    this.certificates = const [],
  ]);
  static Future<PortfolioContent> load() async {
    final json =
        jsonDecode(await rootBundle.loadString('assets/content.json'))
            as Map<String, dynamic>;
    return PortfolioContent(
      (json['projects'] as List)
          .map((e) => Project(e as Map<String, dynamic>))
          .toList(),
      json['tx'] as Map<String, dynamic>,
      (json['certificates'] as List? ?? [])
          .map((e) => Certificate(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String translate(String key, String lang) =>
      (translations[lang] as Map?)?[key] as String? ?? key;
  List<Project> filtered({
    String category = 'all',
    String query = '',
    String status = 'all',
    String technology = 'all',
    String lang = 'pt',
  }) {
    return projects
        .where(
          (p) =>
              (category == 'all' ||
                  p.category == category ||
                  (p.data['collections'] as List? ?? []).contains(category)) &&
              (status == 'all' || p.status == status) &&
              (technology == 'all' || p.tech.contains(technology)) &&
              ('${p.text('title', lang)} ${p.text('text', lang)} ${p.tech.join(' ')}')
                  .toLowerCase()
                  .contains(query.toLowerCase()),
        )
        .toList();
  }
}
