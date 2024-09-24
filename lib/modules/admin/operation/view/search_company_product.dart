import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/merchandiser/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import '../../../b.a/dashboard/view/dashboard.dart';

class SearchCompanyProduct extends StatelessWidget {
  SearchCompanyProduct({super.key});
  final TextEditingController locationController = TextEditingController();
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final AdminOperation companyController = Get.put(AdminOperation());
  List<int> restockCount = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Company Products'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const heading(title: 'Select location to find company products'),
              CustomDropdown(
                decoration: CustomDropdownDecoration(
                  prefixIcon: Icon(Icons.location_on_sharp),
                  expandedFillColor: AppColors.primaryColor,
                  closedFillColor: AppColors.primaryColor,
                ),
                hintText: 'Select Company',
                items: companyController.companies
                    .map((company) => company.name)
                    .toList(),
                onChanged: (selected) {
                  if (selected != null) {
                    companyController.selectCompanyByName(selected);
                  }
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              headingSmall(
                title: 'Product List ${locationController.text}',
              ),
              Obx(() {
                if (companyController.selectedCompany.value == null) {
                  return const Center(
                    child: headingSmall(
                        title: 'Select a company to view its products'),
                  );
                }
                final selectedCompany =
                    companyController.selectedCompany.value!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: selectedCompany.products.length,
                  itemBuilder: (context, index) {
                    final product = selectedCompany.products[index];
                    return Card(
                      color: AppColors.whiteColor,
                      elevation: 2,
                      child: ListTile(
                          minVerticalPadding: 10,
                          title: Text(product.name,
                              style: CustomTextStyles.darkTextStyle()),
                          subtitle: Text(
                              '${product.quantity} gm - PKR ${product.price}',
                              style: CustomTextStyles.lightSmallTextStyle())),
                    );
                  },
                );
              }),
              // Obx(
              //   () => ListView.builder(
              //       shrinkWrap: true,
              //       physics: NeverScrollableScrollPhysics(),
              //       itemCount: controller.records.length,
              //       itemBuilder: (context, index) {
              //         return Card(
              //             color: AppColors.whiteColor,
              //             elevation: 2,
              //             child: ListTile(
              //               minVerticalPadding: 10,
              //               title: Text(controller.records[index].name,
              //                   style: CustomTextStyles.darkTextStyle()),
              //               subtitle: Obx(() => Text(
              //                   '${controller.records[index].quantityGm} gm - PKR ${controller.records[index].pricePkr}',
              //                   style: CustomTextStyles.lightSmallTextStyle())),
              //             ));
              //       }),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
  
  //               () => ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: NeverScrollableScrollPhysics(),
  //                   itemCount: controller.records.length,
  //                   itemBuilder: (context, index) {
  //                     return Card(
  //                         color: AppColors.whiteColor,
  //                         elevation: 2,
  //                         child: ListTile(
  //                           minVerticalPadding: 10,
  //                           title: Text(controller.records[index].name,
  //                               style: CustomTextStyles.darkTextStyle()),
  //                           subtitle: Obx(() => Text(
  //                               '${controller.records[index].quantityGm} gm - PKR ${controller.records[index].pricePkr}',
  //                               style: CustomTextStyles.lightSmallTextStyle())),
  //                         ));
  //                   }),
  //             ),