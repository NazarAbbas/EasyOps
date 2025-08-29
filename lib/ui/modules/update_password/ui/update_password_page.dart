import 'package:easy_ops/ui/modules/update_password/controller/UpdatePasswordController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordPage extends StatelessWidget {
  UpdatePasswordPage({super.key});

  final UpdatePasswordController controller = Get.put(
    UpdatePasswordController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: const Color(0xFF4285F4),
        //elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text(
          "Update Password",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter Password", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Obx(
              () => TextField(
                controller: controller.passwordController,
                obscureText: controller.isPasswordHidden.value,
                decoration: InputDecoration(
                  hintText: "********",
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.blue,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Re-Enter Password", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Obx(
              () => TextField(
                controller: controller.confirmPasswordController,
                obscureText: controller.isConfirmPasswordHidden.value,
                decoration: InputDecoration(
                  hintText: "********",
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.blue,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: controller.updatePassword,
                child: const Text(
                  "Update Password",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
