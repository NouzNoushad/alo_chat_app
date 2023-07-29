import 'package:flutter/material.dart';

import '../../core/colors.dart';

class ProfilePhoto extends StatelessWidget {
  final String title;
  final IconData icon;
  final double radius;
  final void Function()? onTap;
  const ProfilePhoto(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap, 
      required this.radius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: CustomColors.backgroundColor1,
            radius: radius,
            child: Icon(
              icon,
              color: CustomColors.backgroundColor2,
              size: 25,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: const TextStyle(
              color: CustomColors.backgroundColor1,
            ),
          )
        ],
      ),
    );
  }
}
