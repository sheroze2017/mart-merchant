import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/record_bloc.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomDialog extends StatelessWidget {
  final TextEditingController textcontroller;
  final RecordController controller = Get.find();
  CustomDialog({required this.textcontroller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: Text(
                'Record Number of People Encountered Today',
                style: CustomTextStyles.darkHeadingTextStyle(),
              ),
            ),
            Text(
                'Note: It could be recorded only once at a time make sure to write it correctly',
                style: CustomTextStyles.lightTextStyle()),
            SizedBox(height: 20),
            TextFormField(
              validator: Validator.ValidText,
              controller: textcontroller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Allow only numbers

              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Number of People',
                labelStyle: CustomTextStyles.lightTextStyle(),
                hintText: 'Enter the number of people',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RoundedButtonSmall(
                    text: 'Cancel',
                    onPressed: () {
                      Get.back();
                    },
                    backgroundColor: AppColors.whiteColor,
                    textColor: Colors.black),
                SizedBox(width: 10),
                Obx(
                  () => RoundedButtonSmall(
                      showLoader: controller.statusRecordLoader.value,
                      text: 'Record',
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        // Handle submission logic here
                        if (textcontroller.text.isEmpty) {
                          AnimatedSnackbar.showSnackbar(
                            context: context,
                            message: 'Please enter count',
                            icon: Icons.info,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                        } else {
                          controller.recordIntercept(
                              context, textcontroller.text);
                        }
                      },
                      backgroundColor: Colors.blue.shade900,
                      textColor: AppColors.whiteColor),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
