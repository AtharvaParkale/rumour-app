import '../entities/room.dart';
import '../repositories/room_repository.dart';

class GetRooms {
  final RoomRepository repository;

  GetRooms(this.repository);

  Stream<List<Room>> call() {
    return repository.getRooms();
  }
}
