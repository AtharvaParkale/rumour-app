import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import 'dart:async';

abstract class ChatRemoteDataSource {
  Stream<(List<MessageModel>, DocumentSnapshot?)> getMessages(
    String roomId, {
    DocumentSnapshot? lastDocument,
  });
  Future<void> sendMessage(String roomId, MessageModel message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore;

  ChatRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Stream<(List<MessageModel>, DocumentSnapshot?)> getMessages(
    String roomId, {
    DocumentSnapshot? lastDocument,
  }) async* {
    var query = _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(20);

    if (lastDocument == null) {
      yield* query.snapshots().map((snapshot) {
        final docs = snapshot.docs;
        final docSnap = docs.isNotEmpty ? docs.last : null;
        final models = docs
            .map((doc) => MessageModel.fromFirestore(doc.id, doc.data()))
            .toList();
        return (models, docSnap);
      });
    } else {
      query = query.startAfterDocument(lastDocument);
      final snapshot = await query.get();
      final docs = snapshot.docs;
      final docSnap = docs.isNotEmpty ? docs.last : null;
      final models = docs
          .map((doc) => MessageModel.fromFirestore(doc.id, doc.data()))
          .toList();
      yield (models, docSnap);
    }
  }

  @override
  Future<void> sendMessage(String roomId, MessageModel message) async {
    final messagesRef = _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages');

    if (message.id.isNotEmpty) {
      await messagesRef.doc(message.id).set(message.toMap());
    } else {
      await messagesRef.add(message.toMap());
    }
  }
}
