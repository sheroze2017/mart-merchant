import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/competitor_activity_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/media_bloc.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/supervisor/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SupervisorNewReport extends StatefulWidget {
  SupervisorNewReport({super.key});

  @override
  State<SupervisorNewReport> createState() => _SupervisorNewReportState();
}

class _SupervisorNewReportState extends State<SupervisorNewReport> {
  final controlllerSupervisor = Get.put(SupervisorOperationBloc());

  final TextEditingController martId = TextEditingController();

  final _descriptionController = TextEditingController();

  final MediaBloc mediaBloc = Get.put(MediaBloc());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Supervisor Report'),
      body: GetBuilder<adminCompetitorActivity>(
        init: adminCompetitorActivity(), // Initialize the controller
        builder: (controller) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 12, right: 12),
                    child: Card(
                      elevation: 2,
                      child: CustomDropdown.search(
                        hintText: 'Select Mart',
                        items: controlllerSupervisor.marts
                            .map((m) => m.martName)
                            .toList(),
                        onChanged: (value) {
                          int exactIndex = controlllerSupervisor.marts
                              .indexWhere((m) => m.martName == value);
                          if (exactIndex != -1) {
                            martId.text = controlllerSupervisor
                                .marts[exactIndex].martId
                                .toString();
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'Record details for Mart',
                          style: CustomTextStyles.w600TextStyle(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const headingSmall(title: 'Description'),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          maxLines: 4,
                          validator: Validator.requiredfield,
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Enter description',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const headingSmall(title: 'Upload Photo'),
                        Obx(() {
                          final imageUrl = mediaBloc.imgUrl.value;
                          final isUploading = mediaBloc.imgUploaded.value;

                          return InkWell(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? pickedImage = await picker.pickImage(
                                  source: ImageSource.camera);
                              if (pickedImage != null) {
                                await mediaBloc.uploadPhoto(
                                    pickedImage.path, context);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              alignment: Alignment.center,
                              child: isUploading
                                  ? const SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.black),
                                      ),
                                    )
                                  : imageUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            imageUrl,
                                            width: double.infinity,
                                            height: 180,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_a_photo,
                                                size: 36, color: Colors.black),
                                            SizedBox(height: 8),
                                            Text(
                                              'Tap to upload photo',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => RoundedButton(
                                    showLoader: controlllerSupervisor
                                        .addReportLoader.value,
                                    text: 'Sumbit Report',
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (martId.text.isEmpty) {
                                        AnimatedSnackbar.showSnackbar(
                                          context: context,
                                          message: 'Please select a mart',
                                          icon: Icons.error,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 14.0,
                                        );
                                        return;
                                      }
                                      if (!_formKey.currentState!.validate() ||
                                          mediaBloc.imgUrl.value.isEmpty) {
                                        AnimatedSnackbar.showSnackbar(
                                          context: context,
                                          message:
                                              'Please enter required details',
                                          icon: Icons.error,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 14.0,
                                        );
                                      } else {
                                        controlllerSupervisor
                                            .createNewSubmission(
                                                martId.text,
                                                _descriptionController.text,
                                                mediaBloc.imgUrl.value,
                                                context);
                                      }
                                    },
                                    backgroundColor: AppColors.primaryColorDark,
                                    textColor: AppColors.whiteColor,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
