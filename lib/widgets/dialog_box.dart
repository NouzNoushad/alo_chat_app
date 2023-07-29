import 'package:alo_chat_app/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../core/constants.dart';

class CustomDialogBox extends StatelessWidget {
  final String? title;
  final String? content;
  final Status? status;
  const CustomDialogBox({super.key, this.title, this.content, this.status});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Animate(
      effects: const [
        ScaleEffect(),
        ShakeEffect(
          delay: Duration(milliseconds: 400),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Dialog(
          backgroundColor: CustomColors.backgroundColor2,
          insetPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
            left: Radius.circular(50),
            right: Radius.circular(50),
          )),
          child: Container(
            height: size.height * 0.50,
            width: size.width * 0.5,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(50),
                right: Radius.circular(50),
              ),
              color: CustomColors.backgroundColor2,
            ),
            padding: const EdgeInsets.all(6),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    status == Status.success
                        ? 'assets/lottie/successful.json'
                        : 'assets/lottie/payment-failed.json',
                  ),
                  Text(
                    title!,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: CustomColors.backgroundColor1),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    width: size.width * 0.5,
                    child: Text(
                      content!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: CustomColors.backgroundColor1),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: size.width * 0.2,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.backgroundColor1,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(60),
                              right: Radius.circular(60),
                            ))),
                        child: const Text(
                          'Ok',
                          style: TextStyle(
                            color: CustomColors.backgroundColor2,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                ]),
          ),
        ),
      ),
    );
  }
}

showAlertDialog(
        {required BuildContext context,
        required String title,
        required String content,
        required Status status}) =>
    showDialog(
        context: context,
        builder: (context) => CustomDialogBox(
              title: title,
              content: content,
              status: status,
            ));
