import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:bs_utils/bs_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveLoadingIndicator extends StatelessWidget {
  const AdaptiveLoadingIndicator({super.key, this.value, this.platform});

  final double? value;
  final DevicePlatform? platform;

  bool get isApple => (platform ?? StaticData.platform).isApple;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    child: isApple
        ? const CupertinoActivityIndicator()
        : CircularProgressIndicator(
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
            value: value,
          ),
  );
}
