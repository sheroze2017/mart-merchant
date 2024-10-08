import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewCompany extends StatefulWidget {
  NewCompany({super.key});

  @override
  State<NewCompany> createState() => _NewCompanyState();
}

class _NewCompanyState extends State<NewCompany> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _yearFoundedController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _locationController.dispose();
    _ownerController.dispose();
    _yearFoundedController.dispose();
    _phoneNoController.dispose();
    super.dispose();
  }

  final AdminOperation adminOperation = Get.put(AdminOperation());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: 'New Company'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Company',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                headingSmall(title: 'Company Name'),
                RoundedBorderTextField(
                    validator: Validator.validateCompany,
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    controller: _nameController,
                    hintText: 'Company Name',
                    icondata: Icons.business_sharp),
                SizedBox(
                  height: 1.h,
                ),
                headingSmall(title: 'Email'),
                RoundedBorderTextField(
                    validator: Validator.ValidEmail,
                    focusNode: _focusNode3,
                    nextFocusNode: _focusNode4,
                    controller: _emailController,
                    hintText: 'Email',
                    icondata: Icons.email_sharp),
                SizedBox(
                  height: 1.h,
                ),
                headingSmall(title: 'Password'),
                RoundedBorderTextField(
                    validator: Validator.validatePassword,
                    focusNode: _focusNode4,
                    nextFocusNode: _focusNode5,
                    controller: _passwordController,
                    hintText: 'Password',
                    icondata: Icons.password_sharp),
                SizedBox(
                  height: 1.h,
                ),
                // headingSmall(title: 'Location'),
                // RoundedBorderTextField(
                //     focusNode: _focusNode5,
                //     nextFocusNode: _focusNode6,
                //     controller: _locationController,
                //     hintText: 'City',
                //     validator: Validator.validateCity,
                //     icondata: Icons.location_city_sharp),
                // SizedBox(
                //   height: 1.h,
                // ),
                headingSmall(title: 'Phone No'),
                RoundedBorderTextField(
                    validator: Validator.validatePhoneNumber,
                    focusNode: _focusNode5,
                    nextFocusNode: _focusNode6,
                    controller: _phoneNoController,
                    hintText: 'Phone No',
                    icondata: Icons.phone_sharp),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => RoundedButton(
                          showLoader: adminOperation.newCompanyLoader.value,
                          text: 'Add Company',
                          onPressed: () {
                            adminOperation.newCompanyLoader.value == true
                                ? {}
                                : {
                                    FocusScope.of(context).unfocus(),
                                    if (!_formKey.currentState!.validate())
                                      {}
                                    else
                                      {
                                        adminOperation.addNewCompany(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            location: _locationController.text,
                                            image: '',
                                            phoneNo: _phoneNoController.text,
                                            name: _nameController.text,
                                            context: context)
                                      }
                                  };
                          },
                          backgroundColor: AppColors.primaryColorDark,
                          textColor: AppColors.whiteColor)),
                    )
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
