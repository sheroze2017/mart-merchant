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

class SupervisorRecordData extends StatefulWidget {
  SupervisorRecordData({super.key});

  @override
  State<SupervisorRecordData> createState() => _SupervisorRecordDataState();
}

class _SupervisorRecordDataState extends State<SupervisorRecordData> {
  final controllerCompany = Get.find<CompanyOperationBloc>();

  final TextEditingController martId = TextEditingController();

  final TextEditingController emplyeeId = TextEditingController();

  final SingleSelectController<String> catController =
      SingleSelectController<String>(null);

  final SingleSelectController<String> martController =
      SingleSelectController<String>(null);

  final SingleSelectController<String> companyController =
      SingleSelectController<String>(null);

  String catId = '';
  @override
  void initState() {
    super.initState();
    controllerCompany.getAllCategory();
  }

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
                          controller: martController,
                          decoration: CustomDropdownDecoration(
                            prefixIcon: const Icon(Icons.location_on_sharp),
                            expandedFillColor: AppColors.primaryColor,
                            closedFillColor: AppColors.primaryColor,
                          ),
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
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        controller.getSupervisorData('');
                        martController.clear();
                        martId.clear();
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        decoration: CustomDropdownDecoration(
                          prefixIcon: Icon(Icons.location_on_sharp),
                          expandedFillColor: AppColors.primaryColor,
                          closedFillColor: AppColors.primaryColor,
                        ),
                        controller: catController,
                        hintText: 'Select Category',
                        items: controllerCompany.categories
                            .map((category) => category.name)
                            .toList(),
                        onChanged: (value) {
                          if (value != null && value.isNotEmpty) {
                            final selectedCat =
                                controllerCompany.categories.firstWhere(
                              (cat) => cat.name == value,
                            );
                            catId = selectedCat.categoryId.toString();
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        catController.clear();
                        catId = '';
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
              ),
              Expanded(
                child: controller.salesLoader.value
                    ? const Center(
                        child:
                            CircularProgressIndicator()) // Show loader when loading data
                    : controller.activityList.isEmpty
                        ? const Center(
                            child: Text(
                                'No Data Found')) // Show message if no data is found
                        : ListView.builder(
                            itemCount: controller.activityList.length,
                            itemBuilder: (context, index) {
                              var saleData = controller.activityList[index];
                              if (catId.isEmpty ||
                                  catId == saleData['category_id']) {
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
                                          style:
                                              CustomTextStyles.lightTextStyle(
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
                                          style:
                                              CustomTextStyles.lightTextStyle(
                                                  size: 13),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Phone: ${saleData['phone'] ?? ''}',
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
                                                textColor:
                                                    AppColors.whiteColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
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
