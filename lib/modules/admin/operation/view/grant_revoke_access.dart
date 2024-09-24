import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/dashboard/view/admin_dashboard.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/dailog/custom_text_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../b.a/dashboard/view/dashboard.dart';

class GrantRevokeAccess extends StatelessWidget {
  GrantRevokeAccess({super.key});
  final TextEditingController locationController = TextEditingController();
  final AdminOperation companyController = Get.put(AdminOperation());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Employee Access'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const heading(title: 'Search Employee'),
              Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: companyController.companies.length,
                  itemBuilder: (context, index) {
                    final data = companyController.employees[index];
                    return Card(
                      color: AppColors.primaryColor,
                      elevation: 2,
                      child: ListTile(
                        leading: Container(
                          height: 2.h,
                          width: 2.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: data.status ? Colors.green : Colors.red),
                        ),
                        minVerticalPadding: 5,
                        title: Text(data.name,
                            style: CustomTextStyles.darkTextStyle()),
                        subtitle: Text(
                            '*Age ${data.age} \n*Phone ${data.phoneNumber} \n*Address ${data.address}',
                            style:
                                CustomTextStyles.lightSmallTextStyle(size: 13)),
                        trailing: data.status
                            ? Text('Revoke Access',
                                style: CustomTextStyles.w600TextStyle(
                                    size: 10, color: Colors.red))
                            : Text('Grant Access',
                                style: CustomTextStyles.w600TextStyle(
                                    size: 10, color: Colors.green)),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialogMessage(
                              dialogText:
                                  'Are you sure you want to change status for ${data.name}?',
                              buttonText1: 'No',
                              buttonText2: 'Yes',
                              onButton1Pressed: () {
                                Get.back();
                              },
                              onButton2Pressed: () {
                                companyController.changeEmployeeStatus(data);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
