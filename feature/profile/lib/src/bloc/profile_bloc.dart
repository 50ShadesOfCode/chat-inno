import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

import 'profile_event.dart';
import 'profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetLocalUserUseCase _getLocalUserUseCase;
  final AddUserUseCase _addUserUseCase;
  final SetUserUseCase _setUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final GetUserByUuidUseCase _getUserByUuidUseCase;

  ProfileBloc({
    required GetLocalUserUseCase getLocalUserUseCase,
    required AddUserUseCase addUserUseCase,
    required SetUserUseCase setUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required GetUserByUuidUseCase getUserByUuidUseCase,
  })  : _getLocalUserUseCase = getLocalUserUseCase,
        _addUserUseCase = addUserUseCase,
        _setUserUseCase = setUserUseCase,
        _deleteUserUseCase = deleteUserUseCase,
        _getUserByUuidUseCase = getUserByUuidUseCase,
        super(
          const ProfileState(
            isAuthorized: false,
            imagePath: '',
            isDisabled: true,
            username: '',
            uuid: '',
            isAlreadyExists: false,
          ),
        ) {
    on<InitEvent>(_onInitEvent);
    on<EditEvent>(_onEditEvent);
    on<SaveEvent>(_onSaveEvent);
    on<DeleteUserEvent>(_onDeleteUserEvent);
    add(InitEvent());
  }

  Future<void> _onEditEvent(
    EditEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isDisabled: false,
      ),
    );
  }

  Future<void> _onInitEvent(
    InitEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final User? user = _getLocalUserUseCase.execute(const NoParams());
    if (user != null) {
      emit(
        state.copyWith(
          isAuthorized: true,
          imagePath: user.imageUrl,
          uuid: user.uuid,
          username: user.username,
          isAlreadyExists: false,
        ),
      );
    }
  }

  Future<void> _onSaveEvent(
    SaveEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (!(event.uuid == '' || event.username == '')) {
      final User? user = await _getUserByUuidUseCase.execute(event.uuid);
      if (user != null) {
        emit(
          state.copyWith(
            isAuthorized: state.isAuthorized,
            isDisabled: state.isDisabled,
            uuid: state.uuid,
            username: state.username,
            imagePath: state.imagePath,
            isAlreadyExists: state.isAlreadyExists,
          ),
        );
      }
      if (state.username == '') {
        _addUserUseCase.execute(
          User(
            username: event.username,
            uuid: event.uuid,
            imageUrl: event.photo != null ? event.photo!.path : '',
          ),
        );
        emit(
          state.copyWith(
            isDisabled: true,
            isAuthorized: true,
            username: event.username,
            uuid: event.uuid,
            imagePath: event.photo != null ? event.photo!.path : '',
            isAlreadyExists: state.isAlreadyExists,
          ),
        );
      } else {
        _setUserUseCase.execute(
          User(
            username: event.username,
            uuid: event.uuid,
            imageUrl: event.photo != null
                ? event.photo!.path
                : (state.imagePath != '' ? state.imagePath : ''),
          ),
        );
        emit(
          state.copyWith(
            isAuthorized: true,
            isDisabled: true,
            uuid: event.uuid,
            username: event.username,
            imagePath: state.imagePath,
            isAlreadyExists: state.isAlreadyExists,
          ),
        );
      }
    }
  }

  Future<void> _onDeleteUserEvent(
    DeleteUserEvent event,
    Emitter<ProfileState> emit,
  ) async {
    _deleteUserUseCase.execute(const NoParams());
    emit(
      state.copyWith(
        isAuthorized: false,
        imagePath: '',
        isDisabled: true,
        uuid: '',
        username: '',
        isAlreadyExists: false,
      ),
    );
  }
}
