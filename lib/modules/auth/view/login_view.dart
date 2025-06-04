import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/auth/bloc/auth_bloc.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

  final authController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: Container(
                        height: 20.h,
                        width: 40.w,
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                    ),
                    Text(
                      "Hi, Welcome Back! ",
                      style: CustomTextStyles.darkTextStyle(),
                    ),
                    Text(
                      "Please login to continue to dashboard",
                      style: CustomTextStyles.lightTextStyle(),
                    ),
                    SizedBox(height: 3.h),
                    RoundedBorderTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (Validator.isValidEmail(value) == false) {
                            return 'Invaild Email';
                          } else {
                            return null;
                          }
                        },
                        focusNode: _focusNode1,
                        nextFocusNode: _focusNode2,
                        controller: _emailController,
                        hintText: 'Your Email',
                        icon: 'assets/images/sms.svg',
                        textInputType: TextInputType.emailAddress),
                    SizedBox(height: 3.h),
                    RoundedBorderTextField(
                      isPasswordField: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else {
                          return null;
                        }
                      },
                      focusNode: _focusNode2,
                      controller: _passwordController,
                      hintText: 'Your Password',
                      icon: 'assets/images/lock.svg',
                    ),
                    SizedBox(height: 1.h),
                    Align(
                      alignment: Alignment.topRight,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Forgot Password?',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Get.to(ForgotPassScreen(),
                                  //     transition: Transition.native);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Obx(() => RoundedButton(
                                showLoader: authController.isLoading.value,
                                text: "Sign In",
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  if (!_formKey.currentState!.validate()) {
                                  } else {
                                    authController.login(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      context: context,
                                    );
                                  }
                                },
                                backgroundColor: Color(0xff1C2A3A),
                                textColor: Color(0xffFFFFFF)))),
                      ],
                    ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
              Positioned(
                bottom: 30,
                right: 0,
                left: 0,
                child: Obx(() => authController.isLoading.value
                    ? Center(
                        child: Container(
                        height: 20.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Container(
                              height: 10.h,
                              width: 10.h,
                              child: Image(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/images/logo.png'),
                              ),
                            ),
                            Lottie.asset(
                              'assets/animation/loading3.json',
                              height: 10.h,
                            ),
                          ],
                        ),
                      ))
                    : Container()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
