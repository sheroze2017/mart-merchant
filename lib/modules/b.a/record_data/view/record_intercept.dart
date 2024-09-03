import 'package:ba_merchandise/common/style/custom_textstyle.dart';
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
            Material(
              color: Colors.transparent,
              child: Text(
                'Record Number of People Encountered Today',
                style: CustomTextStyles.darkHeadingTextStyle(),
              ),
            ),
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
                    backgroundColor: Colors.white,
                    textColor: Colors.black),
                SizedBox(width: 10),
                RoundedButtonSmall(
                    text: 'Record',
                    onPressed: () {
                      // Handle submission logic here
                      final numberOfPeople = _controller.text;
                      print('Number of people: $numberOfPeople');
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    backgroundColor: Colors.blue.shade900,
                    textColor: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
