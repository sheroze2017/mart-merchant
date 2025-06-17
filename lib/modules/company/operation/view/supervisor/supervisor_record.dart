import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/view/sales/sales_detail_screen.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_competitor_activity_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_sales_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/company_supervisor_record_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SupervisorRecordData extends StatelessWidget {
  SupervisorRecordData({super.key});
  final controllerCompany = Get.find<CompanyOperationBloc>();
  final TextEditingController martId = TextEditingController();
  final TextEditingController emplyeeId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Supervisor Record'),
      body: GetBuilder<SupervisorRecordController>(
        init: SupervisorRecordController(),
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: CustomDropdown.search(
                          hintText: 'Select Mart',
                          items: controllerCompany.marts
                              .map((m) => m.martName)
                              .toList(),
                          onChanged: (value) {
                            int exactIndex = controllerCompany.marts
                                .indexWhere((m) => m.martName == value);
                            if (exactIndex != -1) {
                              martId.text = controllerCompany
                                  .marts[exactIndex].martId
                                  .toString();
                              controller.getSupervisorData(martId.text);
                            }
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.getSupervisorData('');
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
              ),
              Expanded(
                child: controller.salesLoader.value
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loader when loading data
                    : controller.activityList.isEmpty
                        ? Center(
                            child: Text(
                                'No Data Found')) // Show message if no data is found
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
                                    '${saleData['name']}',
                                    style: CustomTextStyles.w600TextStyle(),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Reported Date: ${Utils.formatDate(saleData['created_at']) + ' ' + Utils.formatTime(saleData['created_at'])}',
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
                                        'Email: ${saleData['email'] ?? ''}',
                                        style: CustomTextStyles.lightTextStyle(
                                            size: 13),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Phone: ${saleData['phone'] ?? ''}',
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
                                              text: 'View Report',
                                              onPressed: () {
                                                showActivityDetailsDialog(
                                                  context,
                                                  imageUrl: saleData['image'],
                                                  description:
                                                      saleData['description'],
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

void showActivityDetailsDialog(
  BuildContext context, {
  required String imageUrl,
  required String description,
}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7, // 70% of screen
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Activity Details',
                style: CustomTextStyles.darkTextStyle().copyWith(fontSize: 20),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          height: 300,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, size: 60),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
