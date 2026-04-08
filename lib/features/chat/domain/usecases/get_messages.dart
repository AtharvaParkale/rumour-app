import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Stream<(List<Message>, Object?)> call(String roomId, {Object? lastDocument}) {
    return repository.getMessages(roomId, lastDocument: lastDocument);
  }
}
