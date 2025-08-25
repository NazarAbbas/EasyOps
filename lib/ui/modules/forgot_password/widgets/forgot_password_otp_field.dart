import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordOtpField extends StatelessWidget {
  final void Function(String)? onCompleted;

  const ForgotPasswordOtpField({super.key, this.onCompleted});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: PinCodeTextField(
        appContext: context,
        length: 4,
        keyboardType: TextInputType.number,
        animationType: AnimationType.fade,
        textStyle: TextStyle(
          fontSize: isTablet ? 24 : 20,
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          fieldHeight: isTablet ? 70 : 50,
          fieldWidth: isTablet ? 60 : 40,
          inactiveColor: Colors.grey,
          activeColor: AppColors.primaryBlue,
          selectedColor: AppColors.primaryBlue,
        ),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        onChanged: (value) {},
        onCompleted: (value) {
          if (onCompleted != null) {
            onCompleted!(value);
          }
        },
      ),
    );
  }
}
