import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.text,
    required super.senderId,
    required super.senderName,
    required super.senderAvatar,
    super.createdAt,
  });

  factory MessageModel.fromFirestore(String id, Map<String, dynamic> data) {
    return MessageModel(
      id: id,
      text: data['text'] as String? ?? '',
      senderId: data['senderId'] as String? ?? '',
      senderName: data['senderName'] as String? ?? '',
      senderAvatar: data['senderAvatar'] as String? ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!)
      else 'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
