import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:home/home.dart';
import 'package:messages/messages.dart';
import 'package:profile/profile.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen|Form,Route',
  routes: <AutoRoute>[
    AutoRoute(
      initial: true,
      page: HomeForm,
      children: <AutoRoute>[
        CustomRoute(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 500,
          page: MessagesScreen,
          initial: true,
        ),
        CustomRoute(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 500,
          page: ProfileScreen,
        ),
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {}
