import '../entities/user_identity.dart';

abstract class IdentityRepository {
  Future<UserIdentity?> getLocalIdentity(String roomId);
  Future<void> saveIdentity(String roomId, UserIdentity user);
  Future<UserIdentity> fetchRandomUser();
}
