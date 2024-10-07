import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/dashboard/bloc/dashboard_controller.dart';
import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileSection extends StatelessWidget {
  bool showAddress;
  bool isCompany;
  ProfileSection({
    this.showAddress = true,
    this.isCompany = false,
  });
  @override
  final SyncController syncController = Get.find();
  final DashBoardController controller = Get.find();

  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColorDarklIGHT,
              AppColors.primaryColorDarklIGHT,
              AppColors.primaryColorDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
        ),
        child: Column(
          children: [
            showAddress
                ? Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 18,
                          color: Colors.blue.shade100,
                        ),
                        Obx(() => Text(
                              controller.userData.value!.phone.toString(),
                              style: CustomTextStyles.lightSmallTextStyle(
                                  size: 14, color: AppColors.whiteColor),
                            ))
                      ],
                    ),
                  )
                : Container(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isCompany
                    ? Container(
                        height: 8.h,
                        width: 8.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          errorWidget: (context, url, error) => CircleAvatar(
                            backgroundColor: AppColors.whiteColor,
                            radius: 30,
                            backgroundImage: NetworkImage(
                                "http://194.233.69.219/joy-Images//45cee667-c659-4d2c-a5ac-5245d043deff.png"),
                          ),
                          fit: BoxFit.cover,
                          imageUrl: controller.userData.value!.image.toString(),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: AppColors.whiteColor,
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          controller.userData.value!.name.toString(),
                          style: CustomTextStyles.darkHeadingTextStyle(
                              size: 22, color: AppColors.whiteColor),
                        ),
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      showAddress
                          ? Obx(() => Text(
                                controller.userData.value!.location.toString(),
                                style: CustomTextStyles.lightSmallTextStyle(
                                    size: 12, color: AppColors.whiteColor),
                              ))
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
