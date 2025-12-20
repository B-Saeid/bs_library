import 'package:flutter/material.dart';

abstract class AbstractTile extends StatelessWidget {
  const AbstractTile({super.key});

  Widget? get description => null;

  bool get hasLeading => true;
}
