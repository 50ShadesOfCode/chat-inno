import 'package:domain/domain.dart';

import 'usecase.dart';

class GetChatStreamUseCase extends StreamUseCase<String, Chat> {
  final ChatRepository _chatRepository;

  GetChatStreamUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Stream<Chat> execute(String input) {
    return _chatRepository.getChatStream(input);
  }
}
