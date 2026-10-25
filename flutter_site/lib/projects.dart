part of 'pages.dart';

extension _ProjectPages on _SitePageState {
  Widget projectGrid(List<Project> projects) => LayoutBuilder(
    builder: (_, c) {
      final columns = c.maxWidth < 620
          ? 1
          : c.maxWidth < 960
          ? 2
          : 3;
      final w = (c.maxWidth - 24 * (columns - 1)) / columns;
      return Wrap(
        spacing: 24,
        runSpacing: 28,
        children: projects
            .asMap()
            .entries
            .map(
              (e) => SizedBox(
                width: w,
                child: Reveal(
                  key: ValueKey('reveal-${e.value.id}'),
                  scroll: scroll,
                  order: e.key,
                  child: projectCard(e.value),
                ),
              ),
            )
            .toList(),
      );
    },
  );
  Widget projectCard(Project p) => HoverCard(
    onTap: () => go('/project/${p.id}'),
    label: p.text('title', s.lang),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (p.image != null)
          AspectRatio(
            aspectRatio: 1.65,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: p.image != null
                  ? ProjectImage(p.image!, label: p.text('title', s.lang))
                  : CustomPaint(
                      painter: CircuitPainter(),
                      child: Center(
                        child: Text(
                          p.data['glyph'] as String? ?? '</>',
                          style: const TextStyle(fontSize: 54, color: ice),
                        ),
                      ),
                    ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: copy(
                      projectCategoryLabel(p).toUpperCase(),
                      size: 10,
                      color: ice,
                    ),
                  ),
                  copy(p.year, size: 11),
                ],
              ),
              gap(12),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: p.image != null ? 56 : 0,
                ),
                child: Text(
                  p.text('title', s.lang),
                  style: const TextStyle(
                    fontSize: 23,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              gap(12),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: p.image != null ? 68 : 0,
                ),
                child: Text(
                  p.text('text', s.lang),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: silver,
                  ),
                ),
              ),
              gap(18),
              tags(p.tech.take(3).map(techLabel).toList()),
              gap(22),
              Row(
                children: [
                  Expanded(child: copy(s.t(p.status), size: 11)),
                  const Icon(Icons.north_east, color: ice, size: 20),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
  String techLabel(String value) => s.lang == 'en'
      ? value
      : const {
              'Chemistry': 'Química',
              'Calculations': 'Cálculos',
              'Education': 'Educação',
              'Social experience': 'Experiência social',
              'Documents': 'Documentos',
              'Laboratory': 'Laboratório',
              'Density': 'Densidade',
              'Industrial chemistry': 'Química industrial',
              'Modeling': 'Modelagem',
              'Scale model': 'Maquete',
              'AI': 'IA',
              'Motors': 'Motores',
              'Mathematics': 'Matemática',
              'Algorithm': 'Algoritmo',
              'Mobile': 'Mobile',
            }[value] ??
            value;
  String projectCategoryLabel(Project p) => p.belongsToForge
      ? (p.category == 'chem'
            ? 'Lancelot Forge · ${categoryLabel(p.category)}'
            : 'Lancelot Forge')
      : categoryLabel(p.category);
  String categoryLabel(String c) => switch (c) {
    'apps' => 'Lancelot Forge',
    'eng' => bi('Engenharia da Computação', 'Computer Engineering'),
    'forge' => 'Lancelot Forge',
    'games' => bi('Jogos digitais', 'Digital games'),
    'chem' => bi('Química', 'Chemistry'),
    'work' => 'CodeCycle',
    'archive' => bi('Acervo acadêmico', 'Coursework'),
    _ => bi('Todos', 'All'),
  };
  Widget catalog() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionHeader(
        bi('PORTFÓLIO / EXPLORAR', 'PORTFOLIO / EXPLORE'),
        bi('Explore meus projetos.', 'Explore my projects.'),
      ),
      gap(),
      copy(
        bi(
          'Aplicativos, circuitos, jogos e ciência. Conheça as ideias, tecnologias e soluções por trás de cada trabalho.',
          'Applications, circuits, games and science. Discover the ideas, technologies and solutions behind each project.',
        ),
      ),
      gap(30),
      Wrap(
        spacing: 8,
        runSpacing: 10,
        children: ['all', 'eng', 'games', 'chem', 'work', 'forge', 'archive']
            .map(
              (c) => ChoiceChip(
                label: Text(categoryLabel(c)),
                selected: category == c,
                onSelected: (_) => update(() => category = c),
              ),
            )
            .toList(),
      ),
      gap(24),
      LayoutBuilder(
        builder: (_, c) => Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: c.maxWidth < 680 ? c.maxWidth : c.maxWidth * .4,
              child: TextField(
                key: const Key('project-search'),
                onChanged: (v) => update(() => query = v),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: bi(
                    'Buscar projeto ou tecnologia',
                    'Search projects or technologies',
                  ),
                ),
              ),
            ),
            SizedBox(
              width: c.maxWidth < 680
                  ? (c.maxWidth - 16) / 2
                  : (c.maxWidth * .6 - 32) / 2,
              child: DropdownButtonFormField<String>(
                initialValue: status,
                isExpanded: true,
                decoration: InputDecoration(labelText: bi('Status', 'Status')),
                items:
                    ['all', ...s.content.projects.map((p) => p.status).toSet()]
                        .map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Text(
                              v == 'all' ? bi('Todos', 'All') : s.t(v),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (v) => update(() => status = v ?? 'all'),
              ),
            ),
            SizedBox(
              width: c.maxWidth < 680
                  ? (c.maxWidth - 16) / 2
                  : (c.maxWidth * .6 - 32) / 2,
              child: DropdownButtonFormField<String>(
                initialValue: technology,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: bi('Tecnologia', 'Technology'),
                ),
                items:
                    [
                          'all',
                          ...(s.content.projects
                              .expand((p) => p.tech)
                              .toSet()
                              .toList()
                            ..sort()),
                        ]
                        .map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Text(
                              v == 'all' ? bi('Todas', 'All') : techLabel(v),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (v) => update(() => technology = v ?? 'all'),
              ),
            ),
          ],
        ),
      ),
      gap(24),
      Builder(
        builder: (_) {
          final result = s.content.filtered(
            category: category,
            query: query,
            status: status,
            technology: technology,
            lang: s.lang,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              copy(
                '${result.length} ${result.length == 1 ? bi('projeto', 'project') : bi('projetos', 'projects')}',
                size: 12,
              ),
              gap(20),
              if (result.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 64),
                  child: copy(
                    bi(
                      'Nenhum projeto corresponde à busca.',
                      'No projects match your search.',
                    ),
                  ),
                ),
              projectGrid(result),
            ],
          );
        },
      ),
    ],
  );
  Widget projectDetails(Project p, BuildContext modalContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        eyebrow('${projectCategoryLabel(p)} / ${p.year}'),
        Padding(
          key: const Key('project-title'),
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Text(
            p.text('title', s.lang),
            style: TextStyle(
              fontSize: MediaQuery.sizeOf(context).width < 600 ? 34 : 52,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        gap(24),
        copy(p.text('text', s.lang), size: 20),
        gap(22),
        tags([s.t(p.status), ...p.tech.map(techLabel)]),
        gap(28),
        if (p.image != null)
          projectSplit(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => openGallery(
                    modalContext,
                    p.media,
                    0,
                    p.text('title', s.lang),
                    bi('Fechar', 'Close'),
                    ownerScroll: detailController,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 420),
                      child: ProjectImage(
                        p.image!,
                        label: p.text('title', s.lang),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                gap(16),
                copy(mediaLabel(p), size: 11, color: ice),
              ],
            ),
            projectOverview(p),
            left: 6,
            right: 5,
          )
        else
          projectOverview(p),
        gap(40),
        if (p.id == 'safetrack') ...safeTrackCase(),
        if (p.text('result', s.lang).isNotEmpty) ...[
          eyebrow(bi('RESULTADOS', 'RESULTS')),
          copy(p.text('result', s.lang)),
          gap(40),
        ],
        if (p.media.isNotEmpty) ...[
          eyebrow(
            bi('GALERIA / CLIQUE PARA AMPLIAR', 'GALLERY / CLICK TO EXPAND'),
          ),
          LayoutBuilder(
            builder: (_, c) {
              final cols = c.maxWidth < 600 ? 1 : p.media.length.clamp(1, 3);
              final w = (c.maxWidth - 16 * (cols - 1)) / cols;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: p.media
                    .asMap()
                    .entries
                    .map(
                      (e) => SizedBox(
                        width: w,
                        child: HoverCard(
                          key: Key('project-gallery-${p.id}-${e.key}'),
                          label: '${p.text('title', s.lang)} ${e.key + 1}',
                          onTap: () => openGallery(
                            modalContext,
                            p.media,
                            e.key,
                            p.text('title', s.lang),
                            bi('Fechar', 'Close'),
                            ownerScroll: detailController,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.6,
                            child: e.value[0] == 'video'
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.play_circle_outline,
                                        size: 42,
                                        color: ice,
                                      ),
                                      gap(10),
                                      copy(
                                        '${bi('Vídeo sem áudio', 'Video without audio')} ${e.key + 1}',
                                        size: 13,
                                      ),
                                    ],
                                  )
                                : ProjectImage(
                                    e.value[1],
                                    label:
                                        '${p.text('title', s.lang)} ${e.key + 1}',
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          gap(32),
        ],
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: p.links
              .map(
                (l) => action(s.t(l[0]), () => external(l[1]), secondary: true),
              )
              .toList(),
        ),
        gap(60),
      ],
    );
  }

  Widget projectOverview(Project p) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      eyebrow(bi('SOBRE O PROJETO', 'ABOUT THE PROJECT')),
      copy(p.text('details', s.lang)),
      if (p.text('features', s.lang).isNotEmpty) ...[
        gap(24),
        eyebrow(bi('FUNCIONALIDADES', 'FEATURES')),
        ...p
            .text('features', s.lang)
            .split('\n')
            .map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Icon(Icons.diamond_outlined, color: ice, size: 13),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: copy(f, size: 14)),
                  ],
                ),
              ),
            ),
      ],
      if (p.text('credits', s.lang).isNotEmpty) ...[
        gap(20),
        copy(p.text('credits', s.lang), size: 12),
      ],
    ],
  );
  Widget projectSplit(
    Widget image,
    Widget overview, {
    int left = 6,
    int right = 5,
  }) => LayoutBuilder(
    builder: (_, c) => c.maxWidth < 760
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [image, gap(28), overview],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: left, child: image),
              const SizedBox(width: 36),
              Expanded(flex: right, child: overview),
            ],
          ),
  );
  String mediaLabel(Project p) => switch (p.data['mediaKind']) {
    'mockup' => bi('Mockup de apresentação', 'Presentation mockup'),
    'demo' => bi('Interface de demonstração', 'Demo interface'),
    'poster' => bi('Apresentação do projeto', 'Project presentation'),
    'gameplay' => bi('Gameplay', 'Gameplay'),
    _ => bi('Visão geral', 'Overview'),
  };
  List<Widget> safeTrackCase() => [
    eyebrow(bi('PROBLEMA + SOLUÇÃO', 'PROBLEM + SOLUTION')),
    copy(
      bi(
        'Pequenas empresas precisam acompanhar o ambiente e a retirada de itens sem depender de uma estrutura complexa. O TCC explorou uma solução modular de baixo custo, conectando sensores, aplicativo móvel e uma central desktop.',
        'Small businesses need to monitor their environment and inventory withdrawals without a complex setup. The capstone explored a low-cost modular solution connecting sensors, a mobile app and a desktop hub.',
      ),
    ),
    gap(32),
    eyebrow(bi('ARQUITETURA DO PROTÓTIPO', 'PROTOTYPE ARCHITECTURE')),
    Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: panel,
        border: Border.all(color: line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          copy('ESP32 / ESP32-CAM', color: ice),
          const Icon(Icons.arrow_forward, color: ice),
          copy('Wi-Fi + Firebase Realtime Database', color: Colors.white),
          const Icon(Icons.arrow_forward, color: ice),
          copy('Expo / C# Windows', color: ice),
        ],
      ),
    ),
    gap(),
    copy(
      bi(
        '01  Som — acionamento remoto do alarme.\n02  Ambiente — temperatura e gás com DHT22 e MQ-2.\n03  Câmera — ESP32-CAM e presença com PIR.\n04  Energia — detecção de perda de alimentação com apoio de bateria.\n05  RFID — identificação de funcionários na retirada de itens.',
        '01  Sound — remote alarm control.\n02  Environment — DHT22 and MQ-2 temperature and gas sensing.\n03  Camera — ESP32-CAM and PIR presence sensing.\n04  Power — outage detection with battery support.\n05  RFID — employee identification for inventory withdrawals.',
      ),
    ),
    gap(32),
    copy(
      bi(
        'O aplicativo Expo acompanha sensores e estoque. A central SafeTrack Center em C# reúne a gestão de estoque e funcionários. ',
        'The Expo app tracks sensors and inventory. The C# SafeTrack Center desktop hub brings inventory and employee management together. ',
      ),
    ),
    gap(40),
  ];
}
