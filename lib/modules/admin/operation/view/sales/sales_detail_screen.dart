import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/model/sales_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SalesDetailScreen extends StatelessWidget {
  final IndividualSalesData saleData;
  const SalesDetailScreen({super.key, required this.saleData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Sales Details',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'All Details Product Wise',
                    style: CustomTextStyles.w600TextStyle(),
                  )
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: saleData.productsSold!.length,
                      itemBuilder: (context, index) {
                        final data = saleData.productsSold![index];
                        return Card(
                            color: AppColors.primaryColor,
                            elevation: 2,
                            child: ListTile(
                              leading: Text('Qty ${data.qty}',
                                  style: CustomTextStyles.darkHeadingTextStyle(
                                      color: AppColors.primaryColorDark,
                                      size: 14)),
                              minVerticalPadding: 10,
                              title: Text('Name: ${data.productName!}',
                                  style: CustomTextStyles.darkTextStyle()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Varient ${data.variant}',
                                      style: CustomTextStyles.lightTextStyle(
                                          size: 13,
                                          color: AppColors.primaryColorDark)),
                                  Text(
                                      'Total Price ${double.parse(data.qty ?? '0.0') * double.parse(data.unitPrice ?? '0.0')}',
                                      style: CustomTextStyles.lightTextStyle(
                                          size: 13,
                                          color: AppColors.primaryColorDark)),
                                ],
                              ),
                              trailing: Text('Pkr ${data.unitPrice}',
                                  style: CustomTextStyles.darkHeadingTextStyle(
                                      color: AppColors.primaryColorDark,
                                      size: 14)),
                            ));
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
