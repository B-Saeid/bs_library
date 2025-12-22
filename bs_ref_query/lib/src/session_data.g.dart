// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LiveData)
const liveDataProvider = LiveDataProvider._();

final class LiveDataProvider
    extends $NotifierProvider<LiveData, LiveDataState> {
  const LiveDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveDataHash();

  @$internal
  @override
  LiveData create() => LiveData();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveDataState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveDataState>(value),
    );
  }
}

String _$liveDataHash() => r'e56f8f247acc59a6e400473942ba0faa92988227';

abstract class _$LiveData extends $Notifier<LiveDataState> {
  LiveDataState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LiveDataState, LiveDataState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LiveDataState, LiveDataState>,
              LiveDataState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
