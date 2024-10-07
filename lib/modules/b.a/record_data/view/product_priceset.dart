import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/insert_sales_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductPriceSet extends StatefulWidget {
  const ProductPriceSet({super.key});

  @override
  State<ProductPriceSet> createState() => _ProductPriceSetState();
}

class _ProductPriceSetState extends State<ProductPriceSet> {
  final InsertSalesRecord salesController = Get.put(InsertSalesRecord());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Update Product Price',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Select product to update price',
                    style: CustomTextStyles.w600TextStyle(),
                  )
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                  child: Obx(
                      () => (salesController.fetchProductCompanyLoader.value)
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: salesController.productList.length,
                              itemBuilder: (context, index) {
                                final data = salesController.productList[index];
                                return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: Card(
                                          color: AppColors.primaryColor,
                                          elevation: 2,
                                          child: ListTile(
                                              leading: Text('PKR ${data.price}',
                                                  style: CustomTextStyles
                                                      .darkHeadingTextStyle(
                                                          color: AppColors
                                                              .primaryColorDark,
                                                          size: 14)),
                                              minVerticalPadding: 10,
                                              title: Text(
                                                  '${data.productName!} - ${data.companyName} (${data.variant})',
                                                  style: CustomTextStyles
                                                      .darkTextStyle()),
                                              subtitle: Text(
                                                  'Price: ${data.price}\nStock: ${data.qty}',
                                                  style: CustomTextStyles
                                                      .lightSmallTextStyle(
                                                          size: 13)),
                                              onTap: () {
                                                final TextEditingController
                                                    _textFieldController =
                                                    TextEditingController();
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      AppColors.whiteColor,
                                                  context: context,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  builder: (context) {
                                                    return Padding(
                                                      padding:
                                                          MediaQuery.of(context)
                                                              .viewInsets,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Update Price',
                                                                style: CustomTextStyles
                                                                    .darkTextStyle(),
                                                              ),
                                                              Text(
                                                                'Name: ${data.productName}',
                                                                style: CustomTextStyles
                                                                    .lightSmallTextStyle(),
                                                              ),
                                                              SizedBox(
                                                                  height: 16),
                                                              RoundedBorderTextField(
                                                                textInputType:
                                                                    TextInputType
                                                                        .number,
                                                                validator:
                                                                    Validator
                                                                        .ValidText,
                                                                controller:
                                                                    _textFieldController,
                                                                hintText:
                                                                    'New Price',
                                                                icondata: Icons
                                                                    .price_change,
                                                              ),
                                                              SizedBox(
                                                                  height: 20),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Obx(
                                                                        () =>
                                                                            RoundedButton(
                                                                              showLoader: salesController.updatePriceLoader.value,
                                                                              text: 'Update Price',
                                                                              onPressed: () {
                                                                                FocusScope.of(context).unfocus();
                                                                                if (_textFieldController.text.isEmpty) {
                                                                                  AnimatedSnackbar.showSnackbar(
                                                                                    context: context,
                                                                                    message: 'Price Field Is Required',
                                                                                    icon: Icons.info,
                                                                                    backgroundColor: Colors.red,
                                                                                    textColor: Colors.white,
                                                                                    fontSize: 14.0,
                                                                                  );
                                                                                } else {
                                                                                  salesController.updateProductPrice(context, _textFieldController.text, data.productId.toString(), null);
                                                                                }
                                                                              },
                                                                              backgroundColor: AppColors.primaryColorDark,
                                                                              textColor: AppColors.whiteColor,
                                                                            )),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }),
                                        ),
                                      ),
                                    ));
                              })))
            ],
          ),
        ),
      ),
    );
  }
}
