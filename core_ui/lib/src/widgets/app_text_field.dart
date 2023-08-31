import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? disabled;
  final String? errorText;
  final double? width;
  final bool underline;

  const AppTextField({
    required this.controller,
    required this.hintText,
    super.key,
    this.width,
    this.disabled,
    this.errorText,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).gray,
        borderRadius: BorderRadius.circular(4),
      ),
      height: AppDimens.heightTextField,
      width: width,
      child: TextField(
        enabled: disabled != null ? !disabled! : null,
        decoration: InputDecoration(
          hintText: hintText,
          errorText: errorText,
          border: underline
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.of(context).blue),
                )
              : null,
        ),
        controller: controller,
      ),
    );
  }
}
