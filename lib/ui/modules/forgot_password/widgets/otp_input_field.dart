import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInputField extends StatelessWidget {
  const OtpInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      textStyle: const TextStyle(fontSize: 20),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        fieldHeight: 50,
        fieldWidth: 35,
        inactiveColor: Colors.blue,
        activeColor: Colors.blue,
        selectedColor: Colors.blue,
      ),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      onChanged: (value) {},
      onCompleted: (value) {
        // ✅ OTP completed
      },
    );
  }
}
