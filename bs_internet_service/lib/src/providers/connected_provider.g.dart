// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IsConnected)
const isConnectedProvider = IsConnectedProvider._();

final class IsConnectedProvider extends $NotifierProvider<IsConnected, bool?> {
  const IsConnectedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isConnectedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isConnectedHash();

  @$internal
  @override
  IsConnected create() => IsConnected();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool?>(value),
    );
  }
}

String _$isConnectedHash() => r'c19926cb9802c4162d4b9c192454865bd63bd22a';

abstract class _$IsConnected extends $Notifier<bool?> {
  bool? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool?, bool?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool?, bool?>,
              bool?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
