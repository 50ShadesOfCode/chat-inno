import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:messages/src/bloc/messages_bloc.dart';
import 'package:messages/src/widgets/chats_list.dart';

class MessagesForm extends StatefulWidget {
  const MessagesForm({
    super.key,
  });

  @override
  State<MessagesForm> createState() => _MessagesFormState();
}

class _MessagesFormState extends State<MessagesForm> {
  final TextEditingController uuidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesBloc, MessagesState>(
      builder: (BuildContext context, MessagesState state) {
        return Column(
          children: <Widget>[
            Container(
              height: AppDimens.heightAppBar,
              color: AppColors.of(context).gray,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: AppDimens.PADDING_17,
                ),
                child: InkWell(
                  onTap: () {
                    showNewChatModalBottomSheet(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(right: AppDimens.PADDING_6),
                        child: Text(
                          'new_chat'.tr(),
                          style: AppFonts.normal14,
                        ),
                      ),
                      SvgPicture.asset(
                        AppImages.newChatIcon,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: state.chats.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'empty'.tr(),
                          style: AppFonts.normal20
                              .copyWith(color: AppColors.of(context).darkGray),
                        ),
                        Text(
                          'create'.tr(),
                          style: AppFonts.normal20.copyWith(
                            color: AppColors.of(context).darkGray,
                          ),
                        ),
                        IconButton(
                          iconSize: AppDimens.IMAGE_SIZE_62,
                          onPressed: () {
                            showNewChatModalBottomSheet(context);
                          },
                          icon: SvgPicture.asset(
                            AppImages.newChatLargeIcon,
                          ),
                        ),
                      ],
                    )
                  : ChatList(
                      chats: state.chats,
                      users: state.users,
                    ),
            ),
          ],
        );
      },
    );
  }

  void showNewChatModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.of(context).hilightBlue,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.BORDER_RADIUS_10),
          topRight: Radius.circular(AppDimens.BORDER_RADIUS_10),
        ),
      ),
      builder: (_) {
        return SizedBox(
          height: AppDimens.heightNewChat,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: AppDimens.PADDING_19),
                    child: Text(
                      'new_chat'.tr(),
                      style: AppFonts.normal20.copyWith(
                        color: AppColors.of(context).darkGray,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset(AppImages.cancelIcon),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    AppTextField(
                      controller: uuidController,
                      hintText: 'user_uuid'.tr(),
                      width: 340,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppDimens.PADDING_30,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<MessagesBloc>(context).add(
                            NewChatEvent(uuid: uuidController.value.text),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: AppFonts.robotoBold16.copyWith(
                            color: AppColors.of(context).white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppDimens.BORDER_RADIUS_8),
                          ),
                          backgroundColor: AppColors.of(context).blue,
                        ),
                        child: Text('create'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    uuidController.dispose();
    super.dispose();
  }
}
