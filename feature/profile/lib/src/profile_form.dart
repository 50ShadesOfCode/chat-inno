import 'dart:io';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile/src/bloc/profile_bloc.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController uuidController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  File? _pickedFile;

  Future<void> pickImage({
    required ImageSource imageSource,
  }) async {
    final XFile? pickedFile = await imagePicker.pickImage(
      source: imageSource,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedFile = File(pickedFile.path);
      });
    }
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('gallery'.tr()),
                onTap: () async {
                  await pickImage(
                    imageSource: ImageSource.gallery,
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text('camera'.tr()),
                onTap: () async {
                  await pickImage(
                    imageSource: ImageSource.camera,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (BuildContext context, ProfileState state) {
        return Column(
          children: <Widget>[
            Container(
              height: AppDimens.heightAppBar,
              alignment: Alignment.centerRight,
              color: AppColors.of(context).gray,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: AppDimens.PADDING_11,
                ),
                child: PopupMenuButton(
                  offset: const Offset(
                    AppDimens.OFFSET_0,
                    AppDimens.OFFSET_50,
                  ),
                  child: SvgPicture.asset(
                    AppImages.moreIcon,
                  ),
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuItem>[
                      PopupMenuItem(
                        height: AppDimens.popUpMenuHeight,
                        child: InkWell(
                          onTap: () {
                            BlocProvider.of<ProfileBloc>(context)
                                .add(DeleteUserEvent());
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
                                    'delete_account'.tr(),
                                    style: AppFonts.normal20.copyWith(
                                      color: Colors.black,
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
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.PADDING_25,
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          _pickedFile == null && state.imagePath == ''
                              ? SvgPicture.asset(
                                  AppImages.accountIcon,
                                )
                              : (_pickedFile == null)
                                  ? Image.network(
                                      state.imagePath,
                                      height: AppDimens.IMAGE_SIZE_100,
                                      width: AppDimens.IMAGE_SIZE_100,
                                    )
                                  : Image.file(
                                      _pickedFile!,
                                      height: AppDimens.IMAGE_SIZE_100,
                                      width: AppDimens.IMAGE_SIZE_100,
                                    ),
                          if (!state.isDisabled)
                            IconButton(
                              onPressed: () {
                                showPicker(context);
                              },
                              icon: SvgPicture.asset(
                                AppImages.plusIcon,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        AppTextField(
                          width: AppDimens.widthTextField,
                          controller: uuidController,
                          hintText: state.uuid != '' ? state.uuid : 'UUID'.tr(),
                          disabled: state.isDisabled,
                          errorText: state.isAlreadyExists
                              ? 'already_exists'.tr()
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppDimens.PADDING_11,
                            bottom: AppDimens.PADDING_14,
                          ),
                          child: AppTextField(
                            width: AppDimens.widthTextField,
                            errorText: null,
                            disabled: state.isDisabled,
                            controller: nameController,
                            hintText: state.username != ''
                                ? state.username
                                : 'username'.tr(),
                          ),
                        )
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: AppFonts.robotoBold16.copyWith(
                          color: AppColors.of(context).white,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimens.BORDER_RADIUS_8),
                        ),
                        backgroundColor: AppColors.of(context).blue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.PADDING_16,
                        ),
                        child: Text(
                          state.isDisabled ? 'edit'.tr() : 'save'.tr(),
                        ),
                      ),
                      onPressed: () {
                        BlocProvider.of<ProfileBloc>(context).add(
                          state.isDisabled
                              ? EditEvent()
                              : SaveEvent(
                                  uuid: uuidController.value.text != ''
                                      ? uuidController.value.text
                                      : state.uuid,
                                  username: nameController.value.text != ''
                                      ? nameController.value.text
                                      : state.username,
                                  photo: _pickedFile,
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    uuidController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
