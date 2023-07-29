import 'package:flutter/material.dart';

import '../core/colors.dart';

class StatusRecentUpdate extends StatelessWidget {
  const StatusRecentUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: const Color.fromARGB(255, 255, 253, 237),
      child: const Text(
        'Recent Updates',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: CustomColors.backgroundColor1,
        ),
      ),
    );
  }
}
