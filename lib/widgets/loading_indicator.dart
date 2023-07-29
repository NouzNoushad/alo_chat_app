import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../core/colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: LoadingIndicator(
          indicatorType: Indicator.ballScale,
          colors: [
            CustomColors.backgroundColor,
          ],
          pathBackgroundColor: CustomColors.backgroundColor2,
          strokeWidth: 4,
        ),
      ),
    );
  }
}
