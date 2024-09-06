import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RoundedBorderTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  bool showLoader;
  bool isLocation;
  IconData? icondata;
  final VoidCallback? onTap;
  final String icon;
  final bool maxlines;
  bool isenable;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  TextInputType textInputType;
  final FormFieldValidator<String>? validator;
  final bool isPasswordField; // Add this to identify password fields

  RoundedBorderTextField({
    this.isLocation = false,
    this.showLoader = false,
    required this.controller,
    required this.hintText,
    this.icon = '',
    this.icondata,
    this.onTap,
    this.focusNode,
    this.nextFocusNode,
    this.maxlines = false,
    this.isenable = true,
    this.textInputType = TextInputType.text,
    this.validator,
    this.isPasswordField = false, // Add this to identify password fields
  });

  @override
  _RoundedBorderTextFieldState createState() => _RoundedBorderTextFieldState();
}

class _RoundedBorderTextFieldState extends State<RoundedBorderTextField> {
  bool _obscureText = true; // State to toggle password visibility

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      keyboardType: widget.textInputType,
      focusNode: widget.focusNode,
      enabled: widget.isenable,
      obscureText: widget.isPasswordField
          ? _obscureText
          : false, // Handle password visibility
      style: CustomTextStyles.lightTextStyle(
          color: Color.fromARGB(255, 72, 73, 73)),
      cursorColor: const Color(0xffD1D5DB),
      maxLines: widget.maxlines == false ? 1 : null,
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Color(0xff2F343C),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Color(0xff2F343C),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Color(0xff2F343C),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.red,
            width: 0.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.red,
            width: 0.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        suffixIcon: widget.isPasswordField
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                  color: Color.fromARGB(255, 144, 145, 146),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // Toggle password visibility
                  });
                },
              )
            : widget.showLoader
                ? Container(
                    height: 2.h,
                    width: 2.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.green,
                    ),
                  )
                : widget.isLocation
                    ? InkWell(
                        onTap: widget.onTap,
                        child: Container(
                          height: 2.h,
                          width: 2.h,
                          child: Icon(widget.icondata),
                        ),
                      )
                    : null,
        hintText: widget.hintText,
        hintStyle: CustomTextStyles.lightTextStyle(color: Color(0xff9CA3AF)),
        prefixIcon: widget.icondata.isNull
            ? null
            : Padding(
                padding: EdgeInsets.all(12.0), child: Icon(widget.icondata)),
      ),
      onFieldSubmitted: (value) {
        widget.focusNode?.unfocus();
        FocusScope.of(context).requestFocus(widget.nextFocusNode);
      },
    );
  }
}
