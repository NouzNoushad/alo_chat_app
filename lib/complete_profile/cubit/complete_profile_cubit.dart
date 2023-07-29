import 'dart:async';
import 'package:alo_chat_app/alo_chats/service/user_service.dart';
import 'package:alo_chat_app/complete_profile/service/complete_profile.dart';
import 'package:alo_chat_app/core/colors.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../alo_home/screens/alo_home_screen.dart';
import '../../core/constants.dart';
import '../../model/user_model.dart';
import '../../sign_up/service/validator_service.dart';
import '../../widgets/dialog_box.dart';
import '../screens/complete_profile.dart';

part 'complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  CompleteProfileService completeProfileService;
  CompleteProfileCubit({required this.completeProfileService})
      : super(CompleteProfileInitial());

  StreamController profileController = StreamController.broadcast();
  StreamSink get profileSink => profileController.sink;
  Stream get profileStream => profileController.stream;

  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();

  FocusNode profileNameFocusNode = FocusNode();
  FocusNode profileAboutFocusNode = FocusNode();
  FocusNode profilePhoneNoFocusNode = FocusNode();

  ValidatorService validatorService = ValidatorService();

  String selectedCountry = countryCodes.first;
  String imageFilePath = '';
  bool editText = false;

  countryCodeValueChanged(String value) {
    selectedCountry = value;
    emit(CountryValueChanged());
  }

  pickProfileImage(context, source) async {
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      cropProfileImage(image);
    }
    Navigator.pop(context);
  }

  cropProfileImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        compressQuality: 20,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
    if (croppedImage != null) {
      imageFilePath = croppedImage.path;
      emit(UploadProfileImage());
    }
  }

  showEditTextField() {
    editText = true;
    emit(EditTextField());
  }

  String? nameValidator(String? value) {
    return validatorService.nameValidator(nameController.text);
  }

  String? aboutValidator(String? value) {
    return validatorService.aboutValidator(aboutController.text);
  }

  String? phoneNoValidator(String? value) {
    return validatorService.phoneNoValidator(phoneNoController.text);
  }

  getProfileDetails() async {
    var user = await UserService().getUserDetails();
    profileSink.add(user);
  }

  createAndUpdateProfile(context, userModel, imageFile, nickName, aboutStatus,
      phoneNo, profileType) async {
    var navigator = Navigator.of(context);
    var response = await completeProfileService.createUserProfile(
      userModel,
      imageFile,
      nickName,
      aboutStatus,
      phoneNo,
    );
    if (profileType == ProfileType.complete) {
      if (response == CompleteProfileStatus.successful) {
        showAlertDialog(
          context: context,
          title: 'Success',
          content: 'Your profile created successfully',
          status: Status.success,
        );
        Future.delayed(const Duration(seconds: 2), () {
          // Navigate to Home page
          navigator.pushReplacement(
              MaterialPageRoute(builder: (context) => const AloHomeScreen()));
        });
      } else if (response == CompleteProfileStatus.failed) {
        showAlertDialog(
          context: context,
          title: 'Error',
          content: 'Something went wrong',
          status: Status.failed,
        );
      }
      Future.delayed(const Duration(seconds: 2), () {
        nameController.text = '';
        aboutController.text = '';
        phoneNoController.text = '';
      });
    } else if (profileType == ProfileType.update) {
      if (response == CompleteProfileStatus.successful) {
        navigator.pushReplacement(MaterialPageRoute(
            builder: (context) => const CompleteProfile(
                  profileType: ProfileType.update,
                )));
        Fluttertoast.showToast(
            msg: 'Profile updated',
            backgroundColor: CustomColors.whiteColor,
            textColor: CustomColors.backgroundColor1);
      } else if (response == CompleteProfileStatus.failed) {
        Fluttertoast.showToast(
            msg: 'Something went wrong',
            backgroundColor: CustomColors.whiteColor,
            textColor: CustomColors.backgroundColor1);
      }
    }
  }

  updateUserProfile(context, UserModel userModel) async {
    String imageFile =
        imageFilePath != '' ? imageFilePath : userModel.profilePic;
    String nickName = nameController.text.trim() != ''
        ? nameController.text.trim()
        : userModel.nickName;
    String aboutStatus = aboutController.text.trim() != ''
        ? aboutController.text.trim()
        : userModel.about;
    String phoneNo = userModel.phoneNo;
    createAndUpdateProfile(context, userModel, imageFile, nickName, aboutStatus,
        phoneNo, ProfileType.update);
  }

  createUserProfile(context, UserModel userModel) async {
    String imageFile = imageFilePath;
    String nickName = nameController.text.trim();
    String aboutStatus = aboutController.text.trim();
    String phoneNo = phoneNoController.text.trim();

    if (aboutStatus == '') {
      aboutStatus = 'Hey there! i am using Alo Chat';
    } else {
      aboutStatus = aboutStatus;
    }
    String countryCodePhoneNo = '$selectedCountry $phoneNo';
    createAndUpdateProfile(context, userModel, imageFile, nickName, aboutStatus,
        countryCodePhoneNo, ProfileType.complete);
  }

  @override
  Future<void> close() {
    nameController.clear();
    aboutController.clear();
    phoneNoController.clear();
    return super.close();
  }
}
