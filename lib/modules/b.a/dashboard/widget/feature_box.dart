import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  CardItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 10.w, color: Colors.blue.shade100),
                SizedBox(height: 1.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.lightTextStyle(size: 12, heigh: 1.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
