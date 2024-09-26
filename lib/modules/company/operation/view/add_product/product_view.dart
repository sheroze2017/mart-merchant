import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/modules/company/dashboard/view/company_home.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String? selectedBrand;

  List<String> _list = ['Colgate', 'ColasNext'];

  Map<String, List<Map<String, dynamic>>> productData = {
    'Colanext': [
      {'id': 1, 'name': 'Colanext Cola', 'price': 100.99},
      {'id': 2, 'name': 'Colanext FizzUp', 'price': 122.49},
      {'id': 3, 'name': 'Colanext Dew', 'price': 150.99},
      {'id': 4, 'name': 'Colanext orange', 'price': 149.99},
    ],
    'Colgate': [
      {'id': 5, 'name': 'Colgate Total', 'price': 300.99},
      {'id': 6, 'name': 'Colgate MaxFresh', 'price': 400.49},
      {'id': 7, 'name': 'Colgate Sensitive', 'price': 320.99},
      {'id': 8, 'name': 'Colgate Clear', 'price': 120.99},
    ],
  };
  final controller = Get.put(CompanyOperationBloc());

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
              //   CustomDropdown(
              //     hintText: 'Select Brand',
              //     items: productData.keys.toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         selectedBrand = value;
              //       });
              //     },
              //   ),
              //   SizedBox(
              //     height: 1.h,
              //   ),
              //   if (selectedBrand != null)
              //     ...productData[selectedBrand]!.map((product) {
              //       return Card(
              //         color: AppColors.primaryColor,
              //         elevation: 2,
              //         child: ListTile(
              //           title: Text(
              //             product['name'],
              //             style: CustomTextStyles.lightSmallTextStyle(
              //                 size: 16, color: Colors.blue),
              //           ),
              //           subtitle: Text(
              //             'Price: PKR ${product['price']}',
              //             style: CustomTextStyles.lightSmallTextStyle(),
              //           ),
              //           trailing: IconButton(
              //               icon: const Icon(
              //                 Icons.edit_note,
              //                 color: Colors.blue,
              //               ),
              //               onPressed: () {
              //                 _editProduct(product);
              //               }),
              //         ),
              //       );
              //     }).toList(),
              //
            ],
          ),
        ),
      ),
    );
  }

  void _editProduct(Map<String, dynamic> product) {
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
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
                      'Edit Product',
                      style: CustomTextStyles.darkHeadingTextStyle(size: 20),
                    ),
                    SizedBox(height: 2.h),
                    RoundedBorderTextField(
                      controller: nameController,
                      hintText: 'Name',
                      icon: '',
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: RoundedBorderTextField(
                        controller: priceController,
                        hintText: 'Price',
                        textInputType: TextInputType.number,
                        icon: '',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Center(
                      child: RoundedButtonSmall(
                          text: 'Save',
                          onPressed: () {
                            setState(() {
                              product['name'] = nameController.text;
                              product['price'] =
                                  double.parse(priceController.text);
                            });
                            Fluttertoast.showToast(msg: 'Product Saved');
                            Get.back();
                          },
                          backgroundColor: Colors.black,
                          textColor: AppColors.whiteColor),
                    )
                  ],
                ),
              ),
            ));
      },
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
                        hintText: 'Varient eg gm,mg,lt,ml and kg etc',
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

  void _addBrand() {
    TextEditingController brandController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
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
                      'Add new brand',
                      style: CustomTextStyles.darkHeadingTextStyle(size: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: RoundedBorderTextField(
                        controller: brandController,
                        hintText: 'Name',
                        icon: '',
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: RoundedButtonSmall(
                            text: 'Add Brand',
                            onPressed: () {
                              if (brandController.text.isNotEmpty) {
                                final newBrand = brandController.text;

                                setState(() {
                                  if (!productData.containsKey(newBrand)) {
                                    productData[newBrand] = [];
                                  }
                                });
                                setState(() {});

                                Fluttertoast.showToast(msg: 'Brand Added');
                                Navigator.pop(
                                    context); // Close the bottom sheet
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please enter a brand name');
                              }
                            },
                            backgroundColor: Colors.black,
                            textColor: AppColors.whiteColor),
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
