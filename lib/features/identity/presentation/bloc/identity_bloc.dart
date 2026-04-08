import 'package:flutter_bloc/flutter_bloc.dart';
import 'identity_event.dart';
import 'identity_state.dart';
import '../../domain/usecases/get_local_identity.dart';
import '../../domain/usecases/fetch_random_user.dart';
import '../../domain/usecases/save_identity.dart';

class IdentityBloc extends Bloc<IdentityEvent, IdentityState> {
  final GetLocalIdentity _getLocalIdentity;
  final FetchRandomUser _fetchRandomUser;
  final SaveIdentity _saveIdentity;

  IdentityBloc({
    required GetLocalIdentity getLocalIdentity,
    required FetchRandomUser fetchRandomUser,
    required SaveIdentity saveIdentity,
  }) : _getLocalIdentity = getLocalIdentity,
       _fetchRandomUser = fetchRandomUser,
       _saveIdentity = saveIdentity,
       super(IdentityInitial()) {
    on<CheckIdentity>(_onCheckIdentity);
    on<GenerateIdentity>(_onGenerateIdentity);
    on<SaveIdentityEvent>(_onSaveIdentityEvent);
  }

  Future<void> _onCheckIdentity(
    CheckIdentity event,
    Emitter<IdentityState> emit,
  ) async {
    emit(IdentityLoading());
    try {
      final user = await _getLocalIdentity.call(event.roomId);
      if (user != null) {
        emit(IdentityExists(user));
      } else {
        add(GenerateIdentity(event.roomId));
      }
    } catch (e) {
      emit(IdentityError(e.toString()));
    }
  }

  Future<void> _onGenerateIdentity(
    GenerateIdentity event,
    Emitter<IdentityState> emit,
  ) async {
    try {
      final user = await _fetchRandomUser.call();
      emit(IdentityGenerated(user));
    } catch (e) {
      emit(IdentityError(e.toString()));
    }
  }

  Future<void> _onSaveIdentityEvent(
    SaveIdentityEvent event,
    Emitter<IdentityState> emit,
  ) async {
    try {
      await _saveIdentity.call(event.roomId, event.user);
      emit(IdentitySaved());
    } catch (e) {
      emit(IdentityError(e.toString()));
    }
  }
}
