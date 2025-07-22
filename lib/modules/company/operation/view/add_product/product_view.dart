import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/admin/operation/model/company_mart_product_model.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/company/dashboard/view/company_home.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/dailog/custom_text_dailog.dart';
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
    controller.getAllProductByCompanyMart(null, context);
  }

  final SingleSelectController<String> catController =
      SingleSelectController<String>(null);
  String catId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Product',
      ),
      body: Padding(
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
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      decoration: CustomDropdownDecoration(
                        prefixIcon: Icon(Icons.location_on_sharp),
                        expandedFillColor: AppColors.primaryColor,
                        closedFillColor: AppColors.primaryColor,
                      ),
                      controller: catController,
                      hintText: 'Select Category',
                      items: controller.categories
                          .map((category) => category.name)
                          .toList(),
                      onChanged: (value) {
                        if (value != null && value.isNotEmpty) {
                          final selectedCat = controller.categories.firstWhere(
                            (cat) => cat.name == value,
                          );
                          catId = selectedCat.categoryId.toString();
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  InkWell(
                    onTap: () {
                      catController.clear();
                      catId = '';
                      setState(() {});
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.cancel),
                        )),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Obx(() {
              if (controller.fetchProductCompanyLoader.value) {
                return Center(child: CircularProgressIndicator());
              } else if (controller.productList.isEmpty) {
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
              return Expanded(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.productList.length,
                  itemBuilder: (context, index) {
                    final product = controller.productList[index];
                    if (catId.isEmpty ||
                        catId == product.categoryId.toString()) {
                      return Card(
                        color: AppColors.primaryColor,
                        elevation: 2,
                        child: ListTile(
                            minVerticalPadding: 10,
                            title: Text(
                                '${product.productName} (${product.variant})',
                                style: CustomTextStyles.darkHeadingTextStyle(
                                    size: 20)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Description: ${product.productDesc}\nPrice: ${product.price}\nsize: ${product.sizes}\nQuantity Available: ${product.qty}',
                                    style: CustomTextStyles.lightSmallTextStyle(
                                        color: AppColors.primaryColorDark,
                                        size: 16)),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  CustomDialogMessage(
                                                    dialogText:
                                                        'Are you sure you want to delete this product ${product.productName} ${product.variant}',
                                                    buttonText1: 'No',
                                                    buttonText2: 'Yes',
                                                    onButton1Pressed: () {
                                                      Get.back();
                                                    },
                                                    onButton2Pressed: () {
                                                      controller.deleteProduct(
                                                          product.productId,
                                                          context);
                                                    },
                                                  ));
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              'Delete',
                                              style: CustomTextStyles
                                                  .lightSmallTextStyle(
                                                      size: 14,
                                                      color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            _updateProduct(product);
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Icon(
                                                Icons.edit,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                'Edit',
                                                style: CustomTextStyles
                                                    .lightSmallTextStyle(
                                                        size: 14,
                                                        color: Colors.black),
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              );
            }),
          ],
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomDropdown(
                    hintText: 'Select Category',
                    initialItem: controller.categories
                        .firstWhere(
                          (cat) => cat.categoryId == product.categoryId,
                        )
                        .name,
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
                Text('Description', style: CustomTextStyles.lightTextStyle()),
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
                              showLoader: controller.updateProductLoader.value,
                              text: 'Update Product',
                              onPressed: () {
                                controller.updateProduct(
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
