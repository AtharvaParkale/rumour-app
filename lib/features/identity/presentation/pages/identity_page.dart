import 'package:flutter/material.dart';
// TODO: import 'package:flutter_bloc/flutter_bloc.dart';
// TODO: import '../bloc/identity_bloc.dart';
// TODO: import '../../chat/presentation/pages/chat_page.dart';

class IdentityPage extends StatelessWidget {
  final String roomId;
  final int memberCount; // Handled dynamically, default mapped to 1
  final String userName;
  final String customAvatarUrl;

  const IdentityPage({
    super.key,
    required this.roomId,
    this.memberCount = 1,
    required this.userName,
    required this.customAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Room #$roomId',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$memberCount members',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'For this room, you are',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFC1FF72).withOpacity(0.2),
                          width: 4,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: const Color(0xFF161616),
                        backgroundImage: NetworkImage(customAvatarUrl),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Color(0xFFC1FF72), // Vivid Neon Green
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'This is your anonymous identifier, visible only to others in the room.',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Dispatch event to save identity locally
                    // context.read<IdentityBloc>().add(SaveIdentityEvent(userName, customAvatarUrl));
                    
                    // TODO: Navigate to Chat Screen
                    // Navigator.pushReplacementNamed(context, '/chat', arguments: {'roomId': roomId});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC1FF72),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Acknowledge and continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700, // Strong prominent CTA
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
