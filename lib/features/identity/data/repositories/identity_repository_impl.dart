import '../../domain/entities/user_identity.dart';
import '../../domain/repositories/identity_repository.dart';
import '../datasources/identity_local_datasource.dart';
import '../datasources/identity_remote_datasource.dart';
import '../models/user_identity_model.dart';

class IdentityRepositoryImpl implements IdentityRepository {
  final IdentityLocalDataSource localDataSource;
  final IdentityRemoteDataSource remoteDataSource;

  IdentityRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<UserIdentity?> getLocalIdentity(String roomId) async {
    return await localDataSource.getIdentity(roomId);
  }

  @override
  Future<void> saveIdentity(String roomId, UserIdentity user) async {
    final model = UserIdentityModel(
      id: user.id,
      name: user.name,
      avatar: user.avatar,
    );
    await localDataSource.saveIdentity(roomId, model);
  }

  @override
  Future<UserIdentity> fetchRandomUser() async {
    return await remoteDataSource.fetchRandomUser();
  }
}
