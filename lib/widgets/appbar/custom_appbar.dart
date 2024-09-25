import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/dashboard/bloc/dashboard_controller.dart';
import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  String accType;

  CustomAppBar({required this.title, this.accType = ''});

  final SyncController syncController = Get.find();
  final controller = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          title,
          style: CustomTextStyles.w600TextStyle(),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              // await Hive.deleteFromDisk();
              // print("Hive database cleared");
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Container(
                      height: 0.5.h,
                      width: 0.5.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.green),
                    ),
                    Obx(
                      () => Text(
                        " ${controller.userData.value!.role}",
                        style: CustomTextStyles.lightTextStyle(
                            size: 14, color: Colors.green),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
