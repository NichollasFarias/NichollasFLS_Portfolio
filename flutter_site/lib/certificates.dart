import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'app.dart';
import 'components.dart';
import 'content.dart';
import 'media.dart';

class CertificateCarousel extends StatefulWidget {
  final List<Certificate> certificates;
  const CertificateCarousel({super.key, required this.certificates});
  @override
  State<CertificateCarousel> createState() => _CertificateCarouselState();
}

class _CertificateCarouselState extends State<CertificateCarousel> {
  PageController? controller;
  double fraction = 0;
  int index = 0;
  int perPage = 1;
  int get pages => (widget.certificates.length / perPage).ceil();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.sizeOf(context).width;
    final next = width > 1000 ? 1.0 : .94;
    final nextPerPage = width > 1000 ? 2 : 1;
    if (perPage != nextPerPage) {
      index = (index * perPage / nextPerPage).floor();
      perPage = nextPerPage;
    }
    if (fraction != next) {
      controller?.dispose();
      fraction = next;
      controller = PageController(
        viewportFraction: fraction,
        initialPage: index,
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void move(int delta) {
    final target = (index + delta).clamp(0, pages - 1);
    if (MediaQuery.disableAnimationsOf(context)) {
      controller!.jumpToPage(target);
    } else {
      controller!.animateToPage(
        target,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Widget certificateCard(Certificate cert, PortfolioScope s) {
    return Padding(
      padding: const EdgeInsets.only(right: 18, bottom: 8),
      child: HoverCard(
        key: Key('certificate-${cert.id}'),
        label: '${s.bi('Ampliar', 'Enlarge')} ${cert.text('name', s.lang)}',
        onTap: () => showCertificate(context, cert),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 205,
              width: double.infinity,
              color: const Color(0xFFE7E5E3),
              padding: const EdgeInsets.all(12),
              child: ProjectImage(
                cert.file,
                label: cert.text('name', s.lang),
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: copy(
                          cert.text('type', s.lang).toUpperCase(),
                          size: 10,
                          color: ice,
                        ),
                      ),
                      copy(cert.year, size: 12),
                    ],
                  ),
                  gap(12),
                  Text(
                    cert.text('name', s.lang),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  gap(10),
                  copy(cert.institution, size: 12),
                  gap(10),
                  copy(
                    s.bi('VER PRÉVIA PÚBLICA  ↗', 'VIEW PUBLIC PREVIEW  ↗'),
                    size: 10,
                    color: ice,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = PortfolioScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: copy(
                s.bi('ARRASTE PARA EXPLORAR', 'DRAG TO EXPLORE'),
                size: 11,
                color: ice,
              ),
            ),
            copy(
              '${(index * perPage + 1).toString().padLeft(2, '0')}${perPage == 2 ? '–${((index + 1) * perPage).clamp(1, widget.certificates.length).toString().padLeft(2, '0')}' : ''} / ${widget.certificates.length.toString().padLeft(2, '0')}',
              size: 12,
            ),
            const SizedBox(width: 12),
            IconButton(
              key: const Key('certificate-previous'),
              tooltip: s.bi('Certificado anterior', 'Previous certificate'),
              onPressed: index == 0 ? null : () => move(-1),
              icon: const Icon(Icons.west),
            ),
            IconButton(
              key: const Key('certificate-next'),
              tooltip: s.bi('Próximo certificado', 'Next certificate'),
              onPressed: index == pages - 1 ? null : () => move(1),
              icon: const Icon(Icons.east),
            ),
          ],
        ),
        gap(16),
        SizedBox(
          height: MediaQuery.textScalerOf(context).scale(1) > 1.3 ? 570 : 490,
          child: ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
                PointerDeviceKind.trackpad,
              },
            ),
            child: PageView.builder(
              key: const Key('certificate-pager'),
              controller: controller,
              padEnds: true,
              allowImplicitScrolling: true,
              itemCount: pages,
              onPageChanged: (v) => setState(() => index = v),
              itemBuilder: (_, page) => Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var col = 0; col < perPage; col++)
                    Expanded(
                      child: page * perPage + col < widget.certificates.length
                          ? certificateCard(
                              widget.certificates[page * perPage + col],
                              s,
                            )
                          : const SizedBox(),
                    ),
                ],
              ),
            ),
          ),
        ),
        gap(16),
        copy(
          s.bi(
            'Prévias dos documentos reais. Dados pessoais, identificadores e assinaturas foram ocultados; os originais foram preservados.',
            'Previews of real documents. Personal data, identifiers and signatures have been hidden; originals are preserved.',
          ),
          size: 12,
        ),
      ],
    );
  }
}

Future<void> showCertificate(BuildContext context, Certificate cert) async {
  final position = Scrollable.maybeOf(context)?.position;
  final previousOffset = position?.pixels;
  await showDialog<void>(
    context: context,
    animationStyle: MediaQuery.disableAnimationsOf(context)
        ? AnimationStyle.noAnimation
        : null,
    builder: (ctx) {
      final s = PortfolioScope.of(ctx);
      return Dialog(
        key: const Key('certificate-preview'),
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 900),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${cert.text('name', s.lang)} · ${cert.year}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      key: const Key('certificate-close'),
                      tooltip: s.bi('Fechar prévia', 'Close preview'),
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: ProjectImage(
                      cert.file,
                      label: cert.text('name', s.lang),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    copy(cert.text('note', s.lang), size: 12),
                    gap(6),
                    copy(
                      s.bi(
                        'PRÉVIA PÚBLICA · DADOS PRIVADOS OCULTADOS',
                        'PUBLIC PREVIEW · PRIVATE DATA HIDDEN',
                      ),
                      size: 10,
                      color: ice,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  if (context.mounted && position != null && previousOffset != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted && position.hasPixels) {
        position.jumpTo(previousOffset.clamp(0, position.maxScrollExtent));
      }
    });
  }
}
