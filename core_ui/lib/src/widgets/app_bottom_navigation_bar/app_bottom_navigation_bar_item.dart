import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

import 'inherited_app_bottom_navigation_bar_widget.dart';

class AppBottomNavigationBarItem extends StatefulWidget {
  final void Function()? onTap;
  final String label;
  final String icon;
  final int index;

  const AppBottomNavigationBarItem({
    required this.onTap,
    required this.label,
    required this.icon,
    required this.index,
    super.key,
  });

  @override
  State<AppBottomNavigationBarItem> createState() =>
      _AppBottomNavigationBarItemState();
}

class _AppBottomNavigationBarItemState
    extends State<AppBottomNavigationBarItem> {
  late void Function()? onTapped;
  late String label;
  late String icon;
  late int index;

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    onTapped = widget.onTap;
    label = widget.label;
    icon = widget.icon;
    index = widget.index;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final InheritedAppBottomNavigationBarWidget? inheritedWidget =
        context.dependOnInheritedWidgetOfExactType<
            InheritedAppBottomNavigationBarWidget>();
    assert(inheritedWidget != null, 'Item is used outside of AppBar');
    setState(() {
      _selectedIndex = inheritedWidget!.selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: InkWell(
        onTap: onTapped,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppDimens.BORDER_RADIUS_4,
            ),
            color: _selectedIndex == index
                ? Colors.white60
                : AppColors.of(context).gray,
          ),
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 500),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  right: AppDimens.PADDING_5,
                ),
                child: SvgPicture.asset(
                  icon,
                  width: AppDimens.IMAGE_SIZE_25,
                  height: AppDimens.IMAGE_SIZE_25,
                ),
              ),
              Text(
                label.tr(),
                style: AppFonts.normal20.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
