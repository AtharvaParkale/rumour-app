import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<(List<Message>, Object?)> getMessages(String roomId, {Object? lastDocument}) {
    final docSnap = lastDocument as DocumentSnapshot?;
    return remoteDataSource.getMessages(roomId, lastDocument: docSnap).map((record) {
      final (models, lastDoc) = record;
      return (List<Message>.from(models), lastDoc);
    });
  }

  @override
  Future<void> sendMessage(String roomId, Message message) {
    final model = MessageModel(
      id: message.id,
      text: message.text,
      senderId: message.senderId,
      senderName: message.senderName,
      senderAvatar: message.senderAvatar,
      createdAt: message.createdAt,
    );
    return remoteDataSource.sendMessage(roomId, model);
  }
}
