import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../bloc/operation_bloc.dart';

class AddNewEmployee extends StatefulWidget {
  const AddNewEmployee({super.key});

  @override
  State<AddNewEmployee> createState() => _AddNewEmployeeState();
}

class _AddNewEmployeeState extends State<AddNewEmployee> {
  String? selectedValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _profileImgController = TextEditingController();
  final TextEditingController _userRoleController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  TextEditingController controller = TextEditingController();
  final OperationBloc operationBloc = Get.find();

  //final authController = Get.put(AuthController());

  //final mediaController = Get.find<MediaPostController>();

  final _formKey = GlobalKey<FormState>();
  String? _selectedImage;

  Future<void> _pickImage() async {
    final List<String?> paths = await pickSingleFile();
    if (paths.isNotEmpty) {
      final String path = await paths.first!;
      //String profileImg =
      //  await mediaController.uploadProfilePhoto(path, context);
      //     setState(() {
      //   _selectedImage = profileImg;
      // });
    }
  }

  Future<List<String?>> pickSingleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false, type: FileType.image, compressionQuality: 0);
    if (result != null) {
      return result.paths.toList();
    } else {
      return [];
    }
  }

  //ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: ''),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Employee',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  // Obx(
                  //   () => mediaController.profileUpload.value
                  //       ? Container(
                  //           height: 43.w,
                  //           width: 43.w,
                  //           child: Lottie.asset(
                  //               'Assets/animations/image_upload.json'),
                  //         )
                  //       : Stack(
                  //           children: <Widget>[
                  //             InkWell(
                  //                 onTap: () {
                  //                   _pickImage();
                  //                 },
                  //                 child: _selectedImage == null ||
                  //                         !_selectedImage!.contains('http')
                  //                     ? Center(
                  //                         child: SvgPicture.asset(
                  //                             'Assets/images/profile-circle.svg'),
                  //                       )
                  //                     : Center(
                  //                         child: Container(
                  //                           width: 43.w,
                  //                           height: 43.w,
                  //                           decoration: BoxDecoration(
                  //                             shape: BoxShape
                  //                                 .circle, // Add this line
                  //                             border: Border.all(
                  //                                 color: Colors.grey,
                  //                                 width: 1), // Optional
                  //                           ),
                  //                           child: Center(
                  //                             child: Container(
                  //                               child: ClipOval(
                  //                                 // Add this widget
                  //                                 child: Image.network(
                  //                                   fit: BoxFit.cover,
                  //                                   _selectedImage!,
                  //                                   width: 41.w,
                  //                                   height: 41.w,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       )),
                  //             Positioned(
                  //               bottom: 20,
                  //               right: 100,
                  //               child: Container(
                  //                   decoration: BoxDecoration(
                  //                       color: ThemeUtil.isDarkMode(context)
                  //                           ? AppColors.lightBlueColor3e3
                  //                           : Color(0xff1C2A3A),
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(10.0),
                  //                         topRight: Radius.circular(10.0),
                  //                         bottomRight: Radius.circular(10.0),
                  //                       )),
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(5.0),
                  //                     child: SvgPicture.asset(
                  //                       'Assets/icons/pen.svg',
                  //                       color: Theme.of(context)
                  //                           .scaffoldBackgroundColor,
                  //                     ),
                  //                   )),
                  //             )
                  //           ],
                  //         ),
                  // ),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  headingSmall(title: 'Name'),
                  RoundedBorderTextField(
                    validator: Validator.validateName,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    controller: _nameController,
                    icondata: Icons.person,
                    hintText: 'Name',
                    icon: '',
                  ),
                  SizedBox(
                    height: 1.h,
                  ),

                  headingSmall(title: 'Email'),
                  RoundedBorderTextField(
                    icondata: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (Validator.isValidEmail(value) == false) {
                        return 'Invaild Email';
                      } else {
                        return null;
                      }
                    },
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    controller: _emailController,
                    hintText: 'Email',
                    icon: '',
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  headingSmall(title: 'Phone No'),

                  RoundedBorderTextField(
                      icondata: Icons.phone,
                      validator: Validator.validatePhoneNumber,
                      textInputType: TextInputType.number,
                      focusNode: _focusNode3,
                      nextFocusNode: _focusNode4,
                      controller: _phoneController,
                      hintText: 'Phone No',
                      icon: ''),
                  SizedBox(
                    height: 1.h,
                  ),
                  headingSmall(title: 'Age'),
                  RoundedBorderTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        } else {
                          return null;
                        }
                      },
                      textInputType: TextInputType.number,
                      focusNode: _focusNode4,
                      icondata: Icons.calendar_month,
                      nextFocusNode: _focusNode5,
                      controller: _dobController,
                      hintText: 'Age',
                      icon: ''),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomDropdown(
                    hintText: 'Select Gender',
                    items: ['Male', 'Female'],
                    onChanged: (value) {
                      setState(() {
                        _genderController.text = value.toString();
                      });
                    },
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  CustomDropdown(
                    hintText: 'Select Location',
                    items: operationBloc.locations
                        .map((location) => location.placeName)
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _locationController.text = value.toString();
                      });
                    },
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  CustomDropdown(
                    hintText: 'Select Role',
                    items: operationBloc.employeeRole,
                    onChanged: (value) {
                      setState(() {
                        _userRoleController.text = value.toString();
                      });
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                            //   Obx(
                            // () =>
                            RoundedButton(
                                // showLoader: authController.registerLoader.value,
                                text:
                                    // widget.isEdit ? 'Edit' :
                                    'Save',
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  if (!_formKey.currentState!.validate()) {
                                  } else {
                                    operationBloc.addNewEmployee(
                                        _nameController.text,
                                        _emailController.text,
                                        _phoneController.text,
                                        _dobController.text,
                                        _genderController.text,
                                        'brand',
                                        _locationController.text);
                                  }
                                  // FocusScope.of(context).unfocus();
                                  // if (!_formKey.currentState!.validate()) {
                                  // } else {
                                  //   bool success = widget.isEdit
                                  //       ? await authController.editUser(
                                  //           _nameController.text,
                                  //           _locationController.text,
                                  //           _phoneController.text,
                                  //           "",
                                  //           'EMAIL',
                                  //           "USER",
                                  //           _profileController.email.value
                                  //               .toString(),
                                  //           _profileController.password.value
                                  //               .toString(),
                                  //           _dobController.text,
                                  //           _genderController.text,
                                  //           context,
                                  //           _selectedImage.toString())
                                  //       : await authController.userRegister(
                                  //           _nameController.text,
                                  //           _locationController.text,
                                  //           _phoneController.text,
                                  //           "",
                                  //           widget.isSocial ? 'SOCIAL' : 'EMAIL',
                                  //           "USER",
                                  //           widget.email,
                                  //           widget.password,
                                  //           _dobController.text,
                                  //           _genderController.text,
                                  //           context,
                                  //           _selectedImage.toString());
                                  //   if (success == true) {
                                  //     widget.isEdit
                                  //         ? {_profileController.updateUserDetal()}
                                  //         : showDialog(
                                  //             context: context,
                                  //             builder: (BuildContext context) {
                                  //               return Obx(() => CustomDialog(
                                  //                     isUser: true,
                                  //                     showButton: !authController
                                  //                         .registerLoader.value,
                                  //                     title: 'Congratulations!',
                                  //                     content:
                                  //                         'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                                  //                   ));
                                  //             },
                                  //           );
                                  //   }
                                  // }
                                },
                                backgroundColor: Color(0xff1C2A3A),
                                textColor: Color(0xffFFFFFF)),
                        //)
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
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
