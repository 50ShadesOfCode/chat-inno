import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:data/providers/firebase_provider.dart';
import 'package:data/providers/storage_provider.dart';
import 'package:data/repositories/chat_repository_impl.dart';
import 'package:domain/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

final DataDI dataDI = DataDI();

class DataDI {
  Future<void> initDependencies() async {
    await initProviders();
    await initRepositories();
    initUseCases();
  }

  Future<void> initProviders() async {
    appLocator.registerSingleton<StorageProvider>(
      StorageProvider(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
    );
    appLocator.registerSingleton<FirebaseProvider>(
      FirebaseProvider(
        firebaseStorage: FirebaseStorage.instance,
        firebaseFirestore: FirebaseFirestore.instance,
      ),
    );
  }

  Future<void> initRepositories() async {
    appLocator.registerSingleton<UserRepository>(
      UserRepositoryImpl(
        storageProvider: appLocator<StorageProvider>(),
        firebaseProvider: appLocator<FirebaseProvider>(),
      ),
    );
    appLocator.registerSingleton<ConnectionRepository>(
      ConnectionRepositoryImpl(),
    );
    appLocator.registerSingleton<ChatRepository>(
      ChatRepositoryImpl(
        firebaseProvider: appLocator<FirebaseProvider>(),
        storageProvider: appLocator<StorageProvider>(),
      ),
    );
  }

  void initUseCases() {
    appLocator.registerFactory<GetConnectionStatusUseCase>(
      () => GetConnectionStatusUseCase(
        connectionRepository: appLocator<ConnectionRepository>(),
      ),
    );
    appLocator.registerFactory<GenerateRandomCredentialsUseCase>(
      () => GenerateRandomCredentialsUseCase(
        userRepository: appLocator<UserRepository>(),
      ),
    );
    appLocator.registerFactory<GetLocalUserUseCase>(
      () => GetLocalUserUseCase(
        userRepository: appLocator<UserRepository>(),
      ),
    );
    appLocator.registerFactory<AddUserUseCase>(
      () => AddUserUseCase(
        userRepository: appLocator<UserRepository>(),
      ),
    );
    appLocator.registerFactory<DeleteUserUseCase>(
      () => DeleteUserUseCase(
        userRepository: appLocator<UserRepository>(),
      ),
    );
    appLocator.registerFactory<FetchLocalUserUseCase>(
      () => FetchLocalUserUseCase(
        userRepository: appLocator<UserRepository>(),
      ),
    );
    appLocator.registerFactory<GetUserByUuidUseCase>(
      () => GetUserByUuidUseCase(
        userRepository: appLocator<UserRepository>(),
      ),
    );
    appLocator.registerFactory<SetImageUseCase>(
      () => SetImageUseCase(
        userRepository: appLocator<UserRepository>(),
      ),
    );
    appLocator.registerFactory<SetUserUseCase>(
      () => SetUserUseCase(
        userRepository: appLocator<UserRepository>(),
      ),
    );
    appLocator.registerFactory<GetChatsUseCase>(
      () => GetChatsUseCase(
        userRepository: appLocator<UserRepository>(),
      ),
    );
    appLocator.registerFactory<CreateChatUseCase>(
      () => CreateChatUseCase(
        chatRepository: appLocator<ChatRepository>(),
      ),
    );
    appLocator.registerFactory<SendMessageUseCase>(
      () => SendMessageUseCase(
        chatRepository: appLocator<ChatRepository>(),
      ),
    );
    appLocator.registerFactory<GetMessagesStreamUseCase>(
      () => GetMessagesStreamUseCase(
        chatRepository: appLocator<ChatRepository>(),
      ),
    );
    appLocator.registerFactory<DeleteChatUseCase>(
      () => DeleteChatUseCase(
        chatRepository: appLocator<ChatRepository>(),
      ),
    );
    appLocator.registerFactory<GetChatStreamUseCase>(
      () => GetChatStreamUseCase(
        chatRepository: appLocator<ChatRepository>(),
      ),
    );
  }
}
