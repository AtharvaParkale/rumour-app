import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_remote_datasource.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createOrJoinRoom(String roomId) {
    return remoteDataSource.createOrJoinRoom(roomId);
  }

  @override
  Stream<List<Room>> getRooms() {
    // RoomModel correctly subclasses Room, so passing to Stream<List<Room>> works implicitly with Dart types
    return remoteDataSource.getRooms();
  }
}
