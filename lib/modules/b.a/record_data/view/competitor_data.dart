import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/admin/operation/model/company_mart_product_model.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/insert_sales_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/custom/error_toast.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompetitorData extends StatefulWidget {
  const CompetitorData({super.key});

  @override
  State<CompetitorData> createState() => _CompetitorDataState();
}

class _CompetitorDataState extends State<CompetitorData> {
  final InsertSalesRecord salesController = Get.put(InsertSalesRecord());
  String martId = '';
  @override
  void initState() {
    super.initState();
    if (salesController.compititorNameList.isEmpty) {
      salesController.getAllCompititor();
    }
    getmartId();
  }

  void getmartId() async {
    martId = (await Utils.getMartId())!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Competitor Price Set',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: 1.h,
              ),
              RoundedButton(
                  text: 'Add Competitor Product',
                  onPressed: () {
                    _addProduct();
                  },
                  backgroundColor: AppColors.primaryColorDark,
                  textColor: Colors.white),
              SizedBox(
                height: 1.h,
              ),
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
                  child: Obx(() => (salesController
                          .fetchProductCompanyLoader.value)
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount:
                              salesController.competitorProductList.length,
                          itemBuilder: (context, index) {
                            final data =
                                salesController.competitorProductList[index];
                            if (data.martId.toString() == martId) {
                              return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 50),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Card(
                                        color: AppColors.primaryColor,
                                        elevation: 2,
                                        child: ListTile(
                                            leading: Text('PKR\n${data.price}',
                                                style: CustomTextStyles
                                                    .darkHeadingTextStyle(
                                                        color: AppColors
                                                            .primaryColorDark,
                                                        size: 14)),
                                            minVerticalPadding: 10,
                                            trailing: const Icon(Icons.edit),
                                            title: Text(
                                                '${data.productName!} -  ${data.productDesc}',
                                                style: CustomTextStyles
                                                    .darkTextStyle()),
                                            subtitle: Text(
                                                'Varient: ${data.variant}\nSize: ${data.sizes}\nProduct ID: ${data.productId}',
                                                style: CustomTextStyles
                                                    .lightSmallTextStyle(
                                                        size: 13,
                                                        color: AppColors
                                                            .primaryColorDark)),
                                            onTap: () {
                                              _updateProduct(data);
                                            }),
                                      ),
                                    ),
                                  ));
                            } else {
                              return const SizedBox();
                            }
                          })))
            ],
          ),
        ),
      ),
    );
  }

  void _addProduct() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController desc = TextEditingController();
    TextEditingController varient = TextEditingController();
    TextEditingController qty = TextEditingController();
    TextEditingController sizes = TextEditingController();
    TextEditingController categoryId = TextEditingController();

    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Wrap(
                  children: [
                    Text(
                      'Add Competitor product',
                      style: CustomTextStyles.darkHeadingTextStyle(size: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: RoundedBorderTextField(
                        controller: nameController,
                        validator: Validator.ValidText,
                        hintText: 'Name',
                        icon: '',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: RoundedBorderTextField(
                        controller: priceController,
                        textInputType: TextInputType.number,
                        hintText: 'Price',
                        validator: Validator.ValidText,
                        icon: '',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: RoundedBorderTextField(
                        controller: desc,
                        validator: Validator.ValidText,
                        hintText: 'Company Name',
                        icon: '',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: RoundedBorderTextField(
                        controller: varient,
                        validator: Validator.ValidText,
                        hintText: 'Varient eg 50gm,50mg,50lt,60ml and 1kg etc',
                        icon: '',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: RoundedBorderTextField(
                        controller: qty,
                        validator: Validator.ValidText,
                        textInputType: TextInputType.number,
                        hintText: 'Quantity',
                        icon: '',
                      ),
                    ),
                    RoundedBorderTextField(
                      controller: sizes,
                      validator: Validator.ValidText,
                      textInputType: TextInputType.emailAddress,
                      hintText: 'Size',
                      icon: '',
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() => RoundedButton(
                                  showLoader: salesController
                                      .addCompetitorProductLoader.value,
                                  text: 'Add Product',
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (desc.text.isEmpty ||
                                        nameController.text.isEmpty ||
                                        priceController.text.isEmpty ||
                                        varient.text.isEmpty ||
                                        sizes.text.isEmpty) {
                                      AnimatedSnackbar.showSnackbar(
                                        context: context,
                                        message: 'Please enter field',
                                        icon: Icons.error,
                                        backgroundColor: const Color.fromARGB(
                                            255, 241, 235, 235),
                                        textColor: Colors.black,
                                        fontSize: 14.0,
                                      );
                                      return;
                                    }
                                    salesController.addNewCompetitorProduct(
                                        categoryId.text,
                                        nameController.text,
                                        desc.text,
                                        priceController.text,
                                        qty.text,
                                        varient.text,
                                        sizes.text,
                                        context);
                                  },
                                  backgroundColor: AppColors.primaryColorDark,
                                  textColor: AppColors.whiteColor)),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ));
      },
    );
  }

  void _updateProduct(ProductCMData product) {
    TextEditingController nameController =
        TextEditingController(text: product.productName);
    TextEditingController priceController =
        TextEditingController(text: product.price.toString());
    TextEditingController desc =
        TextEditingController(text: product.productDesc);
    TextEditingController varient =
        TextEditingController(text: product.variant);
    TextEditingController qty =
        TextEditingController(text: product.qty.toString());
    TextEditingController sizes = TextEditingController(text: product.sizes);
    TextEditingController martId =
        TextEditingController(text: product.martId.toString());
    TextEditingController categoryId =
        TextEditingController(text: product.categoryId.toString());

    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                Text(
                  'Update Product',
                  style: CustomTextStyles.darkHeadingTextStyle(size: 20),
                ),
                Text('Name', style: CustomTextStyles.lightTextStyle()),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: RoundedBorderTextField(
                    controller: nameController,
                    validator: Validator.ValidText,
                    hintText: 'Name',
                    icon: '',
                  ),
                ),
                Text('Price', style: CustomTextStyles.lightTextStyle()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: RoundedBorderTextField(
                    controller: priceController,
                    textInputType: TextInputType.number,
                    hintText: 'Price',
                    validator: Validator.ValidText,
                    icon: '',
                  ),
                ),
                Text('Company Name', style: CustomTextStyles.lightTextStyle()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: RoundedBorderTextField(
                    controller: desc,
                    validator: Validator.ValidText,
                    hintText: 'Description',
                    icon: '',
                  ),
                ),
                Text('Varient', style: CustomTextStyles.lightTextStyle()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: RoundedBorderTextField(
                    controller: varient,
                    validator: Validator.ValidText,
                    hintText: 'Varient (e.g., 50gm, 1kg)',
                    icon: '',
                  ),
                ),
                Text('Quantity', style: CustomTextStyles.lightTextStyle()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: RoundedBorderTextField(
                    controller: qty,
                    validator: Validator.ValidText,
                    textInputType: TextInputType.number,
                    hintText: 'Quantity',
                    icon: '',
                  ),
                ),
                Text('Size', style: CustomTextStyles.lightTextStyle()),
                RoundedBorderTextField(
                  controller: sizes,
                  validator: Validator.ValidText,
                  textInputType: TextInputType.text,
                  hintText: 'Size',
                  icon: '',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() => RoundedButton(
                              showLoader: salesController
                                  .addCompetitorProductLoader.value,
                              text: 'Update Product',
                              onPressed: () {
                                salesController.updateProduct(
                                  categoryId.text,
                                  nameController.text,
                                  desc.text,
                                  priceController.text,
                                  qty.text,
                                  varient.text,
                                  sizes.text,
                                  product.productId.toString(),
                                  context,
                                );
                              },
                              backgroundColor: AppColors.primaryColorDark,
                              textColor: AppColors.whiteColor,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
