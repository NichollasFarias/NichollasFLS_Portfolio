# Nichollas F. L. Santos — Flutter Web v1.0.0

Portfólio bilíngue PT-BR/EN, sem backend. Flutter 3.41.5 / Dart 3.11.3, null safety. Conteúdo local em `assets/content.json` e mídias selecionadas em `assets/media/`.

## Desenvolvimento

Flutter SDK com suporte web é necessário apenas para editar/recompilar:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
flutter build web --release --base-href /NichollasFLS_Portfolio/ --no-web-resources-cdn
```

O build deve ser servido por HTTP; não abrir `index.html` como file://. A entrega inclui um inicializador por duplo clique para Windows.

## Arquitetura

- `main.dart`: bootstrap e preferência persistida.
- `app.dart`: tema, idiomas e navegação por hash.
- `pages.dart`, `home.dart`, `profile.dart`, `projects.dart`: páginas e catálogo.
- `content.dart`: modelos e filtros combináveis.
- `components.dart`: componentes e circuitos vetoriais.
- `media.dart`: imagem, galeria com zoom e vídeo sem autoplay.

O idioma vem de um único estado herdado. A preferência usa SharedPreferences; indisponibilidade de armazenamento mantém a preferência apenas na sessão. Rotas: `#/`, `#/projects`, `#/about`, `#/experience`, `#/education`, `#/forge`, `#/contact`, `#/project/<id>`. Rotas desconhecidas têm recuperação para a Home. Hash routing permite atualizar diretamente sem regras de rewrite no Pages.

Mídias de vídeo só são inicializadas ao abrir a galeria. Imagens locais são carregadas pelo bundle e reutilizadas pelo cache Flutter. Os mockups são identificados como composições, sem comprovar cada recurso ilustrado. Textos originais dentro das mídias permanecem fiéis às imagens fornecidas.

## GitHub Pages

URL atual verificada: https://nichollasfarias.github.io/NichollasFLS_Portfolio/

Base configurada: `/NichollasFLS_Portfolio/`. O workflow manual valida o build; a implantação exige escolher `publish=true` e confirmar antes que Pages use GitHub Actions. O SDK é fixado em 3.41.5 stable no CI. Nenhum push comum inicia publicação. Se hospedar na raiz de outro domínio, recompile com `--base-href /`.

Ao usar este projeto como subpasta `flutter_site` do repositório histórico, o workflow da raiz deve executar comandos em `flutter_site` e enviar `flutter_site/build/web` ao Pages.

## Conteúdo e privacidade

Atualize ambas as línguas dos campos de cada projeto. Nunca incluir credenciais, documentos originais com dados pessoais ou projetos excluídos. Não inserir código de TCC no bundle web. Sem analytics, rastreamento ou formulário. Idioma é o único dado persistido.

Ao publicar outra compilação, atualize o token de release em web/index.html e web/flutter_bootstrap.js para invalidar o cache do entrypoint.
