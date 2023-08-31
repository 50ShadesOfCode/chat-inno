import 'package:core/core.dart';

class HomeState extends Equatable {
  bool hasConnection;

  HomeState({
    required this.hasConnection,
  });

  HomeState copyWith({
    bool? hasConnection,
  }) {
    return HomeState(
      hasConnection: hasConnection ?? this.hasConnection,
    );
  }

  @override
  List<Object> get props => <Object>[
        hasConnection,
      ];
}
