import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:alo_chat_app/alo_status/service/alo_status_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/colors.dart';
import 'package:screenshot/screenshot.dart';
part 'alo_status_state.dart';

class AloStatusCubit extends Cubit<AloStatusState> {
  final AloStatusService aloStatusService;
  AloStatusCubit({required this.aloStatusService}) : super(AloStatusInitial());

  StreamController statusController = StreamController.broadcast();
  StreamSink get statusSink => statusController.sink;
  Stream get statusStream => statusController.stream;

  Color randomColor = CustomColors.purpleColor;
  ScreenshotController screenshotController = ScreenshotController();

  FocusNode statusTextFocusNode = FocusNode();

  rearrangeStatus() async {
    List statusList = await aloStatusService.rearrangeStatus();
    statusSink.add(statusList);
  }

  generateRandomColor() {
    randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    emit(DisplayRandomColor());
  }

  captureScreenShot(context) {
    screenshotController.capture(pixelRatio: 2.5).then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File(
                '${directory.path}/${DateTime.now()}_alo_status_image.png')
            .create();
        await imagePath.writeAsBytes(image);
        print('///////////////// image screenshot path: $imagePath');
        await aloStatusService.captureScreenShot(imagePath);
        rearrangeStatus();
      }
    });
    Navigator.pop(context);
  }

  captureStatusImage(context, source) async {
    ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: source);
    if (file != null) {
      String filePath = file.path;
      File imagePath = File(filePath);
      print('///////////////// image path: $imagePath');
      await aloStatusService.captureScreenShot(imagePath);
      rearrangeStatus();
    }
  }

  @override
  Future<void> close() {
    statusController.close();
    return super.close();
  }
}
