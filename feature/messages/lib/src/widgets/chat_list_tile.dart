import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import '../bloc/messages_bloc.dart';

class ChatListTile extends StatefulWidget {
  final Chat chat;
  final User user;

  const ChatListTile({
    super.key,
    required this.chat,
    required this.user,
  });

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  late Chat chat;
  late User user;

  @override
  void initState() {
    super.initState();
    chat = widget.chat;
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.PADDING_5),
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<MessagesBloc>(context).add(
            OpenChatEvent(
              chatUuid: chat.uuid,
              receiverUuid: user.uuid,
            ),
          );
        },
        child: Container(
          alignment: Alignment.centerLeft,
          height: AppDimens.heightChatTile,
          decoration: BoxDecoration(
            color: AppColors.of(context).gray,
            borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS_4),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppDimens.PADDING_11,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    chat.lastMessage == null
                        ? ''
                        : DateTimeTransformer.transform(
                            chat.lastMessage!.sendTime),
                    style: AppFonts.normal10.copyWith(
                      color: AppColors.of(context).darkGray,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(right: AppDimens.PADDING_5),
                      child: user.imageUrl != ''
                          ? Image.network(
                              user.imageUrl,
                              height: AppDimens.IMAGE_SIZE_30,
                              width: AppDimens.IMAGE_SIZE_30,
                            )
                          : SvgPicture.asset(
                              AppImages.profileIcon,
                              height: AppDimens.IMAGE_SIZE_30,
                              width: AppDimens.IMAGE_SIZE_30,
                            ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            user.username,
                            style: AppFonts.normal14,
                          ),
                          Text(
                            chat.lastMessage == null
                                ? 'No messages...'
                                : chat.lastMessage!.text,
                            style: AppFonts.normal12.copyWith(
                              color: AppColors.of(context).darkGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: AppDimens.PADDING_20,
                      ),
                      child: Container(
                        child: SvgPicture.asset(
                          AppImages.openChatIcon,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
