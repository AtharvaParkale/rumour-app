import '../entities/message.dart';

abstract class ChatRepository {
  Stream<(List<Message>, Object?)> getMessages(
    String roomId, {
    Object? lastDocument,
  });
  Future<void> sendMessage(String roomId, Message message);
}
