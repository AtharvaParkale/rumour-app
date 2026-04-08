import 'package:equatable/equatable.dart';
import '../../domain/entities/user_identity.dart';

abstract class IdentityEvent extends Equatable {
  const IdentityEvent();

  @override
  List<Object?> get props => [];
}

class CheckIdentity extends IdentityEvent {
  final String roomId;

  const CheckIdentity(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class GenerateIdentity extends IdentityEvent {
  final String roomId;

  const GenerateIdentity(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class SaveIdentityEvent extends IdentityEvent {
  final String roomId;
  final UserIdentity user;

  const SaveIdentityEvent({
    required this.roomId,
    required this.user,
  });

  @override
  List<Object?> get props => [roomId, user];
}
