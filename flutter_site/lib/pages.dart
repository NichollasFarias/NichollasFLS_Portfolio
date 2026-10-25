import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app.dart';
import 'components.dart';
import 'content.dart';
import 'media.dart';
import 'motion.dart';
import 'heraldry.dart';
import 'certificates.dart';
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
  final progress = ValueNotifier<double>(0);
  final active = ValueNotifier<String>('/');
  final anchors = {
    for (final key in [
      '/',
      '/about',
      '/featured',
      '/projects',
      '/experience',
      '/education',
      '/forge',
      '/contact',
    ])
      key: GlobalKey(),
  };
  bool initialHandled = false, observing = false;
  bool projectOpen = false;
  ScrollController? detailController;
  void update(VoidCallback callback) => setState(callback);
  PortfolioScope get s => PortfolioScope.of(context);
  String bi(String pt, String en) => s.bi(pt, en);
  @override
  void initState() {
    super.initState();
    scroll.addListener(observe);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialHandled) {
      initialHandled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.path != '/') {
          go(widget.path);
        }
      });
    }
  }

  void observe() {
    if (observing) {
      return;
    }
    observing = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      observing = false;
      if (!mounted || !scroll.hasClients) {
        return;
      }
      progress.value = scroll.position.maxScrollExtent <= 0
          ? 0
          : (scroll.offset / scroll.position.maxScrollExtent).clamp(0, 1);
      var current = '/';
      for (final entry in anchors.entries) {
        final box = entry.value.currentContext?.findRenderObject();
        if (box is RenderBox &&
            box.hasSize &&
            box.localToGlobal(Offset.zero).dy < 180) {
          current = entry.key;
        }
      }
      active.value = current;
    });
  }

  @override
  void dispose() {
    scroll.removeListener(observe);
    detailController?.dispose();
    detailController = null;
    scroll.dispose();
    progress.dispose();
    active.dispose();
    super.dispose();
  }

  Future<void> go(String route) async {
    if (route.startsWith('/project/')) {
      await openProject(route.substring(9));
      return;
    }
    final anchor = anchors[route]?.currentContext;
    if (anchor == null) {
      return;
    }
    await Scrollable.ensureVisible(
      anchor,
      alignment: .015,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
    observe();
  }

  Future<void> openProject(String id) async {
    final matches = s.content.projects.where((p) => p.id == id);
    if (projectOpen || matches.isEmpty) {
      return;
    }
    projectOpen = true;
    final previousOffset = scroll.hasClients ? scroll.offset : 0.0;
    detailController = ScrollController();
    final p = matches.first;
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: bi('Fechar projeto', 'Close project'),
      barrierColor: ink.withValues(alpha: .9),
      routeSettings: RouteSettings(name: '/project/$id'),
      transitionDuration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 250),
      transitionBuilder: (_, animation, _, child) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, .035),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      pageBuilder: (ctx, _, _) => Builder(
        builder: (dialogContext) {
          final locale = PortfolioScope.of(dialogContext);
          return SafeArea(
            child: Dialog(
              key: const Key('project-modal'),
              backgroundColor: panel,
              insetPadding: EdgeInsets.all(
                MediaQuery.sizeOf(ctx).width < 600 ? 8 : 28,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: line),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            color: ice,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              p.text('title', locale.lang),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            key: const Key('project-share'),
                            tooltip: locale.bi(
                              'Copiar link do projeto',
                              'Copy project link',
                            ),
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(
                                  text: Uri.base
                                      .replace(fragment: '/project/$id')
                                      .toString(),
                                ),
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      locale.bi(
                                        'Link copiado.',
                                        'Link copied.',
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.link),
                          ),
                          IconButton(
                            key: const Key('project-close'),
                            tooltip: locale.bi(
                              'Fechar projeto',
                              'Close project',
                            ),
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        key: const Key('project-detail-scroll'),
                        controller: detailController,
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.sizeOf(ctx).width < 600 ? 20 : 36,
                          28,
                          MediaQuery.sizeOf(ctx).width < 600 ? 20 : 36,
                          24,
                        ),
                        child: projectDetails(p, dialogContext),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    projectOpen = false;
    detailController?.dispose();
    detailController = null;
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && scroll.hasClients) {
          scroll.jumpTo(
            previousOffset.clamp(0, scroll.position.maxScrollExtent),
          );
        }
      });
    }
  }

  Future<void> external(String url) async {
    try {
      final success = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.platformDefault,
      );
      if (!success) {
        throw StateError('Link unavailable');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              bi('Não foi possível abrir: $url', 'Unable to open: $url'),
            ),
          ),
        );
      }
    }
  }

  List<(String, String)> get nav => [
    ('/', bi('Início', 'Home')),
    ('/about', bi('Sobre', 'About')),
    ('/featured', bi('Destaques', 'Featured')),
    ('/projects', bi('Projetos', 'Projects')),
    ('/experience', bi('Experiência', 'Experience')),
    ('/education', bi('Formação', 'Education')),
    ('/forge', 'Lancelot Forge'),
    ('/contact', bi('Contato', 'Contact')),
  ];
  Widget section(String route, Widget child) => Container(
    key: anchors[route],
    padding: EdgeInsets.symmetric(vertical: route == '/' ? 32 : 52),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (route != '/') ...[const Ornament(), gap(48)],
        Reveal(scroll: scroll, child: child),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 1180;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ink.withValues(alpha: .98),
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 76,
        titleSpacing: width < 600 ? 20 : 40,
        title: InkWell(
          onTap: () => go('/'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/media/forge-symbol.png',
                key: const Key('official-logo'),
                width: width < 600 ? 38 : 46,
                height: 52,
                fit: BoxFit.contain,
                semanticLabel: 'Lancelot Forge',
              ),
              const SizedBox(width: 10),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'NICHOLLAS\nF. L. SANTOS',
                    style: TextStyle(
                      fontSize: width < 600 ? 9 : 10,
                      height: 1.4,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (!mobile)
            ValueListenableBuilder<String>(
              valueListenable: active,
              builder: (_, current, _) => Row(
                children: nav
                    .skip(1)
                    .map(
                      (item) => TextButton(
                        key: Key('nav-${item.$1.substring(1)}'),
                        onPressed: () => go(item.$1),
                        child: Text(
                          item.$2,
                          style: TextStyle(
                            fontSize: 12,
                            color: current == item.$1 ? ice : silver,
                          ),
                        ),
                      ),
                    )
                    .toList(),
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
                key: const Key('mobile-menu'),
                tooltip: bi('Abrir menu', 'Open menu'),
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              ),
            ),
          const SizedBox(width: 12),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (_, v, _) => LinearProgressIndicator(
              key: const Key('reading-progress'),
              value: v,
              minHeight: 2,
              color: ice,
              backgroundColor: line,
              semanticsLabel: bi('Progresso de leitura', 'Reading progress'),
            ),
          ),
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: panel,
        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    eyebrow('N / 2026'),
                    heading(
                      bi('Explore a jornada.', 'Explore the journey.'),
                      size: 30,
                    ),
                    gap(),
                    const Ornament(),
                  ],
                ),
              ),
              ...nav.map(
                (item) => ListTile(
                  key: Key('drawer-${item.$1}'),
                  title: Text(item.$2),
                  trailing: const Icon(Icons.south_east, size: 16, color: ice),
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
      body: SingleChildScrollView(
        key: const Key('single-page-scroll'),
        controller: scroll,
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1360),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width < 600 ? 22 : 64,
                  ),
                  child: Column(
                    children: [
                      section('/', hero()),
                      section('/about', about()),
                      section('/featured', featured()),
                      section('/projects', catalog()),
                      section('/experience', experience()),
                      section('/education', education()),
                      section('/forge', forge()),
                      section('/contact', contact()),
                    ],
                  ),
                ),
              ),
            ),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      eyebrow(label),
      Semantics(
        header: true,
        child: heading(
          value,
          size: MediaQuery.sizeOf(context).width < 600 ? 36 : 48,
        ),
      ),
    ],
  );
  Widget footer() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: line)),
    ),
    child: Center(
      child: Wrap(
        spacing: 40,
        runSpacing: 14,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          copy('N.  © 2026 NICHOLLAS F. L. SANTOS', size: 11),
          copy(
            bi(
              'v1.1.1 · SOFTWARE / ENGENHARIA',
              'v1.1.1 · SOFTWARE / ENGINEERING',
            ),
            size: 10,
            color: ice,
          ),
          TextButton(
            onPressed: () => go('/'),
            child: Text(bi('Voltar ao topo ↑', 'Back to top ↑')),
          ),
        ],
      ),
    ),
  );
}
