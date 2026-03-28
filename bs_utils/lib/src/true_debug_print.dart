import 'package:flutter/foundation.dart' show kDebugMode;

void dprint(Object? object) => !kDebugMode ? null : print(object);
