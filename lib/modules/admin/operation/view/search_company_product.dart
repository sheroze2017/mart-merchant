import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import '../../../b.a/dashboard/view/dashboard.dart';

class SearchCompanyProduct extends StatefulWidget {
  SearchCompanyProduct({super.key});

  @override
  State<SearchCompanyProduct> createState() => _SearchCompanyProductState();
}

class _SearchCompanyProductState extends State<SearchCompanyProduct> {
  final TextEditingController locationController = TextEditingController();

  String today = DateFormat('yyyy-MMM-dd').format(DateTime.now());

  final AdminOperation companyController = Get.find<AdminOperation>();

  List<int> restockCount = [];
  @override
  void initState() {
    super.initState();
    if (companyController.companyNameList.isEmpty) {
      companyController.getAllCompany();
    }
  }

  final SingleSelectController<String> catController =
      SingleSelectController<String>(null);

  final SingleSelectController<String> martController =
      SingleSelectController<String>(null);

  final SingleSelectController<String> comController =
      SingleSelectController<String>(null);
  String catId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Company Products'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const heading(title: 'Select company to find products'),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: CustomDropdown(
                          controller: comController,
                          decoration: CustomDropdownDecoration(
                            prefixIcon: Icon(Icons.factory),
                            expandedFillColor: AppColors.primaryColor,
                            closedFillColor: AppColors.primaryColor,
                          ),
                          hintText: 'Select Company',
                          items: companyController.companyNameList
                              .map((company) => company.name)
                              .toList(),
                          onChanged: (selected) async {
                            if (selected != null) {
                              companyController
                                      .selectedCompanyIndividual.value =
                                  await companyController.companyNameList
                                      .firstWhere((c) => c.name == selected);
                              companyController.getAllCategory(companyController
                                  .selectedCompanyIndividual.value!.userId
                                  .toString());
                              companyController.getAllProductByCompanyMart(
                                  companyController
                                      .selectedCompanyIndividual.value!.userId!
                                      .toInt(),
                                  null,
                                  context);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        catId = '';
                        comController.clear();
                        catController.clear();
                        companyController.getAllProductByCompanyMart(
                            0, null, context);
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
                )),
            SizedBox(
              height: 1.h,
            ),
            comController.value == null
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 2,
                            child: Obx(() => CustomDropdown.search(
                                  decoration: CustomDropdownDecoration(
                                    prefixIcon: Icon(Icons.category),
                                    expandedFillColor: AppColors.primaryColor,
                                    closedFillColor: AppColors.primaryColor,
                                  ),
                                  controller: catController,
                                  hintText: 'Select Category',
                                  items: companyController.categories
                                      .map((category) => category.name)
                                      .toList(),
                                  onChanged: (selected) {
                                    if (selected != null) {
                                      final selectedCat = companyController
                                          .categories
                                          .firstWhere(
                                        (cat) => cat.name == selected,
                                      );
                                      catId = selectedCat.categoryId.toString();
                                      catController.value = selected;
                                      setState(() {});
                                    }
                                  },
                                )),
                          ),
                        ),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            catId = '';
                            catController.clear();
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.cancel),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

            headingSmall(
              title: 'Product List ${locationController.text}',
            ),
            Obx(() {
              if (companyController.fetchProductCompanyLoader.value) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (companyController.productList.isEmpty) {
                return const Center(
                  child: headingSmall(title: 'No Products to show'),
                );
              }
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: companyController.productList.length,
                  itemBuilder: (context, index) {
                    final product = companyController.productList[index];
                    if (catId.isEmpty ||
                        catId == product.categoryId.toString()) {
                      return Card(
                        color: AppColors.redLight,
                        elevation: 2,
                        child: ListTile(
                            minVerticalPadding: 10,
                            title: Text(
                                '${product.productName} - ${product.companyName} (${product.variant})',
                                style: CustomTextStyles.darkTextStyle()),
                            subtitle: Text(
                                'Description: ${product.productDesc}\nPrice: ${product.price}\nQuantity: ${product.qty}',
                                style: CustomTextStyles.lightSmallTextStyle(
                                    color: AppColors.primaryColorDark,
                                    size: 15))),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              );
            }),
            // Obx(
            //   () => ListView.builder(
            //       shrinkWrap: true,
            //       physics: NeverScrollableScrollPhysics(),
            //       itemCount: controller.records.length,
            //       itemBuilder: (context, index) {
            //         return Card(
            //             color: AppColors.whiteColor,
            //             elevation: 2,
            //             child: ListTile(
            //               minVerticalPadding: 10,
            //               title: Text(controller.records[index].name,
            //                   style: CustomTextStyles.darkTextStyle()),
            //               subtitle: Obx(() => Text(
            //                   '${controller.records[index].quantityGm} gm - PKR ${controller.records[index].pricePkr}',
            //                   style: CustomTextStyles.lightSmallTextStyle())),
            //             ));
            //       }),
            // ),
          ],
        ),
      ),
    );
  }
}
  
  //               () => ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: NeverScrollableScrollPhysics(),
  //                   itemCount: controller.records.length,
  //                   itemBuilder: (context, index) {
  //                     return Card(
  //                         color: AppColors.whiteColor,
  //                         elevation: 2,
  //                         child: ListTile(
  //                           minVerticalPadding: 10,
  //                           title: Text(controller.records[index].name,
  //                               style: CustomTextStyles.darkTextStyle()),
  //                           subtitle: Obx(() => Text(
  //                               '${controller.records[index].quantityGm} gm - PKR ${controller.records[index].pricePkr}',
  //                               style: CustomTextStyles.lightSmallTextStyle())),
  //                         ));
  //                   }),
  //             ),