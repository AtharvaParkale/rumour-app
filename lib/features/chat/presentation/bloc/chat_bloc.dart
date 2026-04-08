import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/entities/message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessages _getMessages;
  final SendMessage _sendMessage;

  ChatBloc({required GetMessages getMessages, required SendMessage sendMessage})
    : _getMessages = getMessages,
      _sendMessage = sendMessage,
      super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessageEvent);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    await emit.forEach<(List<Message>, Object?)>(
      _getMessages.call(event.roomId),
      onData: (record) {
        final (messages, _) = record;

        return ChatLoaded(messages);
      },
      onError: (error, stackTrace) => ChatError(error.toString()),
    );
  }

  Future<void> _onSendMessageEvent(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _sendMessage.call(event.roomId, event.message);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
