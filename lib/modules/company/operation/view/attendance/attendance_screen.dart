import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
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

class BaAttendanceCompanyView extends StatefulWidget {
  BaAttendanceCompanyView({super.key});

  @override
  State<BaAttendanceCompanyView> createState() =>
      _BaAttendanceCompanyViewState();
}

class _BaAttendanceCompanyViewState extends State<BaAttendanceCompanyView> {
  final TextEditingController startDate = TextEditingController();
  final SingleSelectController<String> martNameController =
      SingleSelectController<String>(null);
  String martName = '';

  final TextEditingController endDate = TextEditingController();
  final CompanyOperationBloc controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.companyIndividual.value = null;
    controller.getAllBaAttendance('', '');
    controller.marts.isEmpty ? controller.getAllMart() : null;
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
              height: 1.h,
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
                        if (martName.isEmpty ||
                            martName == data.martName.toString()) {
                          if (controller.companyIndividual.value == null) {
                            return Card(
                              color: AppColors.primaryColor,
                              elevation: 2,
                              child: ExpansionTile(
                                title: Text(
                                  data.name.toString(),
                                  style: CustomTextStyles.darkTextStyle(),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (data.martName != null)
                                      Text(
                                        'Mart Name: ${data.martName}',
                                        style:
                                            CustomTextStyles.lightTextStyle(),
                                      ),
                                    if (data.categoryName != null)
                                      Text(
                                        'Category: ${data.categoryName}',
                                        style:
                                            CustomTextStyles.lightTextStyle(),
                                      ),
                                  ],
                                ),
                                trailing: const Icon(Icons.expand_more_rounded),
                                childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 0.0),
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Email: ${data.email}',
                                      style: CustomTextStyles.darkTextStyle()
                                          .copyWith(fontSize: 12),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'UserId: ${data.userId}',
                                      style: CustomTextStyles.darkTextStyle()
                                          .copyWith(fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          } else if (controller.companyIndividual.value !=
                                  null &&
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
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (data.martName != null)
                                      Text(
                                        'Mart Name: ${data.martName}',
                                        style:
                                            CustomTextStyles.lightTextStyle(),
                                      ),
                                    if (data.categoryName != null)
                                      Text(
                                        'Category: ${data.categoryName}',
                                        style:
                                            CustomTextStyles.lightTextStyle(),
                                      ),
                                  ],
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
                                  SizedBox(
                                    height: 2.h,
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
                        } else {
                          return const SizedBox();
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
