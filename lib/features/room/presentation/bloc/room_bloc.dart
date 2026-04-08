import 'package:flutter_bloc/flutter_bloc.dart';
import 'room_event.dart';
import 'room_state.dart';
import '../../domain/usecases/create_or_join_room.dart';
import '../../domain/usecases/get_rooms.dart';
import '../../domain/entities/room.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final CreateOrJoinRoom _createOrJoinRoom;
  final GetRooms _getRooms;

  RoomBloc({
    required CreateOrJoinRoom createOrJoinRoom,
    required GetRooms getRooms,
  }) : _createOrJoinRoom = createOrJoinRoom,
       _getRooms = getRooms,
       super(RoomInitial()) {
    on<LoadRooms>(_onLoadRooms);
    on<CreateOrJoinRoomEvent>(_onCreateOrJoinRoom);
  }

  Future<void> _onLoadRooms(LoadRooms event, Emitter<RoomState> emit) async {
    emit(RoomLoading());

    await emit.forEach<List<Room>>(
      _getRooms.call(),
      onData: (rooms) => RoomLoaded(rooms),
      onError: (error, stackTrace) => RoomError(error.toString()),
    );
  }

  Future<void> _onCreateOrJoinRoom(
    CreateOrJoinRoomEvent event,
    Emitter<RoomState> emit,
  ) async {
    try {
      await _createOrJoinRoom.call(event.roomId);
      emit(RoomJoined(event.roomId));
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }
}
