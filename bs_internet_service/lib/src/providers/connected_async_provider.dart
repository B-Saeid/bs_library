import 'package:bs_utils/bs_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../service.dart';
import 'connected_provider.dart';

part 'connected_async_provider.g.dart';

@riverpod
Future<bool> isConnectedAsync(Ref ref) async {
  final connected = ref.watch(isConnectedProvider);
  if (connected == null) await MethodsUtils.waitUntil(() => Internet.connected != null);
  return connected ?? Internet.connected!;
}
