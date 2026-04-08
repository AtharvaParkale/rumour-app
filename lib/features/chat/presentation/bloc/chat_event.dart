import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {
  final String roomId;

  const LoadMessages(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class SendMessageEvent extends ChatEvent {
  final String roomId;
  final Message message;

  const SendMessageEvent({
    required this.roomId,
    required this.message,
  });

  @override
  List<Object?> get props => [roomId, message];
}
