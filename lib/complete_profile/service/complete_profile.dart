import 'dart:io';
import 'package:alo_chat_app/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../model/user_model.dart';

class CompleteProfileService {
  CompleteProfileStatus status = CompleteProfileStatus.pending;

  Future<CompleteProfileStatus> createUserProfile(
      UserModel userModel,
      String imagePath,
      String nickName,
      String aboutStatus,
      String phoneNo) async {
    String imageUrl = '';
    
    if (imagePath == '') {
      imageUrl = profileImage;
    } else if (imagePath == userModel.profilePic) {
      imageUrl = imagePath;
    } else {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('profilePic')
          .child(userModel.uid)
          .putFile(File(imagePath));
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    userModel.profilePic = imageUrl;
    userModel.nickName = nickName;
    userModel.about = aboutStatus;
    userModel.phoneNo = phoneNo;

    await FirebaseFirestore.instance
        .collection(dbName)
        .doc(userModel.uid)
        .set(userModelToMap(userModel))
        .then((value) {
      status = CompleteProfileStatus.successful;
    }).catchError((err) {
      status = CompleteProfileStatus.failed;
    });
    return status;
  }
}
