import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/room.dart';

class RoomModel extends Room {
  const RoomModel({required super.id, super.createdAt});

  factory RoomModel.fromFirestore(String id, Map<String, dynamic> data) {
    return RoomModel(
      id: id,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!)};
  }
}
