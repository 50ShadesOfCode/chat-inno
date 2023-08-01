import 'package:core/core.dart';
import 'package:domain/domain.dart';

class MessagesState extends Equatable {
  final List<Chat> chats;
  final List<User> users;
  final bool isLoading;

  const MessagesState({
    required this.chats,
    required this.users,
    required this.isLoading,
  });

  MessagesState copyWith({
    List<Chat>? chats,
    List<User>? users,
    bool? isLoading,
  }) {
    return MessagesState(
      chats: chats ?? this.chats,
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => <Object>[
        chats,
        users,
        isLoading,
      ];
}
