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
  final FetchLocalUserUseCase _fetchLocalUserUseCase;
  final AppRouter _appRouter;

  MessagesBloc({
    required AppRouter appRouter,
    required GetChatsUseCase getChatsUseCase,
    required CreateChatUseCase createChatUseCase,
    required GetUserByUuidUseCase getUserByUuidUseCase,
    required FetchLocalUserUseCase fetchLocalUserUseCase,
  })  : _getChatsUseCase = getChatsUseCase,
        _createChatUseCase = createChatUseCase,
        _getUserByUuidUseCase = getUserByUuidUseCase,
        _appRouter = appRouter,
        _fetchLocalUserUseCase = fetchLocalUserUseCase,
        super(
          const MessagesState(
            chats: <Chat>[],
            users: <User>[],
            isLoading: true,
          ),
        ) {
    on<InitEvent>(_onInitEvent);
    on<NewChatEvent>(_onNewChatEvent);
    on<OpenChatEvent>(_onOpenChatEvent);

    add(InitEvent());
  }

  Future<void> _onInitEvent(
    InitEvent event,
    Emitter<MessagesState> emit,
  ) async {
    final User localUser =
        await _fetchLocalUserUseCase.execute(const NoParams());
    final List<Chat>? chats = await _getChatsUseCase.execute(const NoParams());
    if (chats != null) {
      List<User> users = <User>[];
      for (final Chat chat in chats) {
        final User? user = await _getUserByUuidUseCase.execute(
            localUser.uuid == chat.senderUuid
                ? chat.receiverUuid
                : chat.senderUuid);
        if (user != null) {
          users.add(user);
        } else {
          users.add(User(username: 'Not found', uuid: '', imageUrl: ''));
        }
      }
      emit(
        state.copyWith(
          chats: chats,
          users: users,
          isLoading: false,
        ),
      );
    } else {
      emit(state.copyWith(
        isLoading: false,
      ));
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

  Future<void> _onOpenChatEvent(
    OpenChatEvent event,
    Emitter<MessagesState> emit,
  ) async {
    _appRouter.push(ChatRoute(
      chatUuid: event.chatUuid,
      receiverUuid: event.receiverUuid,
    ));
  }
}
