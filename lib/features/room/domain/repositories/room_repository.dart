import '../entities/room.dart';

abstract class RoomRepository {
  Future<void> createOrJoinRoom(String roomId);
  Stream<List<Room>> getRooms();
}
