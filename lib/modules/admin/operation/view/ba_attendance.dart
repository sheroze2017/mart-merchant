import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../b.a/dashboard/view/dashboard.dart';

class BaAttendance extends StatelessWidget {
  BaAttendance({super.key});
  final TextEditingController locationController = TextEditingController();
  final AdminOperation companyController = Get.put(AdminOperation());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'B.A Attendance'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const heading(title: 'Select Employee'),
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
            ],
          ),
        ),
      ),
    );
  }
}
