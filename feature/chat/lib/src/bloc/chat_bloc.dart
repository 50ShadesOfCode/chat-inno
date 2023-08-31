import 'dart:async';

import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

import 'chat_event.dart';
import 'chat_state.dart';

export 'chat_event.dart';
export 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AppRouter _appRouter;
  final GetUserByUuidUseCase _getUserByUuidUseCase;
  final GetChatStreamUseCase _getChatStreamUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final GetMessagesStreamUseCase _getMessagesStreamUseCase;
  final DeleteChatUseCase _deleteChatUseCase;
  final FetchLocalUserUseCase _fetchLocalUserUseCase;
  late StreamSubscription<List<Message>> messagesStreamSubscription;
  late StreamSubscription<Chat> chatStreamSubscription;

  ChatBloc({
    required AppRouter appRouter,
    required GetChatStreamUseCase getChatStreamUseCase,
    required GetUserByUuidUseCase getUserByUuidUseCase,
    required SendMessageUseCase sendMessagesUseCase,
    required GetMessagesStreamUseCase getMessagesStreamUseCase,
    required DeleteChatUseCase deleteChatUseCase,
    required FetchLocalUserUseCase fetchLocalUserUseCase,
  })  : _getUserByUuidUseCase = getUserByUuidUseCase,
        _getChatStreamUseCase = getChatStreamUseCase,
        _appRouter = appRouter,
        _sendMessageUseCase = sendMessagesUseCase,
        _deleteChatUseCase = deleteChatUseCase,
        _getMessagesStreamUseCase = getMessagesStreamUseCase,
        _fetchLocalUserUseCase = fetchLocalUserUseCase,
        super(
          ChatState(
            senderUuid: '',
            chatUuid: '',
            receiverUuid: '',
            messages: const <Message>[],
            sender: User(
              username: '',
              uuid: '',
              imageUrl: '',
            ),
            receiver: User(
              username: '',
              uuid: '',
              imageUrl: '',
            ),
          ),
        ) {
    on<InitEvent>(_onInitEvent);
    on<SendMessageEvent>(_onSendMessageEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteChatEvent>(_onDeleteChatEvent);
    on<ListenForMessagesEvent>(_onListenForMessagesEvent);
  }

  Future<void> _onListenForMessagesEvent(
    ListenForMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    messagesStreamSubscription = _getMessagesStreamUseCase
        .execute(state.chatUuid)
        .listen((List<Message> messages) {
      add(UpdateEvent(messages: messages));
    });
    chatStreamSubscription =
        _getChatStreamUseCase.execute(state.chatUuid).listen((Chat chat) {});
    emit(state);
  }

  Future<void> _onInitEvent(
    InitEvent event,
    Emitter<ChatState> emit,
  ) async {
    final User sender = await _fetchLocalUserUseCase.execute(const NoParams());
    final User? receiver =
        await _getUserByUuidUseCase.execute(event.receiverUuid);
    emit(state.copyWith(
      senderUuid: sender.uuid,
      chatUuid: event.chatUuid,
      receiverUuid: event.receiverUuid,
      sender: sender,
      receiver: receiver ??
          User(
            username: '',
            uuid: event.receiverUuid,
            imageUrl: '',
          ),
    ));
    add(ListenForMessagesEvent());
  }

  Future<void> _onUpdateEvent(
    UpdateEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(messages: event.messages.reversed.toList()));
  }

  Future<void> _onSendMessageEvent(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final SendMessageRequest request = SendMessageRequest(
      chatUuid: state.chatUuid,
      receiverUuid: state.receiverUuid,
      text: event.message,
      files: event.files,
    );
    await _sendMessageUseCase.execute(request);
  }

  Future<void> _onDeleteChatEvent(
    DeleteChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _deleteChatUseCase.execute(state.chatUuid);
    _appRouter.replace(const HomeRoute());
  }

  @override
  Future<void> close() async {
    messagesStreamSubscription.cancel();
    super.close();
  }
}
