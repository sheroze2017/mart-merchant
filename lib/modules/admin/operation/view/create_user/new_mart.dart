import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/company/operation/view/location/new_location.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../widgets/textfield/rounded_textfield.dart';

class NewMartScreen extends StatelessWidget {
  NewMartScreen({super.key});

  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final _formKey = GlobalKey<FormState>();

  final AdminOperation adminOperation = Get.put(AdminOperation());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: 'New Mart'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Mart',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                headingSmall(title: 'Mart Name'),
                RoundedBorderTextField(
                    validator: Validator.ValidText,
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    controller: _locationNameController,
                    hintText: 'mart name',
                    icondata: Icons.business_sharp),
                SizedBox(
                  height: 1.h,
                ),
                headingSmall(title: 'Address'),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocationPickerScreen()),
                    );

                    if (result != null) {
                      final latLng = result['latLng'] as LatLng;
                      final placeName = result['placeName'] as String;
                      _latitudeController.text = latLng.latitude.toString();
                      _longitudeController.text = latLng.longitude.toString();
                      _addressController.text = placeName.toString();
                    }
                  },
                  child: RoundedBorderTextField(
                      isenable: false,
                      validator: Validator.ValidText,
                      focusNode: _focusNode3,
                      nextFocusNode: _focusNode4,
                      controller: _addressController,
                      hintText: 'Select Address',
                      icondata: Icons.home),
                ),
                SizedBox(
                  height: 1.h,
                ),
                headingSmall(title: 'Latitude'),
                RoundedBorderTextField(
                    validator: Validator.ValidText,
                    focusNode: _focusNode4,
                    nextFocusNode: _focusNode5,
                    controller: _latitudeController,
                    hintText: 'latitude',
                    isenable: false,
                    icondata: Icons.map),
                SizedBox(
                  height: 1.h,
                ),
                headingSmall(title: 'Longitude'),
                RoundedBorderTextField(
                    isenable: false,
                    focusNode: _focusNode5,
                    nextFocusNode: _focusNode6,
                    controller: _longitudeController,
                    hintText: 'longitude',
                    validator: Validator.ValidText,
                    icondata: Icons.map),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Obx(() => RoundedButton(
                            showLoader: adminOperation.newMartLoader.value,
                            text: 'Add Mart',
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (!_formKey.currentState!.validate()) {
                              } else {
                                if (!adminOperation.newMartLoader.value) {
                                  adminOperation.addNewMart(
                                      locationName:
                                          _locationNameController.text,
                                      address: _addressController.text,
                                      latitude: _latitudeController.text,
                                      longitude: _longitudeController.text,
                                      context: context);
                                }
                              }
                            },
                            backgroundColor: Colors.black,
                            textColor: AppColors.whiteColor))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
