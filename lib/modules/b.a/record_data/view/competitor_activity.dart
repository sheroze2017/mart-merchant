import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/media_bloc.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/insert_sales_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CompetitorActivity extends StatefulWidget {
  const CompetitorActivity({super.key});

  @override
  State<CompetitorActivity> createState() => _CompetitorActivityState();
}

class _CompetitorActivityState extends State<CompetitorActivity> {
  final InsertSalesRecord salesController = Get.put(InsertSalesRecord());
  final _descriptionController = TextEditingController();
  final MediaBloc mediaBloc = Get.put(MediaBloc());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (salesController.compititorNameList.isEmpty) {
      salesController.getAllCompititor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Competitor Activity',
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Record details for competitor activity',
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
                        final XFile? pickedImage =
                            await picker.pickImage(source: ImageSource.camera);
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              )
                            : imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl,
                                      width: double.infinity,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              showLoader:
                                  salesController.addActivityLoader.value,
                              text: 'Upload Details',
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (!_formKey.currentState!.validate() ||
                                    mediaBloc.imgUrl.value.isEmpty) {
                                  AnimatedSnackbar.showSnackbar(
                                    context: context,
                                    message: 'Please enter required details',
                                    icon: Icons.error,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 14.0,
                                  );
                                } else {
                                  salesController.addCompetitorActivity(
                                      context,
                                      mediaBloc.imgUrl.value,
                                      _descriptionController.text);
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
            ),
          ),
        ),
      ),
    );
  }
}
