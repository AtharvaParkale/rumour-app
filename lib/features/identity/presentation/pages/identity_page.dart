import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rumour_app/features/chat/presentation/pages/chat_page.dart';
import '../bloc/identity_bloc.dart';
import '../bloc/identity_event.dart';
import '../bloc/identity_state.dart';
import '../../domain/entities/user_identity.dart';

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
    context.read<IdentityBloc>().add(CheckIdentity(widget.roomId));
  }

  void _navigateToChat(UserIdentity user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          roomId: widget.roomId,
          memberCount: widget.memberCount,
          currentUser: user,
        ),
      ),
    );
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
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Room #${widget.roomId}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
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
        child: BlocConsumer<IdentityBloc, IdentityState>(
          listener: (context, state) {
            if (state is IdentityExists) {
              _navigateToChat(state.user);
            } else if (state is IdentityGenerated) {
              setState(() => _generatedUser = state.user);
            } else if (state is IdentitySaved) {
              if (_generatedUser != null) _navigateToChat(_generatedUser!);
            } else if (state is IdentityError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
              );
            }
          },
          builder: (context, state) {
            if (state is IdentityInitial || state is IdentityLoading) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Color(0xFFC1FF72)),
                    const SizedBox(height: 24),
                    Text(
                      'GENERATING IDENTITY...',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is IdentityGenerated && _generatedUser != null) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                              color: Colors.grey[500],
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 48),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFC1FF72).withValues(alpha: 0.15),
                                width: 6,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 64,
                              backgroundColor: const Color(0xFF161616),
                              backgroundImage: NetworkImage(_generatedUser!.avatar),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            _generatedUser!.name,
                            style: const TextStyle(
                              color: Color(0xFFC1FF72), // Vivid Neon Green
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'This is your anonymous identifier, visible only to others in the room.',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<IdentityBloc>().add(
                            SaveIdentityEvent(
                              roomId: widget.roomId,
                              user: _generatedUser!,
                            ),
                          );
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
                            fontSize: 16,
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
