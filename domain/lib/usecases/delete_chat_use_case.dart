import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class DeleteChatUseCase extends FutureUseCase<String, void> {
  final ChatRepository _chatRepository;

  DeleteChatUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Future<void> execute(String input) async {
    await _chatRepository.deleteChat(input);
  }
}
