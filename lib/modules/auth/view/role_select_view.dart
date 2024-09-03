import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/modules/auth/view/login_view.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class UserRoleSelect extends StatefulWidget {
  UserRoleSelect({super.key});

  @override
  State<UserRoleSelect> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<UserRoleSelect> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final authController = Get.put(AuthController());
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  final _formKey = GlobalKey<FormState>();
  //final dio = Dio();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
    }

    @override
    void dispose() {
      super.dispose();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 30.h,
                    width: 50.w,
                    child: Image(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/logotext.png'),
                    ),
                  ),
                ),
                Text(
                  "Hi, Welcome Back! ",
                  style: CustomTextStyles.darkTextStyle(),
                ),
                Text(
                  "Please select your role to continue",
                  style: CustomTextStyles.lightTextStyle(),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                        child: RoundedButton(
                            text: "B A",
                            onPressed: () async {
                              Get.toNamed(Routes.LOGIN,
                                  arguments: {'role': 'B A'});
                            },
                            backgroundColor: Color(0xff1C2A3A),
                            textColor: Color(0xffFFFFFF))),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                        child: RoundedButton(
                            text: "Merchandiser",
                            onPressed: () async {
                              Get.toNamed(Routes.LOGIN,
                                  arguments: {'role': 'Merchandiser'});
                            },
                            backgroundColor: Color(0xff1C2A3A),
                            textColor: Color(0xffFFFFFF))),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                        child: RoundedButton(
                            text: "Company",
                            onPressed: () async {
                              Get.toNamed(Routes.LOGIN,
                                  arguments: {'role': 'Company'});
                            },
                            backgroundColor: Color(0xff1C2A3A),
                            textColor: Color(0xffFFFFFF))),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                        child: RoundedButton(
                            text: "Admin",
                            onPressed: () async {
                              Get.toNamed(Routes.LOGIN,
                                  arguments: {'role': 'Admin'});
                            },
                            backgroundColor: Color(0xff1C2A3A),
                            textColor: Color(0xffFFFFFF))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
