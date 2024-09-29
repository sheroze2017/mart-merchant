import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/model/all_attendance_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../b.a/dashboard/view/dashboard.dart';

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
                                  : Colors.green)),
                      title: Text(
                        'Dated: ' + data1.date.toString(),
                        style: CustomTextStyles.lightTextStyle(),
                      ),
                      subtitle: data1.status == 'absent'
                          ? null
                          : Column(
                              children: [
                                Text("checkin Time: " +
                                    data1.checkinTime.toString()),
                                Text("checkout Time: " +
                                    data1.checkoutTime.toString()),
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
