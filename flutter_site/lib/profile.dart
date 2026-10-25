part of 'pages.dart';

extension _ProfilePages on _SitePageState {
  Widget about() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionHeader(
        bi('01 / SOBRE MIM', '01 / ABOUT ME'),
        bi('Curiosidade é meu motor.', 'Curiosity drives me.'),
      ),
      gap(28),
      split(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            copy(
              bi(
                'Desde criança, sempre fui fascinado por ciência e computação. Fazia experimentos químicos simples e desmontava aparelhos para descobrir como funcionavam. Essa curiosidade também me aproximou da robótica e da mecatrônica.',
                'I have been fascinated by science and computing since childhood. I carried out simple chemistry experiments and took electronics apart to understand how they worked. That curiosity also drew me to robotics and mechatronics.',
              ),
            ),
            gap(),
            copy(
              bi(
                'No ensino médio, entrei na ETEC para estudar Jogos Digitais. Encontrei na Engenharia da Computação a oportunidade de conectar programação, eletrônica e automação. A formação técnica em Química ampliou meu interesse por ciência e processos.',
                'During high school, I enrolled at ETEC to study Digital Games. Computer Engineering gave me the opportunity to connect programming, electronics and automation. Technical training in Chemistry expanded my interest in science and processes.',
              ),
            ),
            gap(),
            tags([
              'Flutter / Dart',
              'FlutterFlow',
              'C#',
              'Python',
              'SQLite',
              'ESP32',
              'Arduino',
              'Fusion 360',
            ]),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: panel,
            border: Border.all(color: line),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_outlined, color: ice, size: 38),
              gap(),
              heading(
                bi(
                  'Imaginar com liberdade.\nConstruir com método.',
                  'Imagine freely.\nBuild with method.',
                ),
                size: 30,
              ),
              gap(),
              copy(
                bi(
                  'Ciência, jogos, software e hardware. Minha trajetória é feita das conexões entre essas áreas.',
                  'Science, games, software and hardware. My journey is built on the connections between these fields.',
                ),
              ),
            ],
          ),
        ),
      ),
      gap(48),
      timeline(),
    ],
  );
  Widget timeline() => Container(
    decoration: const BoxDecoration(
      border: Border(left: BorderSide(color: violet, width: 1)),
    ),
    child: Column(
      children: [
        timelineItem(
          bi('ORIGEM', 'ORIGIN'),
          bi('A curiosidade antes do código', 'Curiosity before code'),
          bi(
            'Experimentos, eletrônicos desmontados e o interesse por ciência, robótica e computação desde criança.',
            'Experiments, taking electronics apart and an interest in science, robotics and computing since childhood.',
          ),
          0,
        ),
        timelineItem(
          '2019',
          bi('ETEC · Jogos Digitais', 'ETEC · Digital Games'),
          bi(
            'Unity, programação e criação de narrativas, inimigos e cenários.',
            'Unity, programming and creating stories, enemies and environments.',
          ),
          1,
        ),
        timelineItem(
          bi('GRADUAÇÃO', 'UNIVERSITY'),
          bi(
            'Eletrônica, automação e robótica',
            'Electronics, automation and robotics',
          ),
          bi(
            'Aproximação entre código, sensores e protótipos físicos durante a faculdade.',
            'Connecting code, sensors and physical prototypes during college.',
          ),
          2,
        ),
        timelineItem(
          '2024',
          bi('Engenharia da Computação', 'Computer Engineering'),
          bi(
            'Unisanta · Sistema Modular de Segurança, SafeTrack Center e publicação no COBRIC.',
            'Unisanta · Modular Security System, SafeTrack Center and COBRIC publication.',
          ),
          3,
        ),
        timelineItem(
          bi('ABR 2025', 'APR 2025'),
          'CodeCycle',
          bi(
            'Início da atuação profissional no desenvolvimento de aplicativos.',
            'Beginning professional work in application development.',
          ),
          4,
        ),
        timelineItem(
          '2026',
          bi('Técnico em Química', 'Chemistry technical training'),
          bi(
            'Liceu Santista · Ciência aplicada, análise de resultados e processos.',
            'Liceu Santista · Applied science, results analysis and processes.',
          ),
          5,
        ),
        timelineItem(
          bi('EM EVOLUÇÃO', 'IN PROGRESS'),
          bi(
            'Projetos autorais · Lancelot Forge',
            'Independent projects · Lancelot Forge',
          ),
          bi(
            'Aplicativos próprios, serviços de tecnologia e criação em 3D.',
            'Independent applications, technology services and 3D creation.',
          ),
          6,
        ),
      ],
    ),
  );
  Widget timelineItem(
    String year,
    String title,
    String description, [
    int order = 0,
  ]) => Reveal(
    scroll: scroll,
    order: order,
    child: Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 28, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 16),
            child: RotatedBox(
              quarterTurns: 0,
              child: Icon(Icons.diamond_outlined, size: 16, color: ice),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                copy(year, size: 10, color: ice),
                gap(5),
                copy(
                  title,
                  size: 22,
                  color: Colors.white,
                  weight: FontWeight.w500,
                ),
                gap(8),
                copy(description, size: 14),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget experience() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionHeader(
        bi('EXPERIÊNCIA / CODECYCLE', 'EXPERIENCE / CODECYCLE'),
        bi('Código em movimento.', 'Code in motion.'),
      ),
      gap(30),
      copy(
        bi(
          'Desenvolvedor de Software / Aplicativos · abril de 2025 — presente',
          'Software / Application Developer · April 2025 — present',
        ),
        color: ice,
      ),
      gap(),
      copy(
        bi(
          'Atuo com desenvolvimento de software na CodeCycle. Minha experiência conecta interfaces, implementação de aplicativos e evolução de produtos em equipe técnica.',
          'I work in software development at CodeCycle. My experience connects interfaces, application implementation and product evolution as part of a technical team.',
        ),
      ),
      gap(30),
      tags([
        'FlutterFlow',
        'Flutter / Dart',
        'Firebase',
        'SQLite',
        'C#',
        'Git',
        'Azure',
      ]),
      gap(40),
      projectGrid(
        s.content.projects.where((p) => p.category == 'work').toList(),
      ),
      gap(60),
    ],
  );
  Widget education() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionHeader(
        bi(
          'FORMAÇÃO / CIÊNCIA + TECNOLOGIA',
          'EDUCATION / SCIENCE + TECHNOLOGY',
        ),
        bi(
          'Aprendizado que\natravessa áreas.',
          'Learning across\ndisciplines.',
        ),
      ),
      gap(36),
      CertificateCarousel(certificates: s.content.certificates),
      gap(60),
      eyebrow(bi('PUBLICAÇÃO ACADÊMICA', 'ACADEMIC PUBLICATION')),
      heading(
        bi('Sistema Modular\nde Segurança.', 'Modular Security\nSystem.'),
        size: 38,
      ),
      gap(),
      copy(
        bi(
          'Trabalho de Engenharia da Computação apresentado no COBRIC 2024. A publicação registra a pesquisa com coautoria acadêmica de Luis Fernando Pompeo Ferrara.',
          'Computer Engineering research presented at COBRIC 2024. The publication records the research with academic coauthor Luis Fernando Pompeo Ferrara.',
        ),
      ),
      gap(),
      action(
        bi('Ler publicação na Unisanta', 'Read publication at Unisanta'),
        () => external('https://periodicos.unisanta.br/COB/article/view/2305'),
        secondary: true,
      ),
      gap(50),
      heading(
        bi('Participação e idiomas.', 'Participation and languages.'),
        size: 32,
      ),
      gap(),
      copy(
        bi(
          '16º COBRIC · Apresentação de artigo (2024).\nBig Data & AI Brazil Experience · Participação em evento (22/11/2025).\nPortuguês nativo e inglês intermediário. Formação em inglês pela Wizard.',
          '16th COBRIC · Research presentation (2024).\nBig Data & AI Brazil Experience · Event participation (November 22, 2025).\nNative Portuguese and intermediate English. English studies at Wizard.',
        ),
      ),
    ],
  );
  Widget forge() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      eyebrow(
        bi(
          'LANCELOT FORGE / MARCA AUTORAL',
          'LANCELOT FORGE / INDEPENDENT BRAND',
        ),
      ),
      split(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading(
              bi(
                'Tecnologia forjada\ncom propósito.',
                'Technology forged\nwith purpose.',
              ),
            ),
            gap(),
            copy(
              bi(
                'Lancelot Forge é minha assinatura de serviços e projetos autorais. Uma conexão entre desenvolvimento de software, eletrônica, automação e criação em 3D.',
                'Lancelot Forge is my signature for services and independent projects. A connection between software development, electronics, automation and 3D creation.',
              ),
            ),
            gap(),
            action(
              bi('Conversar sobre um projeto', 'Discuss a project'),
              () => go('/contact'),
            ),
          ],
        ),
        const AspectRatio(
          aspectRatio: 1.7,
          child: ProjectImage(
            'forge-horizontal.webp',
            label: 'Lancelot Forge',
            fit: BoxFit.contain,
          ),
        ),
      ),
      gap(64),
      heading(
        bi(
          'Da aplicação à peça física.',
          'From applications to physical objects.',
        ),
        size: 36,
      ),
      gap(30),
      LayoutBuilder(
        builder: (_, c) => Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            service(
              Icons.code,
              bi('Software & sistemas', 'Software & systems'),
              bi(
                'Aplicativos, sistemas e soluções web.',
                'Applications, systems and web solutions.',
              ),
              c.maxWidth,
            ),
            service(
              Icons.memory,
              bi('Automação & eletrônica', 'Automation & electronics'),
              bi(
                'Automação, eletrônica e sistemas embarcados.',
                'Automation, electronics and embedded systems.',
              ),
              c.maxWidth,
            ),
            service(
              Icons.support_agent,
              bi('TI & conhecimento', 'IT & knowledge'),
              bi(
                'Suporte em TI, consultoria e aulas.',
                'IT support, consulting and lessons.',
              ),
              c.maxWidth,
            ),
            service(
              Icons.view_in_ar,
              bi('Criação em 3D', '3D creation'),
              bi(
                'Modelagem, impressão 3D, pintura e acabamento de peças.',
                'Modeling, 3D printing, painting and finishing.',
              ),
              c.maxWidth,
            ),
          ],
        ),
      ),
      gap(64),
      heading(bi('Projetos da forja.', 'Projects from the forge.'), size: 36),
      gap(28),
      projectGrid(s.content.projects.where((p) => p.belongsToForge).toList()),
    ],
  );
  Widget service(
    IconData icon,
    String title,
    String description,
    double width,
  ) => Container(
    width: width < 650 ? width : (width - 24) / 2,
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: panel,
      border: Border.all(color: line),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: ice, size: 30),
        gap(),
        copy(title, size: 23, color: Colors.white),
        gap(12),
        copy(description),
      ],
    ),
  );
  Widget contact() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionHeader(
        bi('CONTATO / VAMOS CONVERSAR', 'CONTACT / LET’S TALK'),
        bi(
          'Seu próximo projeto\npode começar aqui.',
          'Your next project\ncan start here.',
        ),
      ),
      gap(30),
      copy(
        bi(
          'Aberto a oportunidades profissionais, projetos de aplicativos e colaborações em tecnologia.',
          'Open to professional opportunities, application projects and technology collaborations.',
        ),
      ),
      gap(38),
      Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          action(
            'ni.chollas@outlook.com',
            () => external('mailto:ni.chollas@outlook.com'),
          ),
          action(bi('Copiar e-mail', 'Copy email'), () async {
            await Clipboard.setData(
              const ClipboardData(text: 'ni.chollas@outlook.com'),
            );
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(bi('E-mail copiado.', 'Email copied.'))),
              );
            }
          }, secondary: true),
        ],
      ),
      gap(32),
      Wrap(
        spacing: 18,
        runSpacing: 18,
        children: [
          action(
            '(13) 99720-2766',
            () => external('tel:+5513997202766'),
            secondary: true,
          ),
          action(
            'GitHub',
            () => external('https://github.com/NichollasFarias'),
            secondary: true,
          ),
          action(
            'LinkedIn',
            () => external('https://www.linkedin.com/in/nichollas-farias/'),
            secondary: true,
          ),
        ],
      ),
      gap(40),
      copy(
        bi('Guarujá — São Paulo — Brasil', 'Guarujá — São Paulo — Brazil'),
        color: ice,
      ),
      gap(70),
      const Divider(),
      gap(26),
      copy(
        bi(
          'Privacidade: este portfólio não possui formulário, rastreamento ou backend próprio. A preferência de idioma é salva apenas neste navegador.',
          'Privacy: this portfolio has no contact form, tracking or custom backend. Your language preference is stored only in this browser.',
        ),
        size: 13,
      ),
    ],
  );
}
