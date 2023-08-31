import 'package:domain/domain.dart';

import 'usecase.dart';

class SendMessageUseCase extends FutureUseCase<SendMessageRequest, void> {
  final ChatRepository _chatRepository;

  SendMessageUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<void> execute(SendMessageRequest input) async {
    await _chatRepository.sendMessage(input);
  }
}
