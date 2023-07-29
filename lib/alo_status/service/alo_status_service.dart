import 'dart:io';
import 'package:alo_chat_app/core/constants.dart';
import 'package:alo_chat_app/core/helpers.dart';
import 'package:alo_chat_app/model/status_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../../alo_chats/service/user_service.dart';
import '../../core/colors.dart';
import '../../model/user_model.dart';

class AloStatusService {
  UserService userService = UserService();
  SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
  List<StatusImage> statusImages = [];

  Future<StatusModel?> findMyStatus() async {
    StatusModel? statusModel;
    String? savedEmail = await sharedPreferencesHelper.getEmail();
    var checkMyStatus = await FirebaseFirestore.instance
        .collection(statusDbName)
        .where('user_email', isEqualTo: savedEmail)
        .get();
    print('///////////// doc email $savedEmail');
    print('///////////// doc ${checkMyStatus.docs}');
    if (checkMyStatus.docs.isNotEmpty) {
      Map<String, dynamic>? myStatus = checkMyStatus.docs[0].data();
      statusModel = statusModelFromMap(myStatus);
    }
    return statusModel;
  }

  Future<List<StatusModel>> rearrangeStatus() async {
    var myStatus = await findMyStatus();
    List<StatusModel> rearrangeList = [];
    if (myStatus != null) {
      var statusList =
          await FirebaseFirestore.instance.collection(statusDbName).get();
      List<StatusModel> statusModel = statusList.docs
          .map((status) => statusModelFromMap(status.data()))
          .toList();
      print(
          '/////////////////RRRRRRRRRRRRRRRRRRRRRRRR=> my Status ${myStatus.userEmail}');
      for (var element in statusModel) {
        if (element.userEmail == myStatus.userEmail) {
          rearrangeList.insert(0, element);
        } else {
          rearrangeList.add(element);
        }
      }
      print(
          '/////////////////RRRRRRRRRRRRRRRRRRRRRRRR=>   rearrangedList, ${rearrangeList[0].userEmail}');
    }

    return rearrangeList;
  }

  saveStatus(UserModel userModel, StatusModel statusModel) async {
    await FirebaseFirestore.instance
        .collection(statusDbName)
        .doc(userModel.uid)
        .set(statusModelToMap(statusModel))
        .then((value) {
      print('///////////////////////===>>>>>>>>>>> Status created');
      Fluttertoast.showToast(
          msg: "Status created",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: CustomColors.whiteColor,
          textColor: CustomColors.backgroundDarkColor,
          fontSize: 14.0);
    }).catchError((err) {
      print(
          '////////////////////======>>>>>>>>>>> Failed to create status $err');
    });
  }

  captureScreenShot(File imagePath) async {
    UserModel userModel = await userService.getUserDetails();
    TaskSnapshot snapshot = await FirebaseStorage.instance
        .ref('statusImage')
        .child(const Uuid().v1())
        .putFile(imagePath);
    String imageUrl = await snapshot.ref.getDownloadURL();
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection(statusDbName)
        .where('user_id', isEqualTo: userModel.uid)
        .get();
    if (userSnapshot.docs.isNotEmpty) {
      print('/////////////=========>>>>>>>> status exists');
      var statusData = userSnapshot.docs[0].data();
      StatusModel existingStatusModel =
          statusModelFromMap(statusData as Map<String, dynamic>);
      StatusImage statusImage =
          StatusImage(image: imageUrl, publishedAt: DateTime.now());
      existingStatusModel.statusImages.add(statusImage);
      existingStatusModel.createdOn = DateTime.now();
      saveStatus(userModel, existingStatusModel);
    } else {
      print('/////////////=========>>>>>>>> No status exists');
      StatusImage statusImage =
          StatusImage(image: imageUrl, publishedAt: DateTime.now());
      statusImages.add(statusImage);
      StatusModel newStatusModel = StatusModel(
          userId: userModel.uid,
          userName: userModel.nickName,
          userEmail: userModel.email,
          profileImage: userModel.profilePic,
          statusImages: statusImages,
          createdOn: DateTime.now());
      saveStatus(userModel, newStatusModel);
    }
  }
}
