import 'package:flutter/material.dart';
import "package:story_view/story_view.dart";

class AloStatusStory extends StatefulWidget {
  final statusModel;
  const AloStatusStory({super.key, required this.statusModel});

  @override
  State<AloStatusStory> createState() => _AloStatusStoryState();
}

class _AloStatusStoryState extends State<AloStatusStory> {
  final controller = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: StoryView(
              storyItems: List.generate(
                  widget.statusModel['status_images'].length, (index) {
                return StoryItem.pageImage(
                    url: widget.statusModel['status_images'][index]['image'],
                    controller: controller);
              }).toList(),
              controller: controller,
              // repeat: true,
              onStoryShow: (s) {},
              onComplete: () {
                Future.delayed(const Duration(milliseconds: 800), () {
                  Navigator.pop(context);
                });
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              }),
        ));
  }
}
