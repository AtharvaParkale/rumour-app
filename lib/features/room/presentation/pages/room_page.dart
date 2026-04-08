import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/room_bloc.dart';
import '../bloc/room_event.dart';
import '../bloc/room_state.dart';
import 'package:rumour_app/features/identity/presentation/pages/identity_page.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RoomBloc>().add(LoadRooms());
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _dispatchJoinEvent([String? explicitRoomId]) {
    final roomId = explicitRoomId ?? _codeController.text.trim();
    if (roomId.isNotEmpty) {
      context.read<RoomBloc>().add(CreateOrJoinRoomEvent(roomId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: BlocListener<RoomBloc, RoomState>(
          listener: (context, state) {
            if (state is RoomJoined) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IdentityPage(roomId: state.roomId),
                ),
              );
            } else if (state is RoomError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, style: const TextStyle(fontWeight: FontWeight.w600)),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                _buildLogo(),
                const SizedBox(height: 32),
                const Text(
                  'Join A Room',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter the code to join the anonymous chat room',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildCodeField(),
                const SizedBox(height: 16),
                _buildJoinButton(),
                const SizedBox(height: 48),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Active Rooms',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildRoomList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: const Center(
        child: Icon(Icons.tag_rounded, color: Color(0xFFC1FF72), size: 32),
      ),
    );
  }

  Widget _buildCodeField() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Center(
        child: TextField(
          controller: _codeController,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 4,
          ),
          textAlign: TextAlign.center,
          cursorColor: const Color(0xFFC1FF72),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'CODE',
            hintStyle: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildJoinButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _dispatchJoinEvent(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC1FF72),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Join or Create',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildRoomList() {
    return Expanded(
      child: BlocBuilder<RoomBloc, RoomState>(
        builder: (context, state) {
          if (state is RoomLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFC1FF72)));
          } else if (state is RoomLoaded) {
            if (state.rooms.isEmpty) {
              return Center(
                child: Text(
                  'No active rooms yet',
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.rooms.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final room = state.rooms[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () => _dispatchJoinEvent(room.id),
                    tileColor: const Color(0xFF161616),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.tag, color: Color(0xFFC1FF72), size: 18),
                    ),
                    title: Text(
                      room.id,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
