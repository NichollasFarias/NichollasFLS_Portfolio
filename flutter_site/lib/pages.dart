import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app.dart';
import 'components.dart';
import 'content.dart';
import 'media.dart';
part 'home.dart';
part 'profile.dart';
part 'projects.dart';

class SitePage extends StatefulWidget {
  final String path;
  const SitePage({super.key, required this.path});
  @override
  State<SitePage> createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  String category = 'all', query = '', status = 'all', technology = 'all';
  final scroll = ScrollController();
  void update(VoidCallback callback) => setState(callback);
  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  void go(String route) {
    if (widget.path != route) {
      Navigator.of(context).pushNamed(route);
    }
  }

  PortfolioScope get s => PortfolioScope.of(context);
  String bi(String pt, String en) => s.bi(pt, en);
  Future<void> external(String value) async {
    final ok = await launchUrl(
      Uri.parse(value),
      mode: LaunchMode.platformDefault,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            bi('Não foi possível abrir: $value', 'Unable to open: $value'),
          ),
        ),
      );
    }
  }

  List<(String, String)> get nav => [
    ('/', bi('Início', 'Home')),
    ('/projects', bi('Projetos', 'Projects')),
    ('/about', bi('Sobre', 'About')),
    ('/experience', bi('Experiência', 'Experience')),
    ('/education', bi('Formação', 'Education')),
    ('/forge', 'Lancelot Forge'),
    ('/contact', bi('Contato', 'Contact')),
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 1050;
    final body = switch (widget.path) {
      '/' => home(),
      '/projects' => catalog(),
      '/about' => about(),
      '/experience' => experience(),
      '/education' => education(),
      '/forge' => forge(),
      '/contact' => contact(),
      _ => detailOr404(),
    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ink,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 82,
        titleSpacing: width < 600 ? 20 : 40,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () => go('/'),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'N.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: ice,
                  ),
                ),
                if (width > 430) ...[
                  const SizedBox(width: 12),
                  const Text(
                    'NICHOLLAS\nF. L. SANTOS',
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.4,
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          if (!mobile)
            ...nav
                .skip(1)
                .map(
                  (item) => TextButton(
                    onPressed: () => go(item.$1),
                    child: Text(
                      item.$2,
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.path == item.$1 ? ice : silver,
                      ),
                    ),
                  ),
                ),
          TextButton(
            key: const Key('language-toggle'),
            onPressed: () => s.changeLanguage(s.lang == 'pt' ? 'en' : 'pt'),
            child: Text(
              s.lang == 'pt' ? 'PT / EN' : 'EN / PT',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          if (mobile)
            Builder(
              builder: (ctx) => IconButton(
                tooltip: bi('Abrir menu', 'Open menu'),
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              ),
            ),
          const SizedBox(width: 12),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: panel,
        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: heading('N.', size: 40),
              ),
              ...nav.map(
                (item) => ListTile(
                  title: Text(item.$2),
                  trailing: const Icon(Icons.north_east, size: 18),
                  selected: widget.path == item.$1,
                  onTap: () {
                    Navigator.pop(context);
                    go(item.$1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          controller: scroll,
          child: Column(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1320),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width < 600 ? 22 : 64,
                      vertical: width < 600 ? 40 : 68,
                    ),
                    child: body,
                  ),
                ),
              ),
              footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionHeader(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      eyebrow(label),
      heading(value, size: MediaQuery.sizeOf(context).width < 600 ? 36 : 48),
    ],
  );
  Widget contactBanner() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF24133D), Color(0xFF121320)],
      ),
      border: Border.all(color: line),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        eyebrow(bi('VAMOS CONSTRUIR ALGO', 'LET’S BUILD SOMETHING')),
        heading(
          bi(
            'Uma boa conversa\né o primeiro passo.',
            'A good conversation\nis the first step.',
          ),
          size: 32,
        ),
        gap(),
        action(bi('Entre em contato', 'Get in touch'), () => go('/contact')),
      ],
    ),
  );
  Widget footer() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: line)),
    ),
    child: Center(
      child: Wrap(
        spacing: 40,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          copy('N.   © 2026 NICHOLLAS F. L. SANTOS', size: 11),
          copy('FLUTTER WEB / v1.0.0', size: 10, color: ice),
          TextButton(
            onPressed: () => scroll.animateTo(
              0,
              duration: MediaQuery.of(context).disableAnimations
                  ? Duration.zero
                  : const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ),
            child: Text(bi('Voltar ao topo ↑', 'Back to top ↑')),
          ),
        ],
      ),
    ),
  );
}
