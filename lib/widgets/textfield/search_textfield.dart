import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/company/operation/view/add_product/product_view.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RoundedSearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  bool isEnable;

  RoundedSearchTextField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.onChanged,
      this.isEnable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.25.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: AppColors.whiteColor
          // color: Colors.grey[200],
          ),
      child: Row(
        children: [
          SizedBox(width: 4.w),
          const Icon(Icons.search),
          SizedBox(width: 1.w),
          Expanded(
            child: TextField(
              enabled: isEnable,
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  fillColor: Colors.transparent,
                  hintText: hintText,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle: CustomTextStyles.lightSmallTextStyle(
                      color: Color(0xff9CA3AF), size: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
