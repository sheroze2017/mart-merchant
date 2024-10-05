import 'dart:io';

import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/modules/merchandiser/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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

  final MerchantOperationBloc controller = Get.put(MerchantOperationBloc());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Upload Details"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            children: <Widget>[
              Obx(() => controller.imgUrl.value.isNotEmpty &&
                      !controller.imgUploaded.value
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Image.network(
                        controller.imgUrl.value,
                      ),
                    )
                  : controller.imgUploaded.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Please select an Image')),
              const SizedBox(height: 20),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  maxLines: null,
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: RoundedButton(
                  showLoader: false,
                  text: 'Restock Details',
                  onPressed: () async {},
                  backgroundColor: AppColors.primaryColorDark,
                  textColor: AppColors.whiteColor),
            )
          ],
        ),
      ),
    );
  }
}
