import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/identity_bloc.dart';
import '../bloc/identity_event.dart';
import '../bloc/identity_state.dart';
import '../../domain/entities/user_identity.dart';
import '../../chat/presentation/pages/chat_page.dart';

class IdentityPage extends StatefulWidget {
  final String roomId;
  final int memberCount;

  const IdentityPage({
    super.key,
    required this.roomId,
    this.memberCount = 1,
  });

  @override
  State<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  UserIdentity? _generatedUser;

  @override
  void initState() {
    super.initState();
    // Pre-flight check via local hydration flow effectively chaining our BLoC states internally
    context.read<IdentityBloc>().add(CheckIdentity(widget.roomId));
  }

  void _navigateToChat(UserIdentity user) {
    // Avoid duplicate navigation issues utilizing proper stack propagation
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          roomId: widget.roomId,
          memberCount: widget.memberCount,
          // TODO: Pass user as argument securely when ChatPage requires it in the constructor
          // user: user,
        ),
      ),
    );
  }

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
              'Room #${widget.roomId}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
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
        child: BlocConsumer<IdentityBloc, IdentityState>(
          listener: (context, state) {
            // Strict Navigation Guard mapping explicitly to user guidelines
            if (state is IdentityExists) {
              _navigateToChat(state.user);
            } else if (state is IdentityGenerated) {
              // Maintain strict state synchronization internally without exposing UI sideeffects
              setState(() {
                _generatedUser = state.user;
              });
            } else if (state is IdentitySaved) {
              if (_generatedUser != null) {
                _navigateToChat(_generatedUser!);
              }
            } else if (state is IdentityError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            // Loading Overlay rendering distinctly preventing premature layouts
            if (state is IdentityInitial || state is IdentityLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFC1FF72)),
              );
            }
            
            // Only render generated UI if we successfully loaded/generated an explicit Identity
            if (state is IdentityGenerated && _generatedUser != null) {
              return Padding(
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
                              backgroundImage: NetworkImage(_generatedUser!.avatar),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            _generatedUser!.name,
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
                          // Dispatch SaveIdentityEvent strictly passing Local Cached state securely to IdentityBloc
                          context.read<IdentityBloc>().add(SaveIdentityEvent(
                            roomId: widget.roomId,
                            user: _generatedUser!,
                          ));
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
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
