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
          BlocProvider.of<MessagesBloc>(context).add(OpenChatEvent(chat: chat));
        },
        child: Container(
          height: AppDimens.heightChatTile,
          decoration: BoxDecoration(
            color: AppColors.of(context).gray,
            borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS_4),
          ),
          child: Column(
            children: <Widget>[
              Text(chat.lastMessage?.sendTime.toString() ?? ''),
              Row(
                children: <Widget>[
                  user.imageUrl != ''
                      ? Image.network(
                          user.imageUrl,
                          height: AppDimens.IMAGE_SIZE_50,
                          width: AppDimens.IMAGE_SIZE_50,
                        )
                      : SvgPicture.asset(
                          AppImages.profileIcon,
                          height: AppDimens.IMAGE_SIZE_50,
                          width: AppDimens.IMAGE_SIZE_50,
                        ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(user.username),
                        Text(chat.lastMessage?.content ?? ''),
                      ],
                    ),
                  ),
                  Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
