import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import 'bloc/messages_bloc.dart';
import 'messages_form.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessagesBloc>(
      create: (_) => MessagesBloc(
        fetchLocalUserUseCase: appLocator<FetchLocalUserUseCase>(),
        appRouter: appLocator<AppRouter>(),
        getUserByUuidUseCase: appLocator<GetUserByUuidUseCase>(),
        createChatUseCase: appLocator<CreateChatUseCase>(),
        getChatsUseCase: appLocator<GetChatsUseCase>(),
      ),
      child: const MessagesForm(),
    );
  }
}
