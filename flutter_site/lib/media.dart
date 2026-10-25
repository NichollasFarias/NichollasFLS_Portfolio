import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ProjectImage extends StatelessWidget {
  final String file;
  final String label;
  final BoxFit fit;
  const ProjectImage(
    this.file, {
    super.key,
    required this.label,
    this.fit = BoxFit.cover,
  });
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/media/$file',
    fit: fit,
    semanticLabel: label,
    filterQuality: FilterQuality.medium,
    errorBuilder: (_, _, _) => Center(child: Text(label)),
    frameBuilder: (context, child, frame, synchronous) =>
        frame == null && !synchronous
        ? const Center(
            child: Icon(Icons.image_outlined, color: Color(0xFF35C5F4)),
          )
        : child,
  );
}

Future<void> openGallery(
  BuildContext context,
  List<List<String>> media,
  int index,
  String label,
  String close,
) => showDialog<void>(
  context: context,
  builder: (_) =>
      MediaGallery(media: media, initial: index, label: label, close: close),
);

class MediaGallery extends StatefulWidget {
  final List<List<String>> media;
  final int initial;
  final String label;
  final String close;
  const MediaGallery({
    super.key,
    required this.media,
    required this.initial,
    required this.label,
    required this.close,
  });
  @override
  State<MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<MediaGallery> {
  late int index = widget.initial;
  void move(int delta) =>
      setState(() => index = (index + delta) % widget.media.length);
  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.all(16),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 850),
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () => move(-1),
          const SingleActivator(LogicalKeyboardKey.arrowRight): () => move(1),
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.label} · ${index + 1}/${widget.media.length}',
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      tooltip: widget.close,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: widget.media[index][0] == 'video'
                      ? SilentVideo(
                          widget.media[index][1],
                          key: ValueKey(index),
                          label: widget.label,
                        )
                      : InteractiveViewer(
                          minScale: 1,
                          maxScale: 4,
                          child: Center(
                            child: ProjectImage(
                              widget.media[index][1],
                              label: widget.label,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: '←',
                    onPressed: () => move(-1),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text('${index + 1} / ${widget.media.length}'),
                  IconButton(
                    tooltip: '→',
                    onPressed: () => move(1),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    ),
  );
}

class SilentVideo extends StatefulWidget {
  final String file;
  final String label;
  const SilentVideo(this.file, {super.key, required this.label});
  @override
  State<SilentVideo> createState() => _SilentVideoState();
}

class _SilentVideoState extends State<SilentVideo> {
  late final VideoPlayerController controller;
  String? error;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset('assets/media/${widget.file}');
    controller
        .initialize()
        .then((_) {
          if (mounted) {
            setState(() {});
          }
        })
        .catchError((Object e) {
          if (mounted) {
            setState(() => error = widget.label);
          }
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(child: Text(error!));
    }
    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
        VideoProgressIndicator(
          controller,
          allowScrubbing: true,
          padding: const EdgeInsets.all(16),
        ),
        IconButton(
          tooltip: controller.value.isPlaying
              ? 'Pause / Pausar'
              : 'Play / Reproduzir',
          icon: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () async {
            if (controller.value.isPlaying) {
              await controller.pause();
            } else {
              await controller.play();
            }
            if (mounted) {
              setState(() {});
            }
          },
        ),
      ],
    );
  }
}
