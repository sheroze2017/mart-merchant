import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/core/local/hive_db/hive.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/modules/admin/dashboard/bloc/dashboard_controller.dart';
import 'package:ba_merchandise/modules/attendence/bloc/attendance_bloc.dart';
import 'package:ba_merchandise/services/local_storage/auth_storage.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/dailog/custom_text_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomDrawer extends StatelessWidget {
  final String userRole;

  CustomDrawer({required this.userRole});
  final controller = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //backgroundColor: AppColors.redLight,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.redLight,
              AppColors.redLight,
              AppColors.redLight,
              AppColors.primaryColorDark,
            ],
          ),
        ),
        child: Column(
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: CircleAvatar(
                    radius: 80,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ],
            ),
            Text(
              'Name',
              style: CustomTextStyles.w600TextStyle(
                  size: 20, color: AppColors.primaryColorDark),
            ),
            Obx(() => Text(
                  controller.userData.value!.name.toString(),
                  style: CustomTextStyles.lightTextStyle(
                      size: 16, color: AppColors.blackColor),
                )),
            SizedBox(
              height: 4.h,
            ),
            Text(
              'User Role',
              style: CustomTextStyles.w600TextStyle(
                  size: 20, color: AppColors.primaryColorDark),
            ),
            Obx(() => Text(
                  controller.userData.value!.role.toString(),
                  style: CustomTextStyles.lightTextStyle(
                      size: 16, color: AppColors.blackColor),
                )),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: RoundedButton(
                        text: 'Logout',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialogMessage(
                              dialogText: 'Are you sure you want to Logout?',
                              buttonText1: 'No',
                              buttonText2: 'Yes',
                              onButton1Pressed: () {
                                Get.back();
                              },
                              onButton2Pressed: () async {
                                final AuthStorage authStorage =
                                    Get.find<AuthStorage>();
                                authStorage.clear();
                                await logoutAndCleanAttendance();
                                Get.offAllNamed(Routes.LOGIN);
                              },
                            ),
                          );
                        },
                        backgroundColor: AppColors.primaryColorDark,
                        textColor: AppColors.whiteColor),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> logoutAndCleanAttendance() async {
  try {
    final attendanceController = Get.find<AttendanceController>();
    attendanceController.martAttendanceLoader.value = false;

    // 3. Clear all reactive variables
    attendanceController.currentLocation.value = null;
    attendanceController.attenToday.value = Attendance(); // Reset to empty

    // 4. Get the already opened box instance
    final attendanceBox = Hive.box('attendanceBox');

    // 5. Clear the box data

    // 6. Close all Rx variables (these are typically closed in onClose())
    attendanceController.martAttendanceLoader.close();
    attendanceController.currentLocation.close();
    attendanceController.attenToday.close();

    // 7. Delete the controller instance
    Get.delete<AttendanceController>(force: true);

    print('Successfully cleaned attendance data on logout');
  } catch (e) {
    print('Error cleaning attendance data on logout: $e');
  } finally {
    // 8. Proceed with your normal logout process
    // Add your auth logout logic here
    // await AuthService().logout();

    // Navigate to login screen
  }
}
