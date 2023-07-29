StatusModel statusModelFromMap(Map<String, dynamic> data) =>
    StatusModel.fromMap(data);

Map<String, dynamic> statusModelToMap(StatusModel data) => data.toMap();

class StatusModel {
  String userId;
  String userName;
  String userEmail;
  String profileImage;
  List<StatusImage> statusImages;
  DateTime createdOn;

  StatusModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.profileImage,
    required this.statusImages,
    required this.createdOn,
  });

  factory StatusModel.fromMap(Map<String, dynamic> json) => StatusModel(
        userId: json["user_id"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        profileImage: json["profile_image"],
        statusImages: List<StatusImage>.from(
            json["status_images"].map((x) => StatusImage.fromJson(x))),
        createdOn: json["created_on"].toDate(),
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "user_name": userName,
        "user_email": userEmail,
        "profile_image": profileImage,
        "status_images": List<dynamic>.from(statusImages.map((x) => x.toMap())),
        "created_on": createdOn,
      };
}

class StatusImage {
  String image;
  DateTime publishedAt;

  StatusImage({
    required this.image,
    required this.publishedAt,
  });

  factory StatusImage.fromJson(Map<String, dynamic> json) => StatusImage(
        image: json["image"],
        publishedAt: json["published_at"].toDate(),
      );

  Map<String, dynamic> toMap() => {
        "image": image,
        "published_at": publishedAt,
      };
}
