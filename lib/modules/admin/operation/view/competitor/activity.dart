import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/competitor_activity_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/sales_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/view/sales/sales_detail_screen.dart';
import 'package:ba_merchandise/modules/company/operation/view/competitor/activity.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompetitorAdminActivity extends StatelessWidget {
  CompetitorAdminActivity({super.key});
  final AdminOperation controllerCompany = Get.find<AdminOperation>();
  final TextEditingController companyId = TextEditingController();
  final TextEditingController martId = TextEditingController();
  final TextEditingController employeeId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Competitor Activity'),
      body: GetBuilder<adminCompetitorActivity>(
        init: adminCompetitorActivity(), // Initialize the controller
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
                child: Card(
                  elevation: 2,
                  child: CustomDropdown.search(
                    hintText: 'Select Company',
                    items: controllerCompany.companyNameList
                        .map((company) => company.name)
                        .toList(),
                    onChanged: (value) {
                      int exactIndex = controllerCompany.companyNameList
                          .indexWhere((m) => m.name == value);
                      if (exactIndex != -1) {
                        companyId.text = controllerCompany
                            .companyNameList[exactIndex].userId
                            .toString();
                        // Fetch the sales data based on selected company and mart ID
                        controller.getActivites(
                          companyId.text,
                          martId.text,
                        );
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12, right: 12),
                child: Card(
                  elevation: 2,
                  child: CustomDropdown.search(
                    hintText: 'Select Mart',
                    items:
                        controllerCompany.marts.map((m) => m.martName).toList(),
                    onChanged: (value) {
                      int exactIndex = controllerCompany.marts
                          .indexWhere((m) => m.martName == value);
                      if (exactIndex != -1) {
                        martId.text = controllerCompany.marts[exactIndex].martId
                            .toString();
                        controller.getActivites(
                          companyId.text,
                          martId.text,
                        );
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: controller.salesLoader.value
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loader when loading data
                    : controller.activityList.isEmpty
                        ? Center(
                            child: Text(
                                'No Activity Data Found')) // Show message if no data is found
                        : ListView.builder(
                            itemCount: controller.activityList.length,
                            itemBuilder: (context, index) {
                              var saleData = controller.activityList[index];
                              return Card(
                                color: AppColors.primaryColor,
                                elevation: 2,
                                margin: EdgeInsets.all(8),
                                child: ExpansionTile(
                                  title: Text(
                                    '${saleData['mart_details']['name']}',
                                    style: CustomTextStyles.w600TextStyle(),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Reported Date: ${Utils.formatDate(saleData['activity_details']['created_at']) + ' ' + Utils.formatTime(saleData['activity_details']['created_at'])}',
                                        style: CustomTextStyles.lightTextStyle(
                                            size: 13),
                                      ),
                                      Text(
                                        'BA Name: ${saleData['user_details']['name'] ?? ''}',
                                        style: CustomTextStyles.lightTextStyle(
                                            size: 13),
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
                                        'Email: ${saleData['user_details']['email'] ?? ''}',
                                        style: CustomTextStyles.lightTextStyle(
                                            size: 13),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Phone: ${saleData['user_details']['phone'] ?? ''}',
                                        style: CustomTextStyles.lightTextStyle(
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
                                              text: 'View Activity',
                                              onPressed: () {
                                                showActivityDetailsDialog(
                                                  context,
                                                  imageUrl: saleData[
                                                          'activity_details']
                                                      ['image'],
                                                  description: saleData[
                                                          'activity_details']
                                                      ['description'],
                                                );
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
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
