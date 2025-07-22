import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/admin/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompetitorAdminScreen extends StatefulWidget {
  const CompetitorAdminScreen({super.key});

  @override
  State<CompetitorAdminScreen> createState() => _CompetitorAdminScreenState();
}

class _CompetitorAdminScreenState extends State<CompetitorAdminScreen> {
  final AdminOperation controllerCompany = Get.find<AdminOperation>();
  final controller = Get.put(CompanyOperationBloc());
  final SingleSelectController<String> catController =
      SingleSelectController<String>(null);
  final SingleSelectController<String> martController =
      SingleSelectController<String>(null);
  final SingleSelectController<String> companyController =
      SingleSelectController<String>(null);

  String comId = '';
  String martId = '';
  String catId = '';

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
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: CustomDropdown.search(
                          controller: companyController,
                          decoration: CustomDropdownDecoration(
                            prefixIcon: Icon(Icons.category),
                            expandedFillColor: AppColors.primaryColor,
                            closedFillColor: AppColors.primaryColor,
                          ),
                          hintText: 'Select Company',
                          items: controllerCompany.companyNameList
                              .map((company) => company.name)
                              .toList(),
                          onChanged: (value) {
                            if (value != null && value.isNotEmpty) {
                              final selectedCom =
                                  controllerCompany.companyNameList.firstWhere(
                                (com) => com.name == value,
                              );
                              catId = '';
                              catController.clear();
                              controllerCompany.categories.clear();
                              comId = selectedCom.userId.toString();
                              controllerCompany
                                  .getAllCompetitorProductByCompanyMart(comId);
                              controllerCompany.getAllCategory(comId);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        companyController.clear();
                        catId = '';
                        catController.clear();
                        comId = '';
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
                padding: const EdgeInsets.only(top: 4.0, left: 12, right: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: CustomDropdown.search(
                          controller: martController,
                          decoration: CustomDropdownDecoration(
                            prefixIcon: Icon(Icons.location_on_sharp),
                            expandedFillColor: AppColors.primaryColor,
                            closedFillColor: AppColors.primaryColor,
                          ),
                          hintText: 'Select Mart',
                          items: controllerCompany.marts
                              .map((m) => m.martName)
                              .toList(),
                          onChanged: (value) {
                            if (value != null && value.isNotEmpty) {
                              final selectedMart =
                                  controllerCompany.marts.firstWhere(
                                (mart) => mart.martName == value,
                              );
                              martId = selectedMart.martId.toString();
                              setState(() {});
                            }
                          },
                        ),
                      ),
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
              companyController.value == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4),
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
                                    items: controllerCompany.categories
                                        .map((category) => category.name)
                                        .toList(),
                                    onChanged: (selected) {
                                      if (selected != null) {
                                        final selectedCat = controllerCompany
                                            .categories
                                            .firstWhere(
                                          (cat) => cat.name == selected,
                                        );
                                        catId =
                                            selectedCat.categoryId.toString();
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
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                  child: Obx(() => (controllerCompany
                          .fetchProductCompanyLoader.value)
                      ? Center(
                          child: CircularProgressIndicator(
                          color: AppColors.primaryColorDark,
                        ))
                      : comId == ''
                          ? const Center(
                              child: Text('Please select a company'),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: controllerCompany
                                  .competitorProductList.length,
                              itemBuilder: (context, index) {
                                final data = controllerCompany
                                    .competitorProductList[index];
                                if ((martId.isEmpty ||
                                        martId == data.martId.toString()) &&
                                    (catId.isEmpty ||
                                        catId == data.categoryId.toString())) {
                                  return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 50),
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
                                  return SizedBox();
                                }
                              })))
            ],
          ),
        ),
      ),
    );
  }
}
