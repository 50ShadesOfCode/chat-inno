import 'dart:io';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'bloc/chat_bloc.dart';
import 'widgets/chat_bottom_bar.dart';
import 'widgets/message_tile.dart';

class ChatForm extends StatefulWidget {
  const ChatForm({super.key});

  @override
  State<ChatForm> createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  List<File> files = <File>[];
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (BuildContext context, ChatState state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.of(context).gray,
              leading: IconButton(
                icon: SvgPicture.asset(
                  AppImages.backIcon,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'Chat: ${state.sender.username} - ${state.receiver.username}',
                style: AppFonts.normal14
                    .copyWith(color: AppColors.of(context).black),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: AppDimens.PADDING_14),
                  child: PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuItem>[
                        PopupMenuItem(
                          height: AppDimens.popUpMenuHeight,
                          child: InkWell(
                            onTap: () {
                              BlocProvider.of<ChatBloc>(context)
                                  .add(DeleteChatEvent());
                              Navigator.of(context).pop();
                            },
                            child: SizedBox(
                              height: AppDimens.popUpMenuHeight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(AppImages.trashIcon),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: AppDimens.PADDING_10,
                                    ),
                                    child: Text(
                                      'delete_chat'.tr(),
                                      style: AppFonts.normal20.copyWith(
                                        color: AppColors.of(context).black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    child: SvgPicture.asset(
                      AppImages.moreIcon,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: state.messages.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: MessageTile(
                        isSent: state.messages[index].senderUuid ==
                            state.senderUuid,
                        sender:
                            state.messages[index].senderUuid == state.senderUuid
                                ? state.sender
                                : state.receiver,
                        message: state.messages[index],
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(files[index].path),
                    );
                  },
                ),
                ChatBottomBar(
                  controller: messageController,
                  onTapAdd: () {
                    showFilePicker();
                  },
                  onTapSend: () {
                    BlocProvider.of<ChatBloc>(context).add(
                      SendMessageEvent(
                        files: files,
                        message: messageController.value.text,
                      ),
                    );
                    messageController.clear();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> showFilePicker() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    final List<File> pickedFiles = <File>[];
    if (result != null) {
      for (final String? path in result.paths) {
        if (path != null) {
          pickedFiles.add(File(path));
        }
      }
    }
    setState(() {
      files = pickedFiles;
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
