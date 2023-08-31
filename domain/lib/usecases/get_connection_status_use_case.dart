import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

class GetConnectionStatusUseCase
    extends StreamUseCase<NoParams, ConnectivityResult> {
  final ConnectionRepository _connectionRepository;

  GetConnectionStatusUseCase({
    required ConnectionRepository connectionRepository,
  }) : _connectionRepository = connectionRepository;

  @override
  Stream<ConnectivityResult> execute(NoParams input) {
    return _connectionRepository.getConnectionStatusStream();
  }
}
