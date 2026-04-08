class Message {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final DateTime? createdAt;

  const Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    this.createdAt,
  });
}
