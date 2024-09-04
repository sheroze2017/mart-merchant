import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MarkAbsentDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final VoidCallback onMarkAbsent;
  final String markAbsentText;
  final String dailogText;

  MarkAbsentDialog({
    required this.onMarkAbsent,
    required this.markAbsentText,
    required this.dailogText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
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
              child: Container(
                height: 10.h,
                width: 20.w,
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: Text(
                dailogText,
                style: CustomTextStyles.darkHeadingTextStyle(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: RoundedButtonSmall(
                    text: 'No',
                    onPressed: () {
                      Get.back();
                    },
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: RoundedButtonSmall(
                    text: markAbsentText,
                    onPressed: onMarkAbsent,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
