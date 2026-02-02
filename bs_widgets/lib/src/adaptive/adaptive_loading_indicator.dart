import 'package:bs_ref_query/bs_ref_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveLoadingIndicator extends StatelessWidget {
  const AdaptiveLoadingIndicator({super.key, this.value, this.targetPlatform});

  final double? value;
  final TargetPlatform? targetPlatform;

  bool get isApple => (targetPlatform ?? StaticData.targetPlatform).isApple;

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
