import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/dailog/custom_text_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../b.a/dashboard/view/dashboard.dart';

class GrantRevokeAccess extends StatefulWidget {
  GrantRevokeAccess({super.key});

  @override
  State<GrantRevokeAccess> createState() => _GrantRevokeAccessState();
}

class _GrantRevokeAccessState extends State<GrantRevokeAccess> {
  final TextEditingController locationController = TextEditingController();

  final AdminOperation controller = Get.find<AdminOperation>();
  @override
  void initState() {
    super.initState();
    controller.getAllBa();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Employee Access'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Inactive'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First Tab: Active Employees
            buildEmployeeList(status: 'active'),

            // Second Tab: Inactive Employees
            buildEmployeeList(status: 'inactive'),
          ],
        ),
      ),
    );
  }

  // Widget to build the employee list based on the given status
  Widget buildEmployeeList({required String status}) {
    return Obx(() {
      // Filter employees based on their status (active/inactive)
      final filteredList = controller.baNameList
          .where((employee) => employee.status == status)
          .toList();

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const heading(title: 'Search Employee'),
              filteredList.isEmpty
                  ? Center(
                      child: Text(
                        'No $status employees found.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final data = filteredList[index];
                        return Card(
                          color: AppColors.primaryColor,
                          elevation: 2,
                          child: ListTile(
                            leading: Container(
                              height: 2.h,
                              width: 2.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: data.status == 'active'
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            minVerticalPadding: 5,
                            title: Text(data.name.toString(),
                                style: CustomTextStyles.darkTextStyle()),
                            subtitle: Text(
                                '*Email ${data.email} \n*Role ${data.role} \n*UserId ${data.userId}',
                                style: CustomTextStyles.lightSmallTextStyle(
                                    size: 13)),
                            trailing: data.status == 'active'
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
                                    controller.changeBAStatus(
                                        data.userId.toString(),
                                        data.status == 'active'
                                            ? 'inactive'
                                            : 'active',
                                        context);
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      );
    });
  }
}
