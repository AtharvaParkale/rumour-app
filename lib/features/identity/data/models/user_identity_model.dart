import '../../domain/entities/user_identity.dart';

class UserIdentityModel extends UserIdentity {
  const UserIdentityModel({
    required super.id,
    required super.name,
    required super.avatar,
  });

  factory UserIdentityModel.fromJson(Map<String, dynamic> json) {
    return UserIdentityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }
}
