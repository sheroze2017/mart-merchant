import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProfileSection extends StatelessWidget {
  bool showAddress;
  ProfileSection({
    this.showAddress = true,
  });
  @override
  final SyncController syncController = Get.find();

  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
              Colors.blue.shade50,
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
                              syncController.uLocation.first.locationName
                                  .toString(),
                              style: CustomTextStyles.lightSmallTextStyle(
                                  size: 18, color: Colors.grey),
                            ))
                      ],
                    ),
                  )
                : Container(),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          syncController.username.value,
                          style:
                              CustomTextStyles.darkHeadingTextStyle(size: 22),
                        ),
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Obx(() => Text(
                            syncController
                                .uLocation.first.brands!.first.brandName
                                .toString(),
                            style: CustomTextStyles.lightSmallTextStyle(
                                size: 16, color: Colors.grey),
                          ))
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
