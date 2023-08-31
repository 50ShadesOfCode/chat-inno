import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:core_ui/src/widgets/app_bottom_navigation_bar/app_bottom_navigation_bar_item.dart';
import 'package:core_ui/src/widgets/app_bottom_navigation_bar/inherited_app_bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({
    super.key,
  });

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  Widget build(_) {
    return InheritedAppBottomNavigationBarWidget(
      selectedIndex: _selectedIndex,
      child: Builder(
        builder: (BuildContext context) {
          return Container(
            height: AppDimens.heightTabBar,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Row(
              children: <Widget>[
                AppBottomNavigationBarItem(
                  index: 0,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                      appLocator.get<AppRouter>().push(const MessagesRoute());
                    });
                  },
                  label: 'chats',
                  icon: AppImages.chatsIcon,
                ),
                AppBottomNavigationBarItem(
                  index: 1,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                      appLocator.get<AppRouter>().push(const ProfileRoute());
                    });
                  },
                  label: 'profile',
                  icon: AppImages.profileIcon,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
