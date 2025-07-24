import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/styles.dart';

class CustomColouredButton extends StatelessWidget {
  const CustomColouredButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backGroundColor,
    this.foreGroundColor = Colors.white,
    this.buttonHeight,
  });
  final void Function()? onPressed;
  final String label;
  final Color? backGroundColor;
  final Color foreGroundColor;
  final double? buttonHeight;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.baseColor,
        foregroundColor: foreGroundColor,
        minimumSize: Size(MediaQuery.of(context).size.width, buttonHeight ?? 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FittedBox(
          child: Text(
            label,
            style: AppStyles.getBoldTextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
