part of 'pages.dart';

extension _ProfilePages on _SitePageState {
  Widget about() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionHeader(
        bi('SOBRE / A TRAJETÓRIA', 'ABOUT / THE JOURNEY'),
        bi(
          'Entender. Experimentar.\nConstruir.',
          'Understand. Experiment.\nBuild.',
        ),
      ),
      gap(36),
      split(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            copy(
              bi(
                'Minha relação com a tecnologia começou na infância: experimentos químicos simples, aparelhos desmontados e a vontade de descobrir como tudo funcionava. Robótica e mecatrônica sempre fizeram parte dessa curiosidade.',
                'My relationship with technology began in childhood: simple chemistry experiments, taking electronics apart and wanting to understand how everything worked. Robotics and mechatronics have always been part of that curiosity.',
              ),
            ),
            gap(),
            copy(
              bi(
                'No ensino médio, entrei na ETEC para estudar Jogos Digitais. Depois realizei o objetivo de cursar Engenharia da Computação, aproximando programação, eletrônica e automação. A formação técnica em Química ampliou meu interesse por ciência e processos.',
                'During high school, I enrolled at ETEC to study Digital Games. I then pursued my goal of studying Computer Engineering, bringing programming, electronics and automation together. Technical training in Chemistry expanded my interest in science and processes.',
              ),
            ),
            gap(),
            copy(
              bi(
                'Desde abril de 2025, trabalho com desenvolvimento de aplicativos na CodeCycle. Continuo explorando hardware, sistemas embarcados, novas tecnologias e projetos autorais.',
                'Since April 2025, I have worked on application development at CodeCycle. I continue to explore hardware, embedded systems, new technologies and independent projects.',
              ),
            ),
          ],
        ),
        portrait(),
      ),
      gap(70),
      eyebrow(bi('LINHA DO TEMPO', 'TIMELINE')),
      timeline(),
      gap(60),
      heading(
        bi('Especialidades em conexão.', 'Connected specialties.'),
        size: 36,
      ),
      gap(),
      tags([
        'Flutter / Dart',
        'FlutterFlow',
        'Firebase',
        'SQLite',
        'C#',
        'Python',
        'ESP32',
        'Arduino',
        'Fusion 360',
        'Git',
      ]),
      gap(60),
      contactBanner(),
    ],
  );
  Widget timeline() => Column(
    children: [
      timelineItem(
        '2019',
        bi('Técnico em Jogos Digitais', 'Digital Games technical training'),
        bi(
          'ETEC Aristóteles Ferreira · Unity, C# e projetos em equipe.',
          'ETEC Aristóteles Ferreira · Unity, C# and team projects.',
        ),
      ),
      timelineItem(
        '2024',
        bi('Engenharia da Computação', 'Computer Engineering'),
        bi(
          'Universidade Santa Cecília · TCC de segurança modular e publicação acadêmica.',
          'Universidade Santa Cecília · Modular security capstone and academic publication.',
        ),
      ),
      timelineItem(
        '2025',
        bi('Desenvolvimento profissional', 'Professional development'),
        bi(
          'CodeCycle desde abril · Desenvolvimento de aplicativos.',
          'CodeCycle since April · Application development.',
        ),
      ),
      timelineItem(
        '2026',
        bi('Química e projetos autorais', 'Chemistry and independent projects'),
        bi(
          'Liceu Santista · Formação técnica em Química e evolução dos produtos autorais.',
          'Liceu Santista · Chemistry technical training and independent product development.',
        ),
      ),
    ],
  );
  Widget timelineItem(String year, String title, String description) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: line)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 70, child: copy(year, color: ice, size: 15)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  copy(title, size: 22, color: Colors.white),
                  gap(8),
                  copy(description),
                ],
              ),
            ),
          ],
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
      gap(36),
      copy(
        bi(
          'As descrições respeitam o escopo público autorizado. GlobalTask e ShelfHive aparecem com participação técnica; não são divulgados código ou informações internas.',
          'Descriptions respect the authorized public scope. GlobalTask and ShelfHive are presented in terms of technical-team participation; no code or internal information is disclosed.',
        ),
      ),
      gap(60),
      contactBanner(),
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
      timelineItem(
        '2024',
        bi(
          'Bacharelado em Engenharia da Computação',
          'Bachelor’s degree in Computer Engineering',
        ),
        'Universidade Santa Cecília — Unisanta',
      ),
      timelineItem(
        '2019',
        bi(
          'Técnico em Programação de Jogos Digitais',
          'Technical qualification in Digital Game Programming',
        ),
        'ETEC Aristóteles Ferreira',
      ),
      timelineItem(
        '2026',
        bi('Técnico em Química', 'Technical qualification in Chemistry'),
        'Liceu Santista',
      ),
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
      gap(20),
      copy(
        bi(
          'A formação é apresentada em texto para preservar os dados pessoais dos documentos originais.',
          'Qualifications are presented as text to protect personal information in original documents.',
        ),
        size: 12,
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
      projectGrid(
        s.content.projects
            .where((p) => ['forge', 'lembre', 'quimera'].contains(p.id))
            .toList(),
      ),
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
