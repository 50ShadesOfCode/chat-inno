import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class GetMessagesStreamUseCase extends StreamUseCase<String, List<Message>> {
  final ChatRepository _chatRepository;

  GetMessagesStreamUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  @override
  Stream<List<Message>> execute(String input) {
    return _chatRepository.getMessagesStreamByChatId(input);
  }
}
