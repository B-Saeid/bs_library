// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_ui_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A Provider that returns a boolean value based on the internet connection
/// There is a global Singleton-Configured Presentation Logic that will be
/// called per listener e.g. a Widget that cares for internet connection.
///
///
/// Q: Why we pass an optional BuildContext?
///
/// A: For showing connection-indicating overlays.
///
/// Since we use a [globalNavigatorKey] ,that is set in our router
/// in [RoutesBase], we have a couple of use cases:
///   I.  Under [RoutesBase.router] i.e. the normal app.
///   II. Above [RoutesBase.router] e.g. a wrapping feedback flow.
///
/// Either ways, overlays are presented by [BsOverlay], that uses
/// [RoutesBase.globalNavigatorKey] by default, if no context is passed,
/// which is fine for case I.
///
/// But in case II, In order for overlays to be properly shown
/// above the entire app, [BuildContext] from such app-wrapping
/// flows is necessary to be passed because otherwise the overlays
/// will be shown inside the app and not above it, which is not intended.

@ProviderFor(IsConnectedWithUI)
const isConnectedWithUIProvider = IsConnectedWithUIFamily._();

/// A Provider that returns a boolean value based on the internet connection
/// There is a global Singleton-Configured Presentation Logic that will be
/// called per listener e.g. a Widget that cares for internet connection.
///
///
/// Q: Why we pass an optional BuildContext?
///
/// A: For showing connection-indicating overlays.
///
/// Since we use a [globalNavigatorKey] ,that is set in our router
/// in [RoutesBase], we have a couple of use cases:
///   I.  Under [RoutesBase.router] i.e. the normal app.
///   II. Above [RoutesBase.router] e.g. a wrapping feedback flow.
///
/// Either ways, overlays are presented by [BsOverlay], that uses
/// [RoutesBase.globalNavigatorKey] by default, if no context is passed,
/// which is fine for case I.
///
/// But in case II, In order for overlays to be properly shown
/// above the entire app, [BuildContext] from such app-wrapping
/// flows is necessary to be passed because otherwise the overlays
/// will be shown inside the app and not above it, which is not intended.
final class IsConnectedWithUIProvider
    extends $NotifierProvider<IsConnectedWithUI, bool?> {
  /// A Provider that returns a boolean value based on the internet connection
  /// There is a global Singleton-Configured Presentation Logic that will be
  /// called per listener e.g. a Widget that cares for internet connection.
  ///
  ///
  /// Q: Why we pass an optional BuildContext?
  ///
  /// A: For showing connection-indicating overlays.
  ///
  /// Since we use a [globalNavigatorKey] ,that is set in our router
  /// in [RoutesBase], we have a couple of use cases:
  ///   I.  Under [RoutesBase.router] i.e. the normal app.
  ///   II. Above [RoutesBase.router] e.g. a wrapping feedback flow.
  ///
  /// Either ways, overlays are presented by [BsOverlay], that uses
  /// [RoutesBase.globalNavigatorKey] by default, if no context is passed,
  /// which is fine for case I.
  ///
  /// But in case II, In order for overlays to be properly shown
  /// above the entire app, [BuildContext] from such app-wrapping
  /// flows is necessary to be passed because otherwise the overlays
  /// will be shown inside the app and not above it, which is not intended.
  const IsConnectedWithUIProvider._({
    required IsConnectedWithUIFamily super.from,
    required BuildContext? super.argument,
  }) : super(
         retry: null,
         name: r'isConnectedWithUIProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isConnectedWithUIHash();

  @override
  String toString() {
    return r'isConnectedWithUIProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  IsConnectedWithUI create() => IsConnectedWithUI();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsConnectedWithUIProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isConnectedWithUIHash() => r'220a0d6aa91eb486271838c8ac96d021a3fa4f0f';

/// A Provider that returns a boolean value based on the internet connection
/// There is a global Singleton-Configured Presentation Logic that will be
/// called per listener e.g. a Widget that cares for internet connection.
///
///
/// Q: Why we pass an optional BuildContext?
///
/// A: For showing connection-indicating overlays.
///
/// Since we use a [globalNavigatorKey] ,that is set in our router
/// in [RoutesBase], we have a couple of use cases:
///   I.  Under [RoutesBase.router] i.e. the normal app.
///   II. Above [RoutesBase.router] e.g. a wrapping feedback flow.
///
/// Either ways, overlays are presented by [BsOverlay], that uses
/// [RoutesBase.globalNavigatorKey] by default, if no context is passed,
/// which is fine for case I.
///
/// But in case II, In order for overlays to be properly shown
/// above the entire app, [BuildContext] from such app-wrapping
/// flows is necessary to be passed because otherwise the overlays
/// will be shown inside the app and not above it, which is not intended.

final class IsConnectedWithUIFamily extends $Family
    with
        $ClassFamilyOverride<
          IsConnectedWithUI,
          bool?,
          bool?,
          bool?,
          BuildContext?
        > {
  const IsConnectedWithUIFamily._()
    : super(
        retry: null,
        name: r'isConnectedWithUIProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A Provider that returns a boolean value based on the internet connection
  /// There is a global Singleton-Configured Presentation Logic that will be
  /// called per listener e.g. a Widget that cares for internet connection.
  ///
  ///
  /// Q: Why we pass an optional BuildContext?
  ///
  /// A: For showing connection-indicating overlays.
  ///
  /// Since we use a [globalNavigatorKey] ,that is set in our router
  /// in [RoutesBase], we have a couple of use cases:
  ///   I.  Under [RoutesBase.router] i.e. the normal app.
  ///   II. Above [RoutesBase.router] e.g. a wrapping feedback flow.
  ///
  /// Either ways, overlays are presented by [BsOverlay], that uses
  /// [RoutesBase.globalNavigatorKey] by default, if no context is passed,
  /// which is fine for case I.
  ///
  /// But in case II, In order for overlays to be properly shown
  /// above the entire app, [BuildContext] from such app-wrapping
  /// flows is necessary to be passed because otherwise the overlays
  /// will be shown inside the app and not above it, which is not intended.

  IsConnectedWithUIProvider call([BuildContext? context]) =>
      IsConnectedWithUIProvider._(argument: context, from: this);

  @override
  String toString() => r'isConnectedWithUIProvider';
}

/// A Provider that returns a boolean value based on the internet connection
/// There is a global Singleton-Configured Presentation Logic that will be
/// called per listener e.g. a Widget that cares for internet connection.
///
///
/// Q: Why we pass an optional BuildContext?
///
/// A: For showing connection-indicating overlays.
///
/// Since we use a [globalNavigatorKey] ,that is set in our router
/// in [RoutesBase], we have a couple of use cases:
///   I.  Under [RoutesBase.router] i.e. the normal app.
///   II. Above [RoutesBase.router] e.g. a wrapping feedback flow.
///
/// Either ways, overlays are presented by [BsOverlay], that uses
/// [RoutesBase.globalNavigatorKey] by default, if no context is passed,
/// which is fine for case I.
///
/// But in case II, In order for overlays to be properly shown
/// above the entire app, [BuildContext] from such app-wrapping
/// flows is necessary to be passed because otherwise the overlays
/// will be shown inside the app and not above it, which is not intended.

abstract class _$IsConnectedWithUI extends $Notifier<bool?> {
  late final _$args = ref.$arg as BuildContext?;
  BuildContext? get context => _$args;

  bool? build([BuildContext? context]);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
