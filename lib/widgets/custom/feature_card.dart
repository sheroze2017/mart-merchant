import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String subtitle;
  bool isDone;

  FeatureCard({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.subtitle,
    this.isDone = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          shadowColor: AppColors.primaryColor,
          elevation: 4,
          color: AppColors.redLight,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.primaryColor)),
          child: ListTile(
            leading: Icon(
              icon,
              color: AppColors.primaryColorDark,
            ),
            title: Text(
              title,
              style: CustomTextStyles.darkTextStyle(),
            ),
            trailing: isDone
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.check,
                        size: 15,
                        color: Colors.green,
                      ),
                    ))
                : Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColorDark,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: AppColors.primaryColorDark,
                      ),
                    )),
            subtitle: Text(
              subtitle,
              style: CustomTextStyles.lightTextStyle(),
            ),
          )),
    );
  }
}
