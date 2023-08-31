import 'package:chat_feature/src/bloc/chat_bloc.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import 'chat_form.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    required this.chatUuid,
    required this.receiverUuid,
    super.key,
  });

  final String chatUuid;
  final String receiverUuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (_) => ChatBloc(
        appRouter: appLocator<AppRouter>(),
        getChatStreamUseCase: appLocator<GetChatStreamUseCase>(),
        getUserByUuidUseCase: appLocator<GetUserByUuidUseCase>(),
        sendMessagesUseCase: appLocator<SendMessageUseCase>(),
        getMessagesStreamUseCase: appLocator<GetMessagesStreamUseCase>(),
        deleteChatUseCase: appLocator<DeleteChatUseCase>(),
        fetchLocalUserUseCase: appLocator<FetchLocalUserUseCase>(),
      )..add(InitEvent(
          chatUuid: chatUuid,
          receiverUuid: receiverUuid,
        )),
      child: const ChatForm(),
    );
  }
}
