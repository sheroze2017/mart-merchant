import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomDialogMessage extends StatelessWidget {
  final String dialogText;
  final String buttonText1;
  final String buttonText2;
  final VoidCallback onButton1Pressed;
  final VoidCallback onButton2Pressed;

  CustomDialogMessage({
    required this.dialogText,
    required this.buttonText1,
    required this.buttonText2,
    required this.onButton1Pressed,
    required this.onButton2Pressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: SizedBox(
                height: 10.h,
                width: 20.w,
                child: const Image(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: Text(
                dialogText,
                style: CustomTextStyles.darkHeadingTextStyle(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: RoundedButtonSmall(
                    text: buttonText1,
                    onPressed: onButton1Pressed,
                    backgroundColor: AppColors.whiteColor,
                    textColor: Colors.black,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: RoundedButtonSmall(
                    text: buttonText2,
                    onPressed: onButton2Pressed,
                    backgroundColor: Colors.red,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().slide(duration: Duration(milliseconds: 300));
  }
}
