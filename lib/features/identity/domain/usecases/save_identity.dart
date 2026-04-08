import '../entities/user_identity.dart';
import '../repositories/identity_repository.dart';

class SaveIdentity {
  final IdentityRepository repository;

  SaveIdentity(this.repository);

  Future<void> call(String roomId, UserIdentity user) {
    return repository.saveIdentity(roomId, user);
  }
}
