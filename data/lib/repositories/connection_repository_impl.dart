import 'package:core/core.dart';
import 'package:domain/domain.dart';

class ConnectionRepositoryImpl extends ConnectionRepository {
  @override
  Stream<ConnectivityResult> getConnectionStatusStream() async* {
    await for (final ConnectivityResult result
        in Connectivity().onConnectivityChanged) {
      yield result;
    }
  }
}
