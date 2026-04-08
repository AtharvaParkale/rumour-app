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

  static const String _globalIdentityKey = 'global_device_identity';

  @override
  Future<UserIdentityModel?> getIdentity(String roomId) async {
    // Ignore incoming roomId strictly enforcing a single shared global identity per hardware device
    final jsonString = sharedPreferences.getString(_globalIdentityKey);
    if (jsonString != null) {
      return UserIdentityModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> saveIdentity(String roomId, UserIdentityModel user) async {
    final jsonString = json.encode(user.toJson());
    // Persist explicitly to the global key masking out room partitions
    await sharedPreferences.setString(_globalIdentityKey, jsonString);
  }
}
