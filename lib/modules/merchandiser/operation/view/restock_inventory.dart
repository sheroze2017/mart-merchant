import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/merchandiser/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import '../../../b.a/dashboard/view/dashboard.dart';

class RestockInventory extends StatefulWidget {
  RestockInventory({super.key});

  @override
  State<RestockInventory> createState() => _RestockInventoryState();
}

class _RestockInventoryState extends State<RestockInventory> {
  final TextEditingController locationController = TextEditingController();

  final TextEditingController _martIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _image;

  final _picker = ImagePicker();
  final _descriptionController = TextEditingController();

  Future<void> _openCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        controller.uploadPhoto(pickedFile.path, context);
      } else {
        _image = null;
      }
    });
  }

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        controller.uploadPhoto(pickedFile.path, context);
      } else {
        _image = null;
      }
    });
  }

  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  MerchantOperationBloc controller = Get.put(MerchantOperationBloc());

  List<int> restockCount = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Restock Inventory'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                    child: Obx(() => CustomDropdown.search(
                          decoration: CustomDropdownDecoration(
                            errorStyle: CustomTextStyles.lightSmallTextStyle(
                                size: 11,
                                color: const Color.fromARGB(255, 173, 46, 37)),
                            prefixIcon: const Icon(Icons.factory),
                            expandedFillColor: AppColors.primaryColor,
                            closedFillColor: AppColors.primaryColor,
                          ),
                          validateOnChange: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '  Please select mart';
                            } else {
                              return null;
                            }
                          },
                          hintText: 'Select Mart',
                          items:
                              controller.marts.map((m) => m.martName).toList(),
                          onChanged: (value) {
                            int exactIndex = controller.marts
                                .indexWhere((m) => m.martName == value);
                            if (exactIndex != -1) {
                              _martIdController.text = controller
                                  .marts[exactIndex].martId
                                  .toString();
                              controller.getAllProductByCompanyMart(
                                  controller.marts[exactIndex].martId, context);
                            }
                          },
                        )),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    const darkHeading(
                      title: 'Record Inventory update for dated:',
                      color: Colors.black,
                    ),
                    headingSmall(title: today),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Obx(() => controller.imgUrl.value.isNotEmpty &&
                        !controller.imgUploaded.value
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.network(
                          controller.imgUrl.value,
                        ),
                      )
                    : controller.imgUploaded.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Please select an Image')),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                            text: 'Open Camera',
                            onPressed: () {
                              _openCamera();
                            },
                            backgroundColor: AppColors.primaryColorDark,
                            textColor: AppColors.whiteColor),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: RoundedButton(
                            text: 'Select Image',
                            onPressed: () {
                              _selectImage();
                            },
                            backgroundColor: AppColors.primaryColorDark,
                            textColor: AppColors.whiteColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topLeft,
                  child: heading(
                    title: 'Description',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextFormField(
                    maxLines: null,
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
                ),

                // Obx(
                //   () => ListView.builder(
                //       shrinkWrap: true,
                //       physics: NeverScrollableScrollPhysics(),
                //       itemCount: controller.productList.length,
                //       itemBuilder: (context, index) {
                //         return Card(
                //           color: AppColors.primaryColor,
                //           elevation: 2,
                //           child: ListTile(
                //               minVerticalPadding: 10,
                //               title: Text(
                //                   controller.productList[index].productName
                //                       .toString(),
                //                   style: CustomTextStyles.darkTextStyle()),
                //               subtitle: Obx(() => Text(
                //                   '${controller.productList[index].variant} - PKR ${controller.productList[index].price}',
                //                   style: CustomTextStyles.lightSmallTextStyle())),
                //               trailing: SizedBox(
                //                 width: 100,
                //                 child: Row(
                //                   mainAxisSize: MainAxisSize.min,
                //                   children: [
                //                     InputQty(
                //                       initVal: 0,
                //                       minVal: 0,
                //                       steps: 1,
                //                       onQtyChanged: (val) {
                //                         restockCount[index] = int.parse(val);
                //                       },
                //                     ),
                //                   ],
                //                 ),
                //               )),
                //         );
                //       }),
                // ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: RoundedButton(
                //             text: 'Save',
                //             onPressed: () {
                //               Get.to(CameraScreen());
                //             },
                //             backgroundColor: AppColors.primaryColorDark,
                //             textColor: Colors.white),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
                child: Obx(() => RoundedButton(
                      showLoader: controller.restockLoader.value,
                      textColor: Colors.white,
                      text: 'Restock',
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                        } else {
                          controller.restockLoader.value
                              ? null
                              : controller.uploadRestockRecord(
                                  _descriptionController.text,
                                  _martIdController.text,
                                  context);
                        }
                      },
                      backgroundColor: AppColors.primaryColorDark,
                    )))
          ],
        ),
      ),
    );
  }
}
