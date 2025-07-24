import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomOutLinedButton extends StatelessWidget {
  const CustomOutLinedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backGroundColor,
    this.foreGroundColor,
    this.buttonHeight,
  });
  final void Function()? onPressed;
  final String label;
  final Color? backGroundColor;
  final Color? foreGroundColor;
  final double? buttonHeight;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.baseColor),
          backgroundColor: Colors.white,
          foregroundColor: foreGroundColor ?? AppColors.baseColor,
          minimumSize: Size(MediaQuery.of(context).size.width, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ));
  }
}
