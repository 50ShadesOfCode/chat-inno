import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

import 'messages_event.dart';
import 'messages_state.dart';

export 'messages_event.dart';
export 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final GetChatsUseCase _getChatsUseCase;
  final CreateChatUseCase _createChatUseCase;
  final GetUserByUuidUseCase _getUserByUuidUseCase;

  MessagesBloc({
    required GetChatsUseCase getChatsUseCase,
    required CreateChatUseCase createChatUseCase,
    required GetUserByUuidUseCase getUserByUuidUseCase,
  })  : _getChatsUseCase = getChatsUseCase,
        _createChatUseCase = createChatUseCase,
        _getUserByUuidUseCase = getUserByUuidUseCase,
        super(
          const MessagesState(
            chats: <Chat>[],
            users: <User>[],
            isLoading: true,
          ),
        ) {
    on<InitEvent>(_onInitEvent);
    on<NewChatEvent>(_onNewChatEvent);

    add(InitEvent());
  }

  Future<void> _onInitEvent(
    InitEvent event,
    Emitter<MessagesState> emit,
  ) async {
    final List<Chat>? chats = await _getChatsUseCase.execute(const NoParams());
    if (chats != null) {
      List<User> users = <User>[];
      for (final Chat chat in chats) {
        final User? user =
            await _getUserByUuidUseCase.execute(chat.receiverUuid);
        if (user != null) {
          users.add(user);
        }
      }
      emit(
        state.copyWith(
          chats: chats,
          users: users,
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _onNewChatEvent(
    NewChatEvent event,
    Emitter<MessagesState> emit,
  ) async {
    _createChatUseCase.execute(event.uuid);
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    add(InitEvent());
  }
}
