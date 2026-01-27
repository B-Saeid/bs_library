import 'dart:typed_data';

import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../adaptive/adaptive_loading_indicator.dart';
import '../crafted/ring_progress.dart';
import '../riverpod_widgets/consumer_or_stateless.dart';
import 'custom_animated_size.dart';

class AnimatedLoadedImage extends ConsumerOrStatelessWidget {
  AnimatedLoadedImage.memory({
    super.key,
    required Uint8List bytes,
    this.errorBuilder,
    this.fit,
    this.filterQuality = FilterQuality.high,
    this.isAntiAlias = true,
  }) : _bytes = bytes,
       _url = null,
       _path = null,
       _imageProvider = MemoryImage(bytes);

  AnimatedLoadedImage.asset({
    super.key,
    required String path,
    this.errorBuilder,
    this.fit,
    this.filterQuality = FilterQuality.high,
    this.isAntiAlias = true,
  }) : _path = path,
       _url = null,
       _bytes = null,
       _imageProvider = AssetImage(path);

  AnimatedLoadedImage.network({
    super.key,
    required String url,
    this.errorBuilder,
    this.fit,
    this.filterQuality = FilterQuality.high,
    this.isAntiAlias = true,
  }) : _url = url,
       _bytes = null,
       _path = null,
       _imageProvider = NetworkImage(url);

  final ImageProvider _imageProvider;
  final Uint8List? _bytes;
  final String? _path;
  final String? _url;

  int get _hashCode => _path?.hashCode ?? _url?.hashCode ?? _bytes!.hashCode;

  /// A builder function that is called if an error occurs during image loading.
  ///
  /// If this builder is not provided, any exceptions will be reported to
  /// [FlutterError.onError]. If it is provided, the caller should either handle
  /// the exception by providing a replacement widget, or rethrow the exception.
  ///
  /// {@tool dartpad}
  /// The following sample uses [errorBuilder] to show a '😢' in place of the
  /// image that fails to load, and prints the error to the console.
  ///
  /// ** See code in examples/api/lib/widgets/image/image.error_builder.0.dart **
  /// {@end-tool}
  final ImageErrorWidgetBuilder? errorBuilder;

  /// How to inscribe the image into the space allocated during layout.
  ///
  /// The default varies based on the other fields. See the discussion at
  /// [paintImage].
  final BoxFit? fit;

  /// The rendering quality of the image.
  ///
  /// {@template flutter.widgets.image.filterQuality}
  /// If the image is of a high quality and its pixels are perfectly aligned
  /// with the physical screen pixels, extra quality enhancement may not be
  /// necessary. If so, then [FilterQuality.none] would be the most efficient.
  ///
  /// If the pixels are not perfectly aligned with the screen pixels, or if the
  /// image itself is of a low quality, [FilterQuality.none] may produce
  /// undesirable artifacts. Consider using other [FilterQuality] values to
  /// improve the rendered image quality in this case. Pixels may be misaligned
  /// with the screen pixels as a result of transforms or scaling.
  ///
  /// Defaults to [FilterQuality.medium].
  ///
  /// See also:
  ///
  ///  * [FilterQuality], the enum containing all possible filter quality
  ///    options.
  /// {@endtemplate}
  final FilterQuality filterQuality;

  /// Whether to paint the image with anti-aliasing.
  ///
  /// Anti-aliasing alleviates the sawtooth artifact when the image is rotated.
  final bool isAntiAlias;

  @override
  Widget build(BuildContext context, WidgetRef? ref) {
    return Image(
      image: _imageProvider,
      errorBuilder:
          errorBuilder ??
          (context, error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  child: Text(
                    'Something went wrong❗',
                    textAlign: TextAlign.center,
                    style: LiveDataOrQuery.textTheme(ref: ref, context: context).headlineSmall,
                  ),
                ),
              ),
            ),
          ),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => CustomAnimatedSize(
        child: KeyedSubtree(
          key: ValueKey(frame),
          child: frame == null
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: AdaptiveLoadingIndicator()),
                )
              : child,
        ),
      ),
      loadingBuilder: (context, child, loadingProgress) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic.flipped,
        child: loadingProgress == null || loadingProgress.expectedTotalBytes == null
            ? child
            : KeyedSubtree(
                key: ValueKey(_hashCode),
                child: Center(
                  child: RingProgress(
                    key: ValueKey(_hashCode),
                    progress:
                        loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!,
                  ),
                ),
              ),
      ),
      fit: fit,
      filterQuality: filterQuality,
      isAntiAlias: isAntiAlias,
    );
  }
}
