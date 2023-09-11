import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/colors.dart';

class ChatsListContainer extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String aboutStatus;
  final String createdOn;
  final double radius;
  final Widget seenWidget;
  final Color backgroundColor;
  final void Function()? onTap;
  const ChatsListContainer(
      {super.key,
      required this.imageUrl,
      required this.userName,
      required this.aboutStatus,
      required this.createdOn,
      required this.seenWidget,
      required this.radius,
      required this.backgroundColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Row(children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: CustomColors.backgroundColor2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 55,
                  width: 55,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Container(),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.w500,
                          color: CustomColors.backgroundDarkColor1,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        aboutStatus,
                        style: const TextStyle(
                            fontSize: 14.5,
                            color: CustomColors.backgroundColor1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      createdOn,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.backgroundColor1,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    seenWidget,
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
