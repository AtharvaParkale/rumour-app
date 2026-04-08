import '../entities/user_identity.dart';
import '../repositories/identity_repository.dart';

class GetLocalIdentity {
  final IdentityRepository repository;

  GetLocalIdentity(this.repository);

  Future<UserIdentity?> call(String roomId) {
    return repository.getLocalIdentity(roomId);
  }
}
