import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/media_bloc.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/merchandiser/operation/view/upload_image.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewSupervisor extends StatefulWidget {
  NewSupervisor({super.key});

  @override
  State<NewSupervisor> createState() => _NewSupervisorState();
}

class _NewSupervisorState extends State<NewSupervisor> {
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
  final MediaBloc mediaBloc = Get.put(MediaBloc());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: 'New Supervisor'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Add New Supervisor',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 2.h,
              ),
              const headingSmall(title: 'Upload Photo'),
              Obx(() {
                final imageUrl = mediaBloc.imgUrl.value;
                final isUploading = mediaBloc.imgUploaded.value;
                return InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedImage != null) {
                      await mediaBloc.uploadPhoto(pickedImage.path, context);
                    }
                  },
                  child: Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      child: isUploading
                          ? const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : ClipOval(
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                            ),
                    ),
                  ),
                );
              }),
              SizedBox(
                height: 1.h,
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
                  text: 'Add Supervisor',
                  onPressed: () {
                    adminOperation.newBALoader.value == true
                        ? {}
                        : {
                            FocusScope.of(context).unfocus(),
                            if (!_formKey.currentState!.validate())
                              {}
                            else
                              {
                                adminOperation.addNewSupervisor(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    location: _locationController.text,
                                    image: mediaBloc.imgUrl.value,
                                    phoneNo: _phoneNoController.text,
                                    name: _nameController.text,
                                    context: context)
                              }
                          };
                  },
                  backgroundColor: AppColors.primaryColorDark,
                  textColor: AppColors.whiteColor),
            ))
          ],
        ),
      ),
    );
  }
}
