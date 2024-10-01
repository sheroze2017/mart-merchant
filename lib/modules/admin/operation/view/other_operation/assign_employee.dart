import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/model/user_by_role_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../b.a/dashboard/view/dashboard.dart';

class AssignNewEmploye extends StatelessWidget {
  final ByUserRoleData user;
  AssignNewEmploye({super.key, required this.user});
  final AdminOperation companyController = Get.find<AdminOperation>();
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
              const heading(title: 'BA Detail'),
              Card(
                color: AppColors.redLight,
                child: ListTile(
                  title: Text('Name: ' + user.name.toString(),
                      style: CustomTextStyles.darkTextStyle()),
                  subtitle: Text('Email: ' + user.email.toString(),
                      style: CustomTextStyles.lightTextStyle()),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              const heading(title: 'Select Compnay'),
              Card(
                elevation: 2,
                child: CustomDropdown.search(
                  decoration: CustomDropdownDecoration(
                    prefixIcon: Icon(Icons.location_on_sharp),
                    expandedFillColor: AppColors.primaryColor,
                    closedFillColor: AppColors.primaryColor,
                  ),
                  hintText: 'Select Company',
                  items: companyController.companyNameList
                      .map((company) => company.name)
                      .toList(),
                  onChanged: (selected) {
                    if (selected != null) {
                      companyController.selectCompanyByName(selected);
                      companyController.getAllMart();
                    }
                  },
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              const heading(title: 'Select Mart'),
              Card(
                elevation: 2,
                child: CustomDropdown.search(
                  decoration: CustomDropdownDecoration(
                    prefixIcon: Icon(Icons.location_on_sharp),
                    expandedFillColor: AppColors.primaryColor,
                    closedFillColor: AppColors.primaryColor,
                  ),
                  hintText: 'Select Mart',
                  items:
                      companyController.marts.map((ba) => ba.martName).toList(),
                  onChanged: (selected) {
                    if (selected != null) {
                      companyController.selectMartbyName(selected);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
                child: Obx(
              () => RoundedButtonSmall(
                  showLoader: companyController.assignBaLoader.value,
                  text: 'Save',
                  onPressed: () async {
                    await companyController.assignBAToCompanyMart(
                        user.userId.toString(), context);
                  },
                  backgroundColor: AppColors.primaryColorDark,
                  textColor: AppColors.whiteColor),
            ))
          ],
        ),
      ),
    );
  }
}
