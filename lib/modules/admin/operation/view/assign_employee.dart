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

class AssignNewEmploye extends StatelessWidget {
  AssignNewEmploye({super.key});
  final TextEditingController locationController = TextEditingController();
  final AdminOperation companyController = Get.put(AdminOperation());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Assign Employee'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const heading(title: 'Select Compnay'),
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
              const heading(title: 'Select Employee'),
              CustomDropdown(
                decoration: CustomDropdownDecoration(
                  prefixIcon: Icon(Icons.location_on_sharp),
                  expandedFillColor: AppColors.primaryColor,
                  closedFillColor: AppColors.primaryColor,
                ),
                hintText: 'Select Employee',
                items: companyController.companies
                    .map((company) => company.name)
                    .toList(),
                onChanged: (selected) {
                  if (selected != null) {
                    companyController.selectCompanyByName(selected);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: RoundedButtonSmall(
                  text: 'Save',
                  onPressed: () {},
                  backgroundColor: AppColors.primaryColorDark,
                  textColor: AppColors.whiteColor),
            )
          ],
        ),
      ),
    );
  }
}
