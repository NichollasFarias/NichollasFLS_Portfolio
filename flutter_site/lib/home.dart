part of 'pages.dart';

extension _HomePageContent on _SitePageState {
  Widget home() {
    final small = MediaQuery.sizeOf(context).width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        split(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              eyebrow(
                bi(
                  'PORTFÓLIO / 2026 · SOFTWARE + ENGENHARIA',
                  'PORTFOLIO / 2026 · SOFTWARE + ENGINEERING',
                ),
              ),
              copy(
                'Nichollas F. L. Santos',
                size: 20,
                color: Colors.white,
                weight: FontWeight.w500,
              ),
              gap(16),
              heading(
                bi(
                  'Da ideia\nao mundo real.',
                  'From ideas\nto the real world.',
                ),
                size: small ? 49 : 76,
              ),
              gap(22),
              copy(
                bi(
                  'Eng. da Computação | Desenvolvedor de Software',
                  'Computer Engineer | Software Developer',
                ),
                size: 16,
                color: ice,
              ),
              gap(18),
              copy(
                bi(
                  'Engenheiro da Computação e desenvolvedor de software, transformo ideias em aplicativos e soluções práticas. Minha trajetória une programação, eletrônica, automação e a curiosidade por tecnologia que me acompanha desde criança.',
                  'As a Computer Engineer and software developer, I turn ideas into applications and practical solutions. My journey combines programming, electronics, automation, and a curiosity about technology that has been with me since childhood.',
                ),
              ),
              gap(30),
              Wrap(
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
              ),
              gap(34),
              copy(
                bi(
                  'GUARUJÁ · SÃO PAULO · BRASIL',
                  'GUARUJÁ · SÃO PAULO · BRAZIL',
                ),
                size: 11,
              ),
            ],
          ),
          portrait(),
        ),
        gap(72),
        const Divider(),
        gap(28),
        Wrap(
          spacing: 40,
          runSpacing: 18,
          children: [
            'FLUTTER / DART',
            'C# / PYTHON',
            'ESP32 / ARDUINO',
            'DESIGN + 3D',
          ].map((v) => copy(v, size: 12)).toList(),
        ),
        gap(80),
        eyebrow(
          bi('01 / ENGENHARIA EM PRÁTICA', '01 / ENGINEERING IN PRACTICE'),
        ),
        split(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              copy(
                bi('ESTUDO DE CASO · TCC 2024', 'CASE STUDY · CAPSTONE 2024'),
                size: 11,
                color: ice,
              ),
              gap(14),
              heading(
                bi(
                  'Um sistema.\nCinco conexões.',
                  'One system.\nFive connections.',
                ),
                size: small ? 38 : 50,
              ),
              gap(),
              copy(s.content.projects.first.text('text', s.lang)),
              gap(),
              tags(['ESP32', 'Expo', 'C#', 'Firebase']),
              gap(30),
              action(
                bi('Conheça o SafeTrack', 'Discover SafeTrack'),
                () => go('/project/safetrack'),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 1.3,
              child: ProjectImage(
                'tcc-overview.webp',
                label: bi(
                  'Protótipo físico SafeTrack',
                  'SafeTrack physical prototype',
                ),
              ),
            ),
          ),
        ),
        gap(80),
        sectionHeader(
          bi('02 / PROJETOS SELECIONADOS', '02 / SELECTED PROJECTS'),
          bi(
            'Código, propósito\ne personalidade.',
            'Code, purpose\nand personality.',
          ),
        ),
        gap(30),
        projectGrid(
          s.content.projects
              .where((p) => ['lembre', 'quimera', 'hunting'].contains(p.id))
              .toList(),
        ),
        gap(28),
        action(
          bi('Ver todos os projetos', 'See all projects'),
          () => go('/projects'),
          secondary: true,
        ),
        gap(80),
        split(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              eyebrow(bi('03 / ALÉM DA TELA', '03 / BEYOND THE SCREEN')),
              heading(
                bi(
                  'Curiosidade\né meu motor.',
                  'Curiosity\nis my driving force.',
                ),
              ),
              gap(),
              copy(
                bi(
                  'Dos experimentos de infância aos jogos digitais. Da engenharia aos aplicativos e à automação. Gosto de entender como as partes se conectam — e fazer a ideia funcionar.',
                  'From childhood experiments to digital games. From engineering to applications and automation. I enjoy understanding how the parts connect — and making ideas work.',
                ),
              ),
              gap(),
              action(
                bi('Minha trajetória', 'My journey'),
                () => go('/about'),
                secondary: true,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: panel,
              border: Border.all(color: line),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.code, size: 40, color: ice),
                gap(),
                heading(
                  bi(
                    'Software com\nvisão de engenharia.',
                    'Software with\nan engineering mindset.',
                  ),
                  size: 30,
                ),
                gap(),
                copy(
                  bi(
                    'Atuação na CodeCycle desde abril de 2025. Projetos autorais sob a assinatura Lancelot Forge.',
                    'Working at CodeCycle since April 2025. Independent projects under the Lancelot Forge signature.',
                  ),
                ),
              ],
            ),
          ),
        ),
        gap(80),
        contactBanner(),
      ],
    );
  }

  Widget portrait() => AspectRatio(
    aspectRatio: .91,
    child: CustomPaint(
      painter: CircuitPainter(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 18, 22, 30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
              child: const ProjectImage(
                'nichollas-profile.webp',
                label: 'Nichollas F. L. Santos',
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, ink.withValues(alpha: .96)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    copy(
                      'NICHOLLAS F. L. SANTOS',
                      color: Colors.white,
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    copy(
                      bi(
                        'CRIAR · CONECTAR · EVOLUIR',
                        'CREATE · CONNECT · EVOLVE',
                      ),
                      size: 10,
                      color: ice,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 18,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                color: ink.withValues(alpha: .85),
                child: copy('N / 2026', size: 11, color: ice),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
