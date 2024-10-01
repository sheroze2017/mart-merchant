import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/company/dashboard/view/company_home.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final controller = Get.put(CompanyOperationBloc());

  @override
  void initState() {
    super.initState();
    controller.getAllCategory();
    controller.getAllMart();
    controller.getAllProductByCompanyMart(null, null, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Product',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _addProduct();
                      },
                      child: DashboardCard(
                        asset: 'assets/images/product.png',
                        title: 'New Product',
                      ),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     _addBrand();
                  //   },
                  //   child: DashboardCard(
                  //     asset: 'assets/images/product.png',
                  //     title: 'New Brand',
                  //   ),
                  // )
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Card(
                elevation: 2,
                child: CustomDropdown(
                  hintText: 'Select Mart',
                  items: controller.marts.map((m) => m.martName).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      int exactIndex = controller.marts
                          .indexWhere((m) => m.martName == value);
                      if (exactIndex != -1) {
                        controller.getAllProductByCompanyMart(
                            null, controller.marts[exactIndex].martId, context);
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  'All Products',
                  style: CustomTextStyles.w600TextStyle(),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Obx(() {
                if (controller.productList.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: headingSmall(title: 'No Products to show'),
                    ),
                  );
                } else if (controller.fetchProductCompanyLoader.value) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.productList.length,
                  itemBuilder: (context, index) {
                    final product = controller.productList[index];
                    return Card(
                      color: AppColors.whiteColor,
                      elevation: 2,
                      child: ListTile(
                          minVerticalPadding: 10,
                          title: Text(product.productName.toString(),
                              style: CustomTextStyles.darkTextStyle()),
                          subtitle: Text(
                              '${product.variant} - PKR ${product.price}',
                              style: CustomTextStyles.lightSmallTextStyle())),
                    );
                  },
                );
              }),
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
    TextEditingController martId = TextEditingController();
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
                      'Add new product',
                      style: CustomTextStyles.darkHeadingTextStyle(size: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomDropdown(
                        hintText: 'Select Category',
                        items: controller.categories
                            .map((category) => category.name)
                            .toList(),
                        onChanged: (value) {
                          int exactIndex = controller.categories
                              .indexWhere((m) => m.name == value);
                          if (exactIndex != -1) {
                            categoryId.text = controller
                                .categories[exactIndex].categoryId
                                .toString();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomDropdown(
                        hintText: 'Select Mart',
                        items: controller.marts.map((m) => m.martName).toList(),
                        onChanged: (value) {
                          int exactIndex = controller.marts
                              .indexWhere((m) => m.martName == value);
                          if (exactIndex != -1) {
                            martId.text =
                                controller.marts[exactIndex].martId.toString();
                          }
                        },
                      ),
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
                        hintText: 'description',
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
                    RoundedBorderTextField(
                      controller: qty,
                      validator: Validator.ValidText,
                      textInputType: TextInputType.number,
                      hintText: 'Quantity',
                      icon: '',
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() => RoundedButton(
                                  showLoader: controller.addProductLoader.value,
                                  text: 'Add Product',
                                  onPressed: () {
                                    controller.addNewProduct(
                                        categoryId.text,
                                        nameController.text,
                                        desc.text,
                                        priceController.text,
                                        qty.text,
                                        varient.text,
                                        martId.text,
                                        context);
                                  },
                                  backgroundColor: Colors.black,
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
}
