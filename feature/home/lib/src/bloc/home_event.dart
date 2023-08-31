import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class HomeEvent {}

class InitEvent extends HomeEvent {}

class UpdateEvent extends HomeEvent {
  final ConnectivityResult status;

  UpdateEvent({
    required this.status,
  });
}
