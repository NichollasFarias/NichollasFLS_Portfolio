# Nichollas F. L. Santos — Flutter Web v1.1.1

Evolução da v1.0.0 em Flutter/Dart. Uma página contínua: Hero, Sobre e linha do tempo, destaques, catálogo de 22 projetos, CodeCycle, formação e certificados, Lancelot Forge, contato e rodapé.

## Executar e validar

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
flutter build web --release --base-href /NichollasFLS_Portfolio/ --no-web-resources-cdn
```

O build estático precisa ser servido por HTTP. A entrega contém um inicializador por duplo clique para Windows. Não abrir index.html por file://.

## Navegação e estado

- Um SitePage permanece montado com um ScrollController e âncoras GlobalKey. O menu chama Scrollable.ensureVisible e fecha o drawer mobile.
- A posição, busca, filtros e índice do carrossel continuam ativos ao fechar uma sobreposição.
- Projetos abrem por showGeneralDialog, com fechamento fixo, compartilhamento de link e rolagem própria. Links #/project/<id> abrem o mesmo modal sobre a Home; o botão voltar do navegador fecha o modal. Links antigos de seções são tratados como atalhos para rolagem, sem páginas visuais adicionais.
- Português/inglês usam o estado herdado da v1.0.0. A chave SharedPreferences portfolio.language foi preservada.
- Progresso e seção ativa usam ValueNotifier para evitar reconstrução da página a cada pixel.

## Organização

- app.dart / main.dart: inicialização, tema e idiomas.
- pages.dart: shell Single Page, âncoras, progresso e modais.
- home.dart / profile.dart / projects.dart: seções, catálogo e estudos de caso.
- content.dart: modelos, metadados e filtros combináveis.
- certificates.dart: PageView, dois documentos por página em desktop, um em mobile, setas, arraste e ampliação.
- motion.dart: reveal de entrada, executado uma vez por elemento ao entrar no viewport.
- heraldry.dart: geometrias de escudo, molduras metálicas e divisórias ornamentais, desenhadas em código.
- media.dart: imagens, zoom e player sob demanda, sem autoplay.

## Conteúdo e certificados

assets/content.json mantém os 22 projetos e suas fichas PT/EN. A coleção forge reúne Lembre & Pague, 3D Print, Quimera, NeuroLaudo e Traverna, sem duplicar objetos. Quimera também aparece no tema Química. Créditos de equipe são discretos e separados da descrição do produto.

certificates contém metadados traduzidos, instituição, ano e nome de uma prévia WebP pública. Não adicione PDFs ou fotografias brutas de documentos. As seis prévias fornecidas foram rasterizadas/achatadas com identificação pessoal, nascimento, códigos de validação, números de documentos e campos privados ocultados conforme aplicável. Os originais ficam fora do código e do build.

O ano principal é a conclusão/participação. A legenda diferencia emissão: Engenharia concluída em 2024, diploma de 2025; Jogos concluído em 2019, diploma de 2021. A instituição emissora de Química foi conferida no documento. O comprovante Big Data & AI representa participação em evento, sem alegação de certificação técnica. O curso Wizard não altera o nível aprovado de inglês intermediário.

Textos dentro das mídias autênticas continuam no idioma original; os metadados e as legendas são bilíngues. Os cinco vídeos da v1.0.0 foram preservados, sem faixas de áudio.

## Movimento e responsividade

Sem loop de partículas ou animações decorativas permanentes. Reveal, scroll programático, hover, galeria e modal de projetos consultam MediaQuery.disableAnimations. PageView aceita touch, mouse, trackpad e stylus. Animações de widgets padrão seguem o comportamento do framework.

## Publicação e reversão

URL: https://nichollasfarias.github.io/NichollasFLS_Portfolio/

Base: /NichollasFLS_Portfolio/. Código na branch flutter-v1.1.1; distribuição na pages-flutter-v1.1.1. A versão anterior permanece em flutter-v1.1.0 e pages-flutter-v1.1.0; a v1.0.0 também foi preservada. O Pages usa publicação legacy a partir da raiz da branch de distribuição, com .nojekyll. Somente o build estático é publicado.

O workflow preparado é manual e exige configuração Pages para GitHub Actions antes de usá-lo como alternativa. O deploy desta entrega utiliza o build validado localmente. Para reverter, selecione pages-flutter-v1.1.0 e /(root) em Settings > Pages, salve e aguarde o build, sem force-push.

Ao publicar outra compilação, altere o token de release em web/index.html e web/flutter_bootstrap.js para evitar reuso do entrypoint pelo cache. O token desta entrega é 1.1.1-r1.
