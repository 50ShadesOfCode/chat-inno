import 'package:core/core.dart';

abstract class ConnectionRepository {
  Stream<ConnectivityResult> getConnectionStatusStream();
}
