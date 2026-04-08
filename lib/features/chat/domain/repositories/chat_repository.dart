import '../entities/message.dart';

abstract class ChatRepository {
  // Utilizing an opaque Object? cursor neatly prevents Firebase leakage deep into the Domain layer cleanly
  Stream<(List<Message>, Object?)> getMessages(String roomId, {Object? lastDocument});
  Future<void> sendMessage(String roomId, Message message);
}
