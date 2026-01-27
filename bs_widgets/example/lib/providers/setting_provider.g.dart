// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Setting)
const settingProvider = SettingProvider._();

final class SettingProvider extends $NotifierProvider<Setting, SettingState> {
  const SettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingHash();

  @$internal
  @override
  Setting create() => Setting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingState>(value),
    );
  }
}

String _$settingHash() => r'b5a6288e845ba8a762185db803ca6abd31dc0ae4';

abstract class _$Setting extends $Notifier<SettingState> {
  SettingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SettingState, SettingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingState, SettingState>,
              SettingState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
