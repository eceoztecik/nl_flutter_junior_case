class UploadPhotoResponseModel {
  final String photoUrl;

  UploadPhotoResponseModel({required this.photoUrl});

  factory UploadPhotoResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return UploadPhotoResponseModel(photoUrl: data['photoUrl'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'photoUrl': photoUrl};
  }
}
