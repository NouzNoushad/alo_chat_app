import 'package:alo_chat_app/core/colors.dart';
import 'package:flutter/material.dart';

class FlowShaderMask extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration duration;
  final List<Color> flowColors;
  const FlowShaderMask(
      {super.key,
      required this.child,
      this.direction = Axis.horizontal,
      this.duration = const Duration(seconds: 2),
      this.flowColors = const [
        CustomColors.whiteColor,
        CustomColors.backgroundColor1
      ]});

  @override
  State<FlowShaderMask> createState() => _FlowShaderMaskState();
}

class _FlowShaderMaskState extends State<FlowShaderMask>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation startAnimation;
  late Animation middleAnimation;
  late Animation endAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration);
    final TweenSequenceItem lastToFirst = TweenSequenceItem(
        tween: ColorTween(
            begin: widget.flowColors.last, end: widget.flowColors.first),
        weight: 1);
    final TweenSequenceItem firstToLast = TweenSequenceItem(
        tween: ColorTween(
            begin: widget.flowColors.first, end: widget.flowColors.last),
        weight: 1);
    endAnimation = TweenSequence([lastToFirst, firstToLast]).animate(
        CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.45, curve: Curves.linear)));
    middleAnimation = TweenSequence([lastToFirst, firstToLast]).animate(
        CurvedAnimation(
            parent: controller,
            curve: const Interval(0.15, 0.75, curve: Curves.linear)));
    startAnimation = TweenSequence([lastToFirst, firstToLast]).animate(
        CurvedAnimation(
            parent: controller,
            curve: const Interval(0.45, 1, curve: Curves.linear)));
    controller.repeat();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rectangle) {
        return LinearGradient(
                colors: [
              startAnimation.value,
              middleAnimation.value,
              endAnimation.value
            ],
                begin: widget.direction == Axis.horizontal
                    ? Alignment.centerLeft
                    : Alignment.topCenter,
                end: widget.direction == Axis.horizontal
                    ? Alignment.centerRight
                    : Alignment.bottomCenter)
            .createShader(rectangle);
      },
      child: widget.child,
    );
  }
}
