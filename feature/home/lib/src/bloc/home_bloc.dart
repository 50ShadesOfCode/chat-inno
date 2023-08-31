import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecases/usecase.dart';

import 'home_event.dart';
import 'home_state.dart';

export 'home_event.dart';
export 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GenerateRandomCredentialsUseCase _generateRandomCredentialsUseCase;
  final GetConnectionStatusUseCase _getConnectionStatusUseCase;

  HomeBloc({
    required GenerateRandomCredentialsUseCase generateRandomCredentialsUseCase,
    required GetConnectionStatusUseCase getConnectionStatusUseCase,
  })  : _generateRandomCredentialsUseCase = generateRandomCredentialsUseCase,
        _getConnectionStatusUseCase = getConnectionStatusUseCase,
        super(HomeState(hasConnection: false)) {
    on<InitEvent>(_onInitEvent);
    on<UpdateEvent>(_onUpdateEvent);

    add(InitEvent());
  }

  Future<void> _onInitEvent(InitEvent event, Emitter<HomeState> emit) async {
    _getConnectionStatusUseCase.execute(const NoParams()).listen(
      (ConnectivityResult result) {
        add(UpdateEvent(status: result));
      },
    );
  }

  Future<void> _onUpdateEvent(
    UpdateEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (event.status == ConnectivityResult.none) {
      emit(state.copyWith(hasConnection: false));
    } else {
      emit(state.copyWith(hasConnection: true));
    }
  }
}
