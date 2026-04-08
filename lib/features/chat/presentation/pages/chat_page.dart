import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../../domain/entities/message.dart';
import '../../../identity/domain/entities/user_identity.dart';

class LoadMoreMessages extends ChatEvent {
  final String roomId;
  const LoadMoreMessages(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

class ChatPage extends StatefulWidget {
  final String roomId;
  final int memberCount;
  final UserIdentity currentUser;

  const ChatPage({
    super.key,
    required this.roomId,
    required this.currentUser,
    this.memberCount = 1,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _msgController = TextEditingController();
  bool _isLoadingMore = false; 

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ChatBloc>().add(LoadMessages(widget.roomId));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore) {
        _isLoadingMore = true;
        context.read<ChatBloc>().add(LoadMoreMessages(widget.roomId));
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) _isLoadingMore = false;
        });
      }
    }
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    final message = Message(
      id: '', 
      text: text,
      senderId: widget.currentUser.id,
      senderName: widget.currentUser.name,
      senderAvatar: widget.currentUser.avatar,
      createdAt: null, 
    );
    context.read<ChatBloc>().add(SendMessageEvent(roomId: widget.roomId, message: message));
    _msgController.clear();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String _formatDateSeparator(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) return 'TODAY';
    if (target == yesterday) return 'YESTERDAY';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}'.toUpperCase();
  }

  String _formatTime(DateTime? date) {
    if (date == null) return "Sending...";
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room #${widget.roomId}',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.memberCount} members',
              style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSeparator(String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF1E1E1E),
              backgroundImage: NetworkImage(message.senderAvatar),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: isMe ? 0 : 4.0, 
                      right: isMe ? 4.0 : 0, 
                      bottom: 6.0
                    ),
                    child: Text(
                      message.senderName,
                      style: TextStyle(
                        color: isMe ? const Color(0xFFC1FF72).withValues(alpha: 0.9) : Colors.grey[400],
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFC1FF72) : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isMe ? 20 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 20),
                      ),
                    ),
                    child: Text(
                      message.text, 
                      style: TextStyle(
                        color: isMe ? Colors.black : Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 6.0,
                      left: isMe ? 0 : 4.0,
                      right: isMe ? 4.0 : 0,
                    ),
                    child: Text(
                      _formatTime(message.createdAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFC1FF72)));
        } else if (state is ChatLoaded) {
          if (state.messages.isEmpty) {
            return Center(child: Text('No messages yet', style: TextStyle(color: Colors.grey[600])));
          }

          return ListView.builder(
            controller: _scrollController,
            reverse: true, 
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            itemCount: state.messages.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final message = state.messages[index];
              final isMe = message.senderId == widget.currentUser.id;
              final currentMsgDate = message.createdAt ?? DateTime.now();
              
              bool showSeparator = false;
              if (index == state.messages.length - 1) {
                showSeparator = true;
              } else {
                final previousMsg = state.messages[index + 1];
                final previousMsgDate = previousMsg.createdAt ?? DateTime.now();
                showSeparator = !_isSameDay(currentMsgDate, previousMsgDate);
              }

              return Column(
                children: [
                  if (showSeparator) _buildDateSeparator(_formatDateSeparator(currentMsgDate)),
                  _buildMessageBubble(message, isMe),
                ],
              );
            },
          );
        } else if (state is ChatError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      color: const Color(0xFF0A0A0A),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 48, maxHeight: 120),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF161616),
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: TextField(
                  controller: _msgController,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 48,
              width: 48,
              margin: const EdgeInsets.only(bottom: 2),
              decoration: const BoxDecoration(
                color: Color(0xFFC1FF72),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
