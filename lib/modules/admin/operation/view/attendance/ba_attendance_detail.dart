import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/model/all_attendance_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BaAttendanceDetail extends StatelessWidget {
  final IndividualUserAttendance data;
  BaAttendanceDetail({super.key, required this.data});

  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Attendance Detail'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${data.name}',
              style: CustomTextStyles.darkHeadingTextStyle(size: 20),
            ),
            SizedBox(
              height: 1.h,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: data.attendanceRecords!.length ?? 0,
                itemBuilder: (context, index) {
                  final data1 = data.attendanceRecords![index];
                  return Card(
                    color: AppColors.primaryColor,
                    elevation: 2,
                    child: ListTile(
                      leading: Text(data1.status.toString().toUpperCase(),
                          style: CustomTextStyles.darkHeadingTextStyle(
                              color: data1.status == "absent"
                                  ? Colors.red
                                  : data1.status!.toLowerCase() == "late"
                                      ? Colors.brown
                                      : Colors.green)),
                      title: Text(
                        'Dated: ' + data1.date.toString(),
                        style: CustomTextStyles.lightTextStyle(),
                      ),
                      subtitle: data1.status == 'absent'
                          ? null
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "checkin Time: ${data1.checkinTime!.split(' ')[1]}",
                                  style: CustomTextStyles.lightTextStyle(),
                                ),
                                Text(
                                  "checkout Time: ${data1.checkoutTime!.split(' ')[1]}",
                                  style: CustomTextStyles.lightTextStyle(),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
