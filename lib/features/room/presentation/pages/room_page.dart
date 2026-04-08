import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/room_bloc.dart';
import '../bloc/room_event.dart';
import '../bloc/room_state.dart';
import '../../identity/presentation/pages/identity_page.dart';

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
    // Dispatch LoadRooms event to start listening to the stream
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocListener<RoomBloc, RoomState>(
          listener: (context, state) {
            if (state is RoomJoined) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IdentityPage(
                    roomId: state.roomId,
                  ),
                ),
              );
            } else if (state is RoomError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
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
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter the code to join the anonymous chat room',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildCodeField(),
                const SizedBox(height: 16),
                _buildJoinButton(),
                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Active Rooms',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
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
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: Icon(
          Icons.key_rounded,
          color: Color(0xFFC1FF72),
          size: 36,
        ),
      ),
    );
  }

  Widget _buildCodeField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _codeController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
        textAlign: TextAlign.center,
        cursorColor: const Color(0xFFC1FF72),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter room code',
          hintStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
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
          'Join / Create Room',
          style: TextStyle(
            fontSize: 18,
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
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFC1FF72)),
            );
          } else if (state is RoomLoaded) {
            if (state.rooms.isEmpty) {
              return Center(
                child: Text(
                  'No active rooms yet',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.rooms.length,
              itemBuilder: (context, index) {
                final room = state.rooms[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () => _dispatchJoinEvent(room.id),
                    tileColor: const Color(0xFF161616),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(Icons.tag, color: Color(0xFFC1FF72), size: 20),
                    ),
                    title: Text(
                      room.id,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                );
              },
            );
          } else if (state is RoomError) {
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
      ),
    );
  }
}
