import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/company/operation/model/merchant_restock_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RestockDetailScreen extends StatelessWidget {
  final MerchantIndividualRestockDetail data;
  RestockDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Restock Detail'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  color: AppColors.primaryColor,
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      data.merchantDetails!.name.toString(),
                      style: CustomTextStyles.darkTextStyle(),
                    ),
                    subtitle: Text(
                      'Reported: ${Utils.formatDate(data.createdAt.toString())} ${Utils.formatDay(data.createdAt.toString())}\nMart: ${data.martName}',
                      style: CustomTextStyles.lightSmallTextStyle(size: 14),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  color: AppColors.primaryColor,
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      'Description',
                      style: CustomTextStyles.darkTextStyle(),
                    ),
                    subtitle: Text(
                      data.remarks.toString(),
                      style: CustomTextStyles.lightSmallTextStyle(size: 14),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Container(
                    width: 100.w,
                    height: 40.h,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: data.image.toString(),
                      errorWidget: (context, url, error) {
                        return Column(
                          children: [
                            const Image(
                                image:
                                    AssetImage('assets/images/logotext.png')),
                            Center(
                              child: Text('Error Loading Image',
                                  style:
                                      CustomTextStyles.darkHeadingTextStyle()),
                            ),
                          ],
                        );
                      },
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
