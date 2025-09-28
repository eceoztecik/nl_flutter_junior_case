import 'package:jr_case_boilerplate/features/auth/models/user_model.dart';

class AuthResponseModel {
  final String token;
  final UserModel user;

  AuthResponseModel({required this.token, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return AuthResponseModel(
      token: data['token'] ?? '',
      user: UserModel.fromJson(data),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user.toJson()};
  }
}
