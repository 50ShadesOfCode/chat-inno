import 'package:domain/domain.dart';

import 'package:domain/usecases/usecase.dart';

class CreateChatUseCase extends FutureUseCase<String, void> {
  final ChatRepository _chatRepository;

  CreateChatUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<void> execute(String input) async {
    await _chatRepository.createChat(input);
  }
}
