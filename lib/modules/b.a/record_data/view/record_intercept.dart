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
  final TextEditingController productSold;

  final RecordController controller = Get.find();
  CustomDialog({required this.textcontroller, required this.productSold});

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
            TextFormField(
              validator: Validator.ValidText,
              controller: productSold,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Product sold qty',
                labelStyle: CustomTextStyles.lightTextStyle(),
                hintText: 'Enter Item count sold',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: RoundedButton(
                      text: 'Cancel',
                      onPressed: () {
                        Get.back();
                      },
                      backgroundColor: AppColors.blackColor,
                      textColor: Colors.white),
                ),
                SizedBox(width: 10),
                Obx(
                  () => Expanded(
                    child: RoundedButton(
                        showLoader: controller.statusRecordLoader.value,
                        text: 'Record',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (textcontroller.text.isEmpty ||
                              productSold.text.isEmpty) {
                            AnimatedSnackbar.showSnackbar(
                              context: context,
                              message: 'Please enter count',
                              icon: Icons.info,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 14.0,
                            );
                          } else if (int.parse(productSold.text) >
                              int.parse(textcontroller.text)) {
                            AnimatedSnackbar.showSnackbar(
                              context: context,
                              message:
                                  "Product sold can't be greater then intercept count",
                              icon: Icons.info,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 14.0,
                            );
                          } else {
                            controller.recordIntercept(
                                context, textcontroller.text, productSold.text);
                          }
                        },
                        backgroundColor: AppColors.primaryColorDark,
                        textColor: AppColors.whiteColor),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
