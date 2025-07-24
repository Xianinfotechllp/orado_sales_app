import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'custom_coloured_button.dart';
import 'custom_outlined_button.dart';

class CustomButton {
  Widget showColouredButton({
    final void Function()? onPressed,
    required final String label,
    final Color? backGroundColor,
    final Color? foreGroundColor,
    final double? buttonHeight,
  }) {
    return CustomColouredButton(
      label: label,
      onPressed: onPressed,
      backGroundColor: backGroundColor,
      buttonHeight: buttonHeight,
      foreGroundColor: foreGroundColor ?? Colors.white,
    );
  }

  Widget showOutlinedButton({
    final void Function()? onPressed,
    required final String label,
    final Color? backGroundColor,
    final Color? foreGroundColor,
    final double? buttonHeight,
  }) {
    return CustomOutLinedButton(
      label: label,
      onPressed: onPressed,
      backGroundColor: backGroundColor,
      buttonHeight: buttonHeight,
      foreGroundColor: foreGroundColor ?? AppColors.baseColor,
    );
  }
}
