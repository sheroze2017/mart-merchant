import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/dashboard/bloc/dashboard_controller.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/media_bloc.dart'
    show MediaBloc;
import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
                          Icons.phone,
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
                Stack(
                  children: [
                    Container(
                      height: 8.h,
                      width: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Obx(
                        () => CachedNetworkImage(
                          errorWidget: (context, url, error) => CircleAvatar(
                            backgroundColor: AppColors.whiteColor,
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/logo.png'),
                          ),
                          fit: BoxFit.cover,
                          imageUrl: controller.userData.value!.image.toString(),
                        ),
                      ),
                    ),

                    // Edit Icon Positioned
                    if (!isCompany)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            showImageSourceDialog(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue, // Change color as needed
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
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

void showImageSourceDialog(BuildContext context) {
  final MediaBloc mediaBloc = Get.put(MediaBloc());
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Obx(
            () => mediaBloc.proimgUploaded.value
                ? SizedBox()
                : Text('Select Image Source'),
          ),
          content: Obx(
            () => mediaBloc.proimgUploaded.value
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text('Camera'),
                        onTap: () async {
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          if (pickedFile != null) {
                            await mediaBloc.updateProfilePhoto(
                                pickedFile.path, context);
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Gallery'),
                        onTap: () async {
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            await mediaBloc.updateProfilePhoto(
                                pickedFile.path, context);
                          }
                        },
                      ),
                    ],
                  ),
          ));
    },
  );
}
