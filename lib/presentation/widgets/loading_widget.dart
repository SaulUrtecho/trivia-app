// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
