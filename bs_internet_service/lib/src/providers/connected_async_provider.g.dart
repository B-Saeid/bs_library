// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_async_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isConnectedAsync)
const isConnectedAsyncProvider = IsConnectedAsyncProvider._();

final class IsConnectedAsyncProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const IsConnectedAsyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isConnectedAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isConnectedAsyncHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isConnectedAsync(ref);
  }
}

String _$isConnectedAsyncHash() => r'86106023c320b82afa1d3506a183ce0743aabca2';
