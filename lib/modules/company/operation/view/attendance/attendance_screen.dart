import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/view/attendance/ba_attendance_detail.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/date_selector_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../b.a/dashboard/view/dashboard.dart';

class BaAttendanceCompanyView extends StatefulWidget {
  BaAttendanceCompanyView({super.key});

  @override
  State<BaAttendanceCompanyView> createState() =>
      _BaAttendanceCompanyViewState();
}

class _BaAttendanceCompanyViewState extends State<BaAttendanceCompanyView> {
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final CompanyOperationBloc controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.companyIndividual.value = null;
    controller.getAllBaAttendance('', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'B.A Attendance'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomDateTimeField(
                    format: DateFormat("yyyy-MM-dd"),
                    hintText: 'Start Date',
                    customValidator: (DateTime? value) {
                      if (value != null) {
                        startDate.text = value.toString().split(" ")[0];
                        print(startDate.text);
                        return null;
                      } else {
                        return 'please enter start date';
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomDateTimeField(
                    format: DateFormat("yyyy-MM-dd"),
                    hintText: 'End Date',
                    customValidator: (DateTime? value) {
                      if (value != null) {
                        endDate.text = value.toString().split(" ")[0];
                        print(endDate.text);

                        return null;
                      } else {
                        return 'Required';
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    if (startDate.text.isNotEmpty && endDate.text.isNotEmpty) {
                      controller.getAllBaAttendance(
                          startDate.text, endDate.text);
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.search),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              height: 1.h,
            ),
            Expanded(
              child: Obx(() => controller.getAllBaAttendanceLoader.value
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: controller.userAttendance.length,
                      itemBuilder: (context, index) {
                        final data = controller.userAttendance[index];
                        if (controller.companyIndividual.value == null) {
                          return Card(
                            color: AppColors.primaryColor,
                            elevation: 2,
                            child: ExpansionTile(
                              title: Text(
                                data.name.toString(),
                                style: CustomTextStyles.darkTextStyle(),
                              ),
                              trailing: const Icon(Icons.expand_more_rounded),
                              childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Email: ${data.email}',
                                    style: CustomTextStyles.lightTextStyle(
                                        size: 13),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'UserId: ${data.userId}',
                                    style: CustomTextStyles.lightTextStyle(
                                        size: 13),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RoundedButton(
                                          text: 'Details',
                                          onPressed: () {
                                            print('d');
                                            Get.to(BaAttendanceDetail(
                                              data: data,
                                            ));
                                          },
                                          backgroundColor:
                                              AppColors.primaryColorDark,
                                          textColor: AppColors.whiteColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else if (controller.companyIndividual.value != null &&
                            controller.companyIndividual.value!.userId ==
                                data.userId) {
                          return Card(
                            color: AppColors.primaryColor,
                            elevation: 2,
                            child: ExpansionTile(
                              title: Text(
                                data.name.toString(),
                                style: CustomTextStyles.darkTextStyle(),
                              ),
                              trailing: const Icon(Icons.expand_more_rounded),
                              childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Email: ${data.email}',
                                    style: CustomTextStyles.lightTextStyle(
                                        size: 13),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'UserId: ${data.userId}',
                                    style: CustomTextStyles.lightTextStyle(
                                        size: 13),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RoundedButton(
                                          text: 'Details',
                                          onPressed: () {
                                            print('d');
                                            Get.to(BaAttendanceDetail(
                                              data: data,
                                            ));
                                          },
                                          backgroundColor:
                                              AppColors.primaryColorDark,
                                          textColor: AppColors.whiteColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
