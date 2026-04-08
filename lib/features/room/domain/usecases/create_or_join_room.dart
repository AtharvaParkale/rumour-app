import '../repositories/room_repository.dart';

class CreateOrJoinRoom {
  final RoomRepository repository;

  CreateOrJoinRoom(this.repository);

  Future<void> call(String roomId) {
    return repository.createOrJoinRoom(roomId);
  }
}
