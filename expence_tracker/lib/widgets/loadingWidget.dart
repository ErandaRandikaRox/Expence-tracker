import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double radius;
  final bool addPadding;

  const LoadingWidget({super.key, required this.radius, required this.addPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: addPadding ? const EdgeInsets.all(16.0) : EdgeInsets.zero,
      child: Center(child: CircularProgressIndicator(strokeWidth: radius)),
    );
  }
}