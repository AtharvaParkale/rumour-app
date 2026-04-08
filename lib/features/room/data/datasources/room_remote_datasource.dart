import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/room_model.dart';

abstract class RoomRemoteDataSource {
  Future<void> createOrJoinRoom(String roomId);
  Stream<List<RoomModel>> getRooms();
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final FirebaseFirestore _firestore;

  RoomRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<void> createOrJoinRoom(String roomId) async {
    final roomDocRef = _firestore.collection('rooms').doc(roomId);

    final roomSnapshot = await roomDocRef.get();

    if (!roomSnapshot.exists) {
      await roomDocRef.set({
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Stream<List<RoomModel>> getRooms() {
    return _firestore.collection('rooms').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return RoomModel.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }
}
