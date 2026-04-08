import 'package:equatable/equatable.dart';
import '../../domain/entities/user_identity.dart';

abstract class IdentityState extends Equatable {
  const IdentityState();

  @override
  List<Object?> get props => [];
}

class IdentityInitial extends IdentityState {}

class IdentityLoading extends IdentityState {}

class IdentityExists extends IdentityState {
  final UserIdentity user;

  const IdentityExists(this.user);

  @override
  List<Object?> get props => [user];
}

class IdentityGenerated extends IdentityState {
  final UserIdentity user;

  const IdentityGenerated(this.user);

  @override
  List<Object?> get props => [user];
}

class IdentitySaved extends IdentityState {}

class IdentityError extends IdentityState {
  final String message;

  const IdentityError(this.message);

  @override
  List<Object?> get props => [message];
}
