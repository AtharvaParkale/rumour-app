import 'package:flutter/material.dart';

// TODO: Ensure these are uncommented in the coming steps when generated
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/chat_bloc.dart';
// import '../bloc/chat_state.dart';
// import '../widgets/message_bubble.dart';
// import '../widgets/chat_input.dart';
// import '../widgets/date_separator.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final int memberCount;

  const ChatPage({
    super.key,
    required this.roomId,
    this.memberCount = 1,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A), // Distinct clean top margin
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0, // Align text accurately
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
            // TODO: Uncomment placeholder below once chat_input.dart is ready
            // const ChatInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    // Structural BlocBuilder prepared accurately based on guidelines. 
    // Commented out to prevent analyzer breakage since Bloc/Widgets are scheduled next.
    
    /*
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
                'No messages here yet.',
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            reverse: true, // Native chat approach: loading bottom-to-top elegantly handles keyboard offset
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final message = state.messages[index];
              
              // Example logic placeholder for DateSeparator
              // bool showDateSeparator = _shouldShowDateSeparator(state.messages, index);

              return Column(
                children: [
                   // if (showDateSeparator) DateSeparator(date: message.timestamp),
                   // MessageBubble(
                   //   message: message, 
                   //   isOutgoing: message.senderId == currentUserId
                   // ),
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
    */

    return const Center(
      child: Text(
        'Chat list goes here\n(Waiting for Bloc & Widgets...)',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
