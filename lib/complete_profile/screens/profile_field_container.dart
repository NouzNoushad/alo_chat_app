import 'package:flutter/material.dart';

import '../../core/colors.dart';

class ProfileFieldContainer extends StatelessWidget {
  final IconData leadingIcon;
  final Widget textWidget;
  final IconData? trailingIcon;
  final void Function()? onTap;
  const ProfileFieldContainer(
      {super.key,
      required this.textWidget,
      required this.leadingIcon,
      this.onTap,
      this.trailingIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.078,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: CustomColors.backgroundColor2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(
            leadingIcon,
            size: 18,
            color: CustomColors.backgroundColor1,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: textWidget
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: onTap,
            child: Icon(
              trailingIcon,
              size: 22,
              color: CustomColors.backgroundColor1,
            ),
          ),
        ],
      ),
    );
  }
}
