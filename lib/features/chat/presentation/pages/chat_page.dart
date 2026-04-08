import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../../domain/entities/message.dart';
import '../../../identity/domain/entities/user_identity.dart';

// NOTE: Added locally strictly for compilation safety since instructed to ONLY modify chat_page.dart.
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
          if (mounted) {
            _isLoadingMore = false;
          }
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

    context.read<ChatBloc>().add(SendMessageEvent(
      roomId: widget.roomId,
      message: message,
    ));

    _msgController.clear();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDateSeparator(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Today';
    } else if (target == yesterday) {
      return 'Yesterday';
    } else {
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return '${date.day} ${months[date.month - 1]}';
    }
  }

  Widget _buildDateSeparator(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room #${widget.roomId}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.memberCount} members',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFC1FF72)),
          );
        } else if (state is ChatLoaded) {
          if (state.messages.isEmpty) {
            return Center(
              child: Text(
                'No messages yet',
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            reverse: true, 
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final message = state.messages[index];
              final isMe = message.senderId == widget.currentUser.id;
              
              final currentMsgDate = message.createdAt ?? DateTime.now();
              bool showSeparator = false;
              
              if (index == state.messages.length - 1) {
                // Historically oldest message boundary logically demands the parent separator natively
                showSeparator = true;
              } else {
                final previousMsg = state.messages[index + 1]; // "Previous" in actual chronological time logically
                final previousMsgDate = previousMsg.createdAt ?? DateTime.now();
                showSeparator = !_isSameDay(currentMsgDate, previousMsgDate);
              }

              return Column(
                children: [
                  if (showSeparator) _buildDateSeparator(_formatDateSeparator(currentMsgDate)),
                  Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFFC1FF72) : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message.text, 
                        style: TextStyle(
                          color: isMe ? Colors.black : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (state is ChatError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      color: const Color(0xFF0A0A0A),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: TextField(
                controller: _msgController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFFC1FF72), 
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
