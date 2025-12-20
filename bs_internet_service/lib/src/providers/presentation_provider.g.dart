// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(internetPresentation)
const internetPresentationProvider = InternetPresentationProvider._();

final class InternetPresentationProvider
    extends
        $FunctionalProvider<
          InternetPresentationBase,
          InternetPresentationBase,
          InternetPresentationBase
        >
    with $Provider<InternetPresentationBase> {
  const InternetPresentationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'internetPresentationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$internetPresentationHash();

  @$internal
  @override
  $ProviderElement<InternetPresentationBase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InternetPresentationBase create(Ref ref) {
    return internetPresentation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InternetPresentationBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InternetPresentationBase>(value),
    );
  }
}

String _$internetPresentationHash() =>
    r'f24d6d50b13dbc610f78d2eaa2067fdb648e0ee9';
