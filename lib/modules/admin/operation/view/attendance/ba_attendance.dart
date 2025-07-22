import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/view/attendance/ba_attendance_detail.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/date_selector_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../b.a/dashboard/view/dashboard.dart';

class BaAttendance extends StatefulWidget {
  BaAttendance({super.key});

  @override
  State<BaAttendance> createState() => _BaAttendanceState();
}

class _BaAttendanceState extends State<BaAttendance> {
  final SingleSelectController<String> locationController =
      SingleSelectController<String>(null);
  final SingleSelectController<String> martNameController =
      SingleSelectController<String>(null);
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final AdminOperation controller = Get.find<AdminOperation>();
  String martName = '';
  @override
  void initState() {
    super.initState();
    controller.companyIndividual.value = null;
    controller.marts.isEmpty ? controller.getAllMart() : null;
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
                    onChanged: (p0) {
                      startDate.text = p0.toString().split(" ")[0];
                      controller.getAllBaAttendance(
                          startDate.text, endDate.text);
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
                    onChanged: (p0) {
                      endDate.text = p0.toString().split(" ")[0];
                      controller.getAllBaAttendance(
                          startDate.text, endDate.text);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            const heading(title: 'Search Employee Attendance'),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: CustomDropdown(
                      controller: locationController,
                      decoration: CustomDropdownDecoration(
                        prefixIcon: Icon(Icons.location_on_sharp),
                        expandedFillColor: AppColors.primaryColor,
                        closedFillColor: AppColors.primaryColor,
                      ),
                      hintText: 'Select Company',
                      items: controller.companyNameList
                          .map((company) => company.name)
                          .toList(),
                      onChanged: (selected) {
                        if (selected != null) {
                          controller.companyIndividual.value = controller
                              .companyNameList
                              .firstWhere((e) => e.name == selected);
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    controller.companyIndividual.value = null;
                    locationController.clear();
                    setState(() {});
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.cancel),
                      )),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: CustomDropdown.search(
                      controller: martNameController,
                      decoration: CustomDropdownDecoration(
                        prefixIcon: Icon(Icons.keyboard_option_key),
                        expandedFillColor: AppColors.primaryColor,
                        closedFillColor: AppColors.primaryColor,
                      ),
                      hintText: 'Select Mart',
                      items: controller.marts.map((m) => m.martName).toList(),
                      onChanged: (value) {
                        martName = value!;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    martName = '';
                    martNameController.clear();

                    setState(() {});
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.cancel),
                      )),
                )
              ],
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
                        if (martName.isEmpty || martName == data.martName) {
                          if (controller.companyIndividual.value == null) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 50),
                              child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                      child: Card(
                                    color: AppColors.primaryColor,
                                    elevation: 2,
                                    child: ExpansionTile(
                                      title: Text(
                                        data.name.toString(),
                                        style: CustomTextStyles.darkTextStyle(),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (data.martName != null)
                                            Text(
                                              'Mart Name: ${data.martName}',
                                              style: CustomTextStyles
                                                  .lightTextStyle(),
                                            ),
                                          if (data.categoryName != null)
                                            Text(
                                              'Category: ${data.categoryName}',
                                              style: CustomTextStyles
                                                  .lightTextStyle(),
                                            ),
                                        ],
                                      ),
                                      trailing:
                                          const Icon(Icons.expand_more_rounded),
                                      childrenPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 0.0),
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Email: ${data.email}',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    size: 13),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'UserId: ${data.userId}',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    size: 13),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Currently assign: ${Utils.getCompanyNameByUserId(controller.companyNameList, data.companyId.toString())}',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    size: 13),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
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
                                                  backgroundColor: AppColors
                                                      .primaryColorDark,
                                                  textColor:
                                                      AppColors.whiteColor),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                      ],
                                    ),
                                  ))),
                            );
                          } else if (controller.companyIndividual.value!.userId
                                  .toString() ==
                              data.companyId) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 50),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                    child: Card(
                                  color: AppColors.primaryColor,
                                  elevation: 2,
                                  child: ExpansionTile(
                                    title: Text(
                                      data.name.toString(),
                                      style: CustomTextStyles.darkTextStyle(),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (data.martName != null)
                                          Text(
                                            'Mart Name: ${data.martName}',
                                            style: CustomTextStyles
                                                .lightTextStyle(),
                                          ),
                                        if (data.categoryName != null)
                                          Text(
                                            'Category: ${data.categoryName}',
                                            style: CustomTextStyles
                                                .lightTextStyle(),
                                          ),
                                      ],
                                    ),
                                    trailing:
                                        const Icon(Icons.expand_more_rounded),
                                    childrenPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Email: ${data.email}',
                                          style:
                                              CustomTextStyles.lightTextStyle(
                                                  size: 13),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'UserId: ${data.userId}',
                                          style:
                                              CustomTextStyles.lightTextStyle(
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
                                                textColor:
                                                    AppColors.whiteColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return SizedBox();
                        }
                      })),
            ),
          ],
        ),
      ),
    );
  }
}
