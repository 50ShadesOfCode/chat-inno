import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:home/src/bloc/home_bloc.dart';

class HomeForm extends StatefulWidget {
  const HomeForm({super.key});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (BuildContext context, HomeState state) {
        if (!state.hasConnection) {
          showNoConnectionBanner(context);
        }
      },
      child: const SafeArea(
        child: Scaffold(
          body: AutoRouter(),
          bottomNavigationBar: AppBottomNavigationBar(),
        ),
      ),
    );
  }

  showNoConnectionBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: AppColors.of(context).darkGray,
        content: Text('no_connection'.tr()),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(AppImages.cancelIcon),
          ),
        ],
      ),
    );
  }
}
