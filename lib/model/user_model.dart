UserModel userModelFromMap(Map<String, dynamic> data) =>
    UserModel.fromMap(data);

Map<String, dynamic> userModelToMap(UserModel data) => data.toMap();

class UserModel {
  String uid;
  String fullName;
  String nickName;
  String email;
  String phoneNo;
  String profilePic;
  String about;
  DateTime? createdOn;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.nickName,
    required this.email,
    required this.phoneNo,
    required this.profilePic,
    required this.about,
    this.createdOn,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
      uid: json["uid"],
      fullName: json["full_name"],
      nickName: json["nick_name"],
      email: json["email"],
      phoneNo: json["phone_no"],
      profilePic: json["profile_pic"],
      about: json["about"],
      createdOn: json["created_on"].toDate());

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "full_name": fullName,
        "nick_name": nickName,
        "email": email,
        "phone_no": phoneNo,
        "profile_pic": profilePic,
        "about": about,
        "created_on": createdOn,
      };
}
