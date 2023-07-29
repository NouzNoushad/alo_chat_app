import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/colors.dart';

class DeleteButton extends StatelessWidget {
  final void Function()? onPressed;
  const DeleteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: CustomColors.backgroundColor2,
                  title: const Text(
                    'Delete message?',
                    style: TextStyle(
                        color: CustomColors.backgroundDarkColor1, fontSize: 18),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: onPressed,
                        child: const Text('Delete')),
                  ],
                ));
      },
      padding: const EdgeInsets.only(right: 20),
      icon: const Icon(
        Icons.delete,
        color: CustomColors.backgroundColor2,
      ),
    ).animate().scale(
        duration: const Duration(milliseconds: 800),
        begin: const Offset(2, 2),
        end: const Offset(1, 1));
  }
}
