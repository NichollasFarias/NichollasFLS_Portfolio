part of 'pages.dart';

extension _HomePageContent on _SitePageState {
  Widget hero() {
    final small = MediaQuery.sizeOf(context).width < 760;
    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        eyebrow(
          bi(
            'ENGENHARIA · SOFTWARE · CRIAÇÃO',
            'ENGINEERING · SOFTWARE · CREATION',
          ),
        ),
        copy(
          'Nichollas F. L. Santos',
          size: 20,
          color: Colors.white,
          weight: FontWeight.w500,
        ),
        gap(20),
        Semantics(
          header: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading(bi('Da ideia', 'From ideas'), size: small ? 54 : 78),
              ShaderMask(
                shaderCallback: (r) => const LinearGradient(
                  colors: [Color(0xFFC4C5D1), Color(0xFFB07CF2), ice],
                ).createShader(r),
                child: heading(
                  bi('ao mundo real.', 'to the real world.'),
                  size: small ? 49 : 74,
                ),
              ),
            ],
          ),
        ),
        gap(24),
        copy(
          bi(
            'Eng. da Computação | Desenvolvedor de Software',
            'Computer Engineer | Software Developer',
          ),
          size: 16,
          color: ice,
        ),
        if (!small) ...[
          gap(22),
          biography(),
          gap(28),
          heroActions(),
          gap(32),
          location(),
        ],
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (small) ...[
          intro,
          gap(28),
          Center(child: SizedBox(width: 330, height: 350, child: portrait())),
          gap(28),
          biography(),
          gap(26),
          heroActions(),
          gap(26),
          location(),
        ] else
          split(intro, portrait(), left: 6, right: 5),
        gap(40),
        Wrap(
          spacing: 28,
          runSpacing: 12,
          children: [
            'FLUTTER / DART',
            'C# / PYTHON',
            'ESP32 / ARDUINO',
            'DESIGN + 3D',
          ].map((v) => copy(v, size: 11)).toList(),
        ),
        gap(24),
        Center(
          child: TextButton.icon(
            onPressed: () => go('/about'),
            icon: const Icon(Icons.south, size: 16),
            label: Text(
              bi('PERCORRA A JORNADA', 'EXPLORE THE JOURNEY'),
              style: const TextStyle(fontSize: 10, letterSpacing: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget biography() => copy(
    bi(
      'Engenheiro da Computação e desenvolvedor de software, transformo ideias em aplicativos e soluções práticas. Minha trajetória une programação, eletrônica, automação e a curiosidade por tecnologia que me acompanha desde criança.',
      'As a Computer Engineer and software developer, I turn ideas into applications and practical solutions. My journey combines programming, electronics, automation, and a curiosity about technology that has been with me since childhood.',
    ),
  );
  Widget location() => copy(
    bi('GUARUJÁ · SÃO PAULO · BRASIL', 'GUARUJÁ · SÃO PAULO · BRAZIL'),
    size: 10,
  );
  Widget heroActions() => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      action(
        bi('Explorar projetos', 'Explore projects'),
        () => go('/projects'),
      ),
      action(
        bi('Vamos conversar', 'Get in touch'),
        () => go('/contact'),
        secondary: true,
      ),
    ],
  );
  Widget portrait() => AspectRatio(
    aspectRatio: .92,
    child: CustomPaint(
      foregroundPainter: HeraldicFrame(),
      child: Padding(
        padding: const EdgeInsets.all(23),
        child: ClipPath(
          clipper: const ShieldClipper(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColorFiltered(
                colorFilter: ColorFilter.matrix([
                  .82,
                  .08,
                  .08,
                  0,
                  0,
                  .08,
                  .82,
                  .08,
                  0,
                  0,
                  .08,
                  .08,
                  .82,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
                child: ProjectImage(
                  'nichollas-profile.webp',
                  label: 'Nichollas F. L. Santos',
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      violet.withValues(alpha: .09),
                      Colors.transparent,
                      ink.withValues(alpha: .93),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 22,
                child: copy('N / 2026', size: 10, color: Colors.white),
              ),
              Positioned(
                bottom: 52,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const Icon(
                      Icons.keyboard_double_arrow_up,
                      color: ice,
                      size: 18,
                    ),
                    gap(8),
                    copy(
                      bi(
                        'CRIAR · CONECTAR · EVOLUIR',
                        'CREATE · CONNECT · EVOLVE',
                      ),
                      size: 9,
                      color: silver,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  Widget featured() {
    final p = s.content.projects.firstWhere((p) => p.id == 'safetrack');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(
          bi('02 / PROJETOS EM DESTAQUE', '02 / FEATURED PROJECTS'),
          bi('Ideias que ganharam forma.', 'Ideas that took shape.'),
        ),
        gap(32),
        Container(
          padding: EdgeInsets.all(
            MediaQuery.sizeOf(context).width < 600 ? 20 : 36,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF21152F), panel]),
            border: Border.all(color: line),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomRight: Radius.circular(42),
            ),
          ),
          child: split(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                eyebrow(
                  bi('TCC DE ENGENHARIA / 2024', 'ENGINEERING CAPSTONE / 2024'),
                ),
                heading(
                  bi(
                    'Um sistema.\nCinco conexões.',
                    'One system.\nFive connections.',
                  ),
                  size: MediaQuery.sizeOf(context).width < 600 ? 36 : 46,
                ),
                gap(22),
                copy(p.text('text', s.lang)),
                gap(),
                tags(p.tech),
                gap(28),
                action(
                  bi('Explorar estudo de caso', 'Explore case study'),
                  () => openProject(p.id),
                ),
              ],
            ),
            HoverCard(
              label: bi('Abrir SafeTrack', 'Open SafeTrack'),
              onTap: () => openProject(p.id),
              child: AspectRatio(
                aspectRatio: 1.15,
                child: ProjectImage(
                  'tcc-overview.webp',
                  label: p.text('title', s.lang),
                ),
              ),
            ),
          ),
        ),
        gap(32),
        projectGrid(
          s.content.projects
              .where((p) => ['lembre', 'quimera', 'linecar'].contains(p.id))
              .toList(),
        ),
      ],
    );
  }
}
