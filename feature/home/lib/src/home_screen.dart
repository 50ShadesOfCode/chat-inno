import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:home/src/bloc/home_bloc.dart';

import 'home_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeBloc(
        generateRandomCredentialsUseCase:
            appLocator<GenerateRandomCredentialsUseCase>(),
        getConnectionStatusUseCase: appLocator<GetConnectionStatusUseCase>(),
      ),
      child: const HomeForm(),
    );
  }
}
