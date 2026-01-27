import 'package:flutter/material.dart';

/// This inheritance is added originally to access
/// `description` independently on apple platforms.
abstract class AbstractTile extends StatelessWidget {
  const AbstractTile({super.key});

  Widget? get description => null;
}
