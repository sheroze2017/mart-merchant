import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/merchandiser/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpdateProductQuantity extends StatelessWidget {
  UpdateProductQuantity({super.key});

  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final TextEditingController _martIdController = TextEditingController();

  MerchantOperationBloc controller = Get.put(MerchantOperationBloc());
  List<int> restockCount = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Update Quantity'),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Card(
                  child: Obx(() => CustomDropdown.search(
                        decoration: CustomDropdownDecoration(
                          errorStyle: CustomTextStyles.lightSmallTextStyle(
                              size: 11,
                              color: const Color.fromARGB(255, 173, 46, 37)),
                          prefixIcon: const Icon(Icons.factory),
                          expandedFillColor: AppColors.primaryColor,
                          closedFillColor: AppColors.primaryColor,
                        ),
                        validateOnChange: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '  Please select mart';
                          } else {
                            return null;
                          }
                        },
                        hintText: 'Select Mart',
                        items: controller.marts.map((m) => m.martName).toList(),
                        onChanged: (value) {
                          int exactIndex = controller.marts
                              .indexWhere((m) => m.martName == value);
                          if (exactIndex != -1) {
                            _martIdController.text =
                                controller.marts[exactIndex].martId.toString();
                            controller.getAllProductByCompanyMart(
                                controller.marts[exactIndex].martId, context);
                          }
                        },
                      )),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  const darkHeading(
                    title: 'Update Product Quantity by Mart',
                    color: Colors.black,
                  ),
                  headingSmall(title: today),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: controller.productList.length,
                      itemBuilder: (context, index) {
                        final data = controller.productList[index];
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
                                          style:
                                              CustomTextStyles.darkTextStyle()),
                                      subtitle: Text(
                                          'Stock Quantity: ${data.qty}',
                                          style: CustomTextStyles
                                              .lightSmallTextStyle(
                                                  size: 13,
                                                  color: AppColors
                                                      .primaryColorDark)),
                                      onTap: () {
                                        final TextEditingController
                                            _textFieldController =
                                            TextEditingController();
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: AppColors.whiteColor,
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                          ),
                                          builder: (context) {
                                            return Padding(
                                              padding: MediaQuery.of(context)
                                                  .viewInsets,
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Update Quantity',
                                                        style: CustomTextStyles
                                                            .darkTextStyle(),
                                                      ),
                                                      SizedBox(height: 16),
                                                      Text(
                                                        'Name: ${data.productName}',
                                                        style: CustomTextStyles
                                                            .lightSmallTextStyle(),
                                                      ),
                                                      SizedBox(height: 16),
                                                      RoundedBorderTextField(
                                                        textInputType:
                                                            TextInputType
                                                                .number,
                                                        validator:
                                                            Validator.ValidText,
                                                        controller:
                                                            _textFieldController,
                                                        hintText: 'Quantity',
                                                        icondata:
                                                            Icons.price_change,
                                                      ),
                                                      SizedBox(height: 20),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Obx(() =>
                                                                RoundedButton(
                                                                  showLoader:
                                                                      controller
                                                                          .updateQuantityLoader
                                                                          .value,
                                                                  text:
                                                                      'Update Quantity',
                                                                  onPressed:
                                                                      () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    if (_textFieldController
                                                                        .text
                                                                        .isEmpty) {
                                                                      AnimatedSnackbar
                                                                          .showSnackbar(
                                                                        context:
                                                                            context,
                                                                        message:
                                                                            'Quantity Field Is Required',
                                                                        icon: Icons
                                                                            .info,
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                        textColor:
                                                                            Colors.white,
                                                                        fontSize:
                                                                            14.0,
                                                                      );
                                                                    } else {
                                                                      controller
                                                                          .updateQuantiy(
                                                                        context,
                                                                        _textFieldController
                                                                            .text,
                                                                        data.productId
                                                                            .toString(),
                                                                      );
                                                                    }
                                                                  },
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .primaryColorDark,
                                                                  textColor:
                                                                      AppColors
                                                                          .whiteColor,
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
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
