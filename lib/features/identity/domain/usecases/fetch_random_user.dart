import '../entities/user_identity.dart';
import '../repositories/identity_repository.dart';

class FetchRandomUser {
  final IdentityRepository repository;

  FetchRandomUser(this.repository);

  Future<UserIdentity> call() {
    return repository.fetchRandomUser();
  }
}
