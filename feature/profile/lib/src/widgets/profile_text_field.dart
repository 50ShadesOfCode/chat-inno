import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool disabled;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).gray,
        borderRadius: BorderRadius.circular(4),
      ),
      height: 40,
      width: 250,
      child: TextField(
        enabled: !disabled,
        decoration: InputDecoration(
          hintText: hintText,
          //contentPadding: EdgeInsets.symmetric(horizontal: 9),
        ),
        controller: controller,
      ),
    );
  }
}