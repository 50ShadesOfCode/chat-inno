import 'package:domain/repositories/user_repository.dart';
import 'package:domain/usecases/usecase.dart';

class GenerateRandomCredentialsUseCase extends FutureUseCase<NoParams, void> {
  final UserRepository _userRepository;

  GenerateRandomCredentialsUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  @override
  Future<void> execute(NoParams input) async {
    await _userRepository.generateRandomCredentials();
  }
}
