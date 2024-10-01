import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewEmployee extends StatefulWidget {
  NewEmployee({super.key});

  @override
  State<NewEmployee> createState() => _NewEmployeeState();
}

class _NewEmployeeState extends State<NewEmployee> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _martIdController = TextEditingController();
  final TextEditingController _companyIdController = TextEditingController();
  final TextEditingController _employeeTypeController = TextEditingController();

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
    _phoneNoController.dispose();
    _martIdController.dispose();
    _companyIdController.dispose();
    super.dispose();
  }

  final AdminOperation adminOperation = Get.put(AdminOperation());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: 'New Employee'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Add New Employee',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 0.5.h,
              ),
              const headingSmall(title: 'Name'),
              RoundedBorderTextField(
                  validator: Validator.validateName,
                  focusNode: _focusNode1,
                  nextFocusNode: _focusNode2,
                  controller: _nameController,
                  hintText: 'Name',
                  icondata: Icons.person_2_sharp),
              SizedBox(
                height: 1.h,
              ),
              const headingSmall(title: 'Email'),
              RoundedBorderTextField(
                  validator: Validator.ValidEmail,
                  focusNode: _focusNode2,
                  nextFocusNode: _focusNode3,
                  controller: _emailController,
                  hintText: 'Email',
                  icondata: Icons.email_sharp),
              SizedBox(
                height: 1.h,
              ),
              const headingSmall(title: 'Password'),
              RoundedBorderTextField(
                  validator: Validator.validatePassword,
                  focusNode: _focusNode3,
                  nextFocusNode: _focusNode4,
                  controller: _passwordController,
                  hintText: 'Password',
                  icondata: Icons.password_sharp),
              SizedBox(
                height: 1.h,
              ),
              // const headingSmall(title: 'Location'),
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

              const headingSmall(title: 'Phone No'),
              RoundedBorderTextField(
                  validator: Validator.validatePhoneNumber,
                  focusNode: _focusNode6,
                  nextFocusNode: _focusNode7,
                  controller: _phoneNoController,
                  hintText: 'Phone No',
                  icondata: Icons.phone_sharp),
              SizedBox(
                height: 1.h,
              ),
              const headingSmall(title: 'Employee Type'),
              CustomDropdown(
                validator: Validator.ValidText,
                decoration: CustomDropdownDecoration(
                  errorStyle: CustomTextStyles.lightSmallTextStyle(
                      size: 11, color: const Color.fromARGB(255, 173, 46, 37)),
                  prefixIcon: const Icon(Icons.shop),
                  expandedFillColor: AppColors.primaryColor,
                  closedFillColor: AppColors.primaryColor,
                ),
                hintText: 'Select Employee Type',
                items: ['B.A', 'MERCHANT'],
                onChanged: (selected) {
                  if (selected != null) {
                    _employeeTypeController.text = selected;
                    if (selected == 'B.A') {
                      adminOperation.isBASelected.value = true;
                    } else {
                      adminOperation.isBASelected.value = false;
                    }
                  }
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              Obx(() {
                return adminOperation.isBASelected.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const headingSmall(
                              title: 'Allocate Mart'), // HeadingSmall corrected
                          CustomDropdown(
                            validator: Validator.ValidText,
                            decoration: CustomDropdownDecoration(
                              errorStyle: CustomTextStyles.lightSmallTextStyle(
                                  size: 11,
                                  color:
                                      const Color.fromARGB(255, 173, 46, 37)),
                              prefixIcon: const Icon(Icons.shop),
                              expandedFillColor: AppColors.primaryColor,
                              closedFillColor: AppColors.primaryColor,
                            ),
                            hintText: 'Select Mart',
                            items: ['1', '3', '4', '5'],
                            onChanged: (selected) {
                              if (selected != null) {
                                _martIdController.text = selected;
                              }
                            },
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          const headingSmall(
                              title:
                                  'Allocate Company'), // HeadingSmall corrected
                          CustomDropdown(
                            validator: Validator.ValidText,
                            decoration: CustomDropdownDecoration(
                              errorStyle: CustomTextStyles.lightSmallTextStyle(
                                  size: 11,
                                  color:
                                      const Color.fromARGB(255, 173, 46, 37)),
                              prefixIcon: const Icon(Icons.factory),
                              expandedFillColor: AppColors.primaryColor,
                              closedFillColor: AppColors.primaryColor,
                            ),
                            hintText: 'Select Company',
                            items: ['1', '3', '4', '5'],
                            onChanged: (selected) {
                              if (selected != null) {
                                _companyIdController.text = selected;
                              }
                            },
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                        ],
                      )
                    : const SizedBox(
                        height:
                            1); // Ensure a widget is returned in else clause
              }),
            ]),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
                child: Obx(
              () => RoundedButton(
                  showLoader: adminOperation.newBALoader.value,
                  text: 'Add Employee',
                  onPressed: () {
                    adminOperation.newBALoader.value == true
                        ? {}
                        : {
                            FocusScope.of(context).unfocus(),
                            if (!_formKey.currentState!.validate())
                              {}
                            else
                              {
                                if (adminOperation.isBASelected.value)
                                  {
                                    adminOperation.addNewBA(
                                        martId: _martIdController.text,
                                        companyId: _companyIdController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        location: _locationController.text,
                                        image: '',
                                        phoneNo: _phoneNoController.text,
                                        name: _nameController.text,
                                        context: context)
                                  }
                                else
                                  {
                                    adminOperation.addNewMerchant(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        location: _locationController.text,
                                        image: '',
                                        phoneNo: _phoneNoController.text,
                                        name: _nameController.text,
                                        context: context)
                                  }
                              }
                          };
                  },
                  backgroundColor: Colors.black,
                  textColor: AppColors.whiteColor),
            ))
          ],
        ),
      ),
    );
  }
}
