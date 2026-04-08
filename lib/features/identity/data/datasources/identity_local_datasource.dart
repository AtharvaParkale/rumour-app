import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_identity_model.dart';

abstract class IdentityLocalDataSource {
  Future<UserIdentityModel?> getIdentity(String roomId);
  Future<void> saveIdentity(String roomId, UserIdentityModel user);
}

class IdentityLocalDataSourceImpl implements IdentityLocalDataSource {
  final SharedPreferences sharedPreferences;

  IdentityLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserIdentityModel?> getIdentity(String roomId) async {
    final jsonString = sharedPreferences.getString(roomId);
    if (jsonString != null) {
      return UserIdentityModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> saveIdentity(String roomId, UserIdentityModel user) async {
    final jsonString = json.encode(user.toJson());
    await sharedPreferences.setString(roomId, jsonString);
  }
}
