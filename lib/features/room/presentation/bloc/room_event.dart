import 'package:equatable/equatable.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object?> get props => [];
}

class LoadRooms extends RoomEvent {}

class CreateOrJoinRoomEvent extends RoomEvent {
  final String roomId;

  const CreateOrJoinRoomEvent(this.roomId);

  @override
  List<Object?> get props => [roomId];
}
