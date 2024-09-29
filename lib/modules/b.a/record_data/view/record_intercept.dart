import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/record_bloc.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordIntercept extends StatelessWidget {
  const RecordIntercept({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CustomDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final RecordController controller = Get.find();

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
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
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
                        final numberOfPeople = _controller.text;
                        print(numberOfPeople);
                        print(_controller.text);
                        controller.recordIntercept(context, _controller.text);
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
