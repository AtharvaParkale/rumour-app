import 'package:equatable/equatable.dart';
import '../../domain/entities/room.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object?> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomLoaded extends RoomState {
  final List<Room> rooms;

  const RoomLoaded(this.rooms);

  @override
  List<Object?> get props => [rooms];
}

class RoomJoined extends RoomState {
  final String roomId;

  const RoomJoined(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class RoomError extends RoomState {
  final String message;

  const RoomError(this.message);

  @override
  List<Object?> get props => [message];
}
