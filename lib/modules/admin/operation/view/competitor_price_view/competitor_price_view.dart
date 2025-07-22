import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/insert_sales_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/model/mart_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompetitorDataAdmin extends StatefulWidget {
  const CompetitorDataAdmin({super.key});

  @override
  State<CompetitorDataAdmin> createState() => _CompetitorDataAdminState();
}

class _CompetitorDataAdminState extends State<CompetitorDataAdmin> {
  final InsertSalesRecord salesController = Get.put(InsertSalesRecord());
  final controller = Get.put(CompanyOperationBloc());
  final SingleSelectController<String> catController =
      SingleSelectController<String>(null);
  final SingleSelectController<String> martController =
      SingleSelectController<String>(null);
  final SingleSelectController<String> companyController =
      SingleSelectController<String>(null);

  String catId = '';
  String martId = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Competitor Price View',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
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
                            final selectedCat =
                                controller.categories.firstWhere(
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
                          controller: martController,
                          hintText: 'Select Mart',
                          items: controller.marts
                              .map((mart) => mart.martName)
                              .toList(),
                          onChanged: (value) {
                            if (value != null && value.isNotEmpty) {
                              MartData selectedMart =
                                  controller.marts.firstWhere(
                                (mart) => mart.martName == value,
                              );
                              martId = selectedMart.martId.toString();
                              setState(() {});
                            }
                          }),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        martController.clear();
                        martId = '';
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
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                  child: Obx(() => (salesController
                          .fetchProductCompanyLoader.value)
                      ? Center(
                          child: CircularProgressIndicator(
                          color: AppColors.primaryColorDark,
                        ))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount:
                              salesController.competitorProductList.length,
                          itemBuilder: (context, index) {
                            final data =
                                salesController.competitorProductList[index];
                            if ((martId.isEmpty ||
                                    data.martId.toString() == martId) &&
                                (catId.isEmpty ||
                                    data.categoryId.toString() == catId)) {
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
                                              leading: Text(
                                                  'PKR\n${data.price}',
                                                  style: CustomTextStyles
                                                      .darkHeadingTextStyle(
                                                          color: AppColors
                                                              .primaryColorDark,
                                                          size: 14)),
                                              minVerticalPadding: 10,
                                              title: Text(
                                                  '${data.productName!} -  ${data.productDesc}',
                                                  style: CustomTextStyles
                                                      .darkTextStyle()),
                                              subtitle: Text(
                                                  'Varient: ${data.variant}\nSize: ${data.sizes}\nProduct Id: ${data.productId}',
                                                  style: CustomTextStyles
                                                      .lightSmallTextStyle(
                                                          size: 13,
                                                          color: AppColors
                                                              .primaryColorDark)),
                                            ))),
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
}
