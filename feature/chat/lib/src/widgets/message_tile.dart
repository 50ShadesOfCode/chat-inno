import 'package:chat_feature/src/widgets/file_display.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final Message message;
  final User sender;
  final bool isSent;

  const MessageTile({
    required this.isSent,
    required this.sender,
    required this.message,
    super.key,
  });

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  late Message message;
  late User sender;
  late bool isSent;

  @override
  void initState() {
    super.initState();
    message = widget.message;
    sender = widget.sender;
    isSent = widget.isSent;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isSent) ...<Widget>[
          sender.imageUrl != ''
              ? Image.network(
                  width: AppDimens.IMAGE_SIZE_40,
                  height: AppDimens.IMAGE_SIZE_40,
                  sender.imageUrl,
                )
              : SvgPicture.asset(
                  AppImages.profileIcon,
                  width: AppDimens.IMAGE_SIZE_40,
                  height: AppDimens.IMAGE_SIZE_40,
                ),
        ],
        Container(
          constraints: const BoxConstraints(
            minHeight: 40,
            maxWidth: 303,
            minWidth: 115,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.of(context).gray,
              borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS_4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            sender.username,
                            style: AppFonts.normal12.copyWith(
                              color: AppColors.of(context).black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          DateTimeTransformer.transform(message.sendTime),
                          style: AppFonts.normal12
                              .copyWith(color: AppColors.of(context).darkGray),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: message.files.isEmpty
                      ? Text(
                          message.text,
                          style: AppFonts.normal14.copyWith(
                            color: AppColors.of(context).darkGray,
                          ),
                        )
                      : FileDisplay(files: message.files),
                ),
              ],
            ),
          ),
        ),
        if (isSent) ...<Widget>[
          sender.imageUrl != ''
              ? Image.network(
                  width: AppDimens.IMAGE_SIZE_40,
                  height: AppDimens.IMAGE_SIZE_40,
                  sender.imageUrl,
                )
              : SvgPicture.asset(
                  AppImages.profileIcon,
                  width: AppDimens.IMAGE_SIZE_40,
                  height: AppDimens.IMAGE_SIZE_40,
                ),
        ],
      ],
    );
  }
}
