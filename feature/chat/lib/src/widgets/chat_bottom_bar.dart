import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ChatBottomBar extends StatefulWidget {
  const ChatBottomBar({
    required this.controller,
    required this.onTapSend,
    required this.onTapAdd,
    super.key,
  });

  final void Function()? onTapSend;
  final void Function()? onTapAdd;
  final TextEditingController controller;

  @override
  State<ChatBottomBar> createState() => _ChatBottomBarState();
}

class _ChatBottomBarState extends State<ChatBottomBar> {
  late TextEditingController messageController;
  late void Function()? onTapSend;
  late void Function()? onTapAdd;

  @override
  void initState() {
    super.initState();
    messageController = widget.controller;
    onTapSend = widget.onTapSend;
    onTapAdd = widget.onTapAdd;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.heightAppBar,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS_4),
        color: AppColors.of(context).gray,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              iconSize: AppDimens.IMAGE_SIZE_25,
              onPressed: onTapAdd,
              icon: SvgPicture.asset(
                width: AppDimens.IMAGE_SIZE_25,
                height: AppDimens.IMAGE_SIZE_25,
                AppImages.addFilesIcon,
              ),
            ),
            Expanded(
              child: AppTextField(
                underline: true,
                controller: messageController,
                hintText: 'message'.tr(),
              ),
            ),
            IconButton(
              iconSize: AppDimens.IMAGE_SIZE_25,
              onPressed: onTapSend,
              icon: SvgPicture.asset(
                width: AppDimens.IMAGE_SIZE_25,
                height: AppDimens.IMAGE_SIZE_25,
                AppImages.sendIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
