import 'dart:io';

import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
import 'package:ba_merchandise/core/routes/routes.dart';
import 'package:ba_merchandise/modules/admin/operation/view/competitor_price_view/competitor_price_view.dart';
import 'package:ba_merchandise/modules/admin/operation/view/stock_restock/merchant_restock_detail.dart';
import 'package:ba_merchandise/modules/company/operation/view/stock_restock/merchant_restock_detail.dart';
import 'package:ba_merchandise/modules/company/operation/view/stock_restock/short_stock_view.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/widget/profile_section.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/view/employee/employee_view.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:ba_merchandise/widgets/dailog/custom_text_dailog.dart';
import 'package:ba_merchandise/widgets/drawer/app_drawer.dart';
import 'package:ba_merchandise/widgets/textfield/rounded_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../b.a/dashboard/view/dashboard.dart';
import '../../operation/view/add_product/product_view.dart';

class CompanyHome extends StatefulWidget {
  CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  final controller = Get.put(CompanyOperationBloc());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        showDialog(
          context: context,
          builder: (context) => CustomDialogMessage(
            dialogText: 'Are you sure you want to exit the app',
            buttonText1: 'No',
            buttonText2: 'Yes',
            onButton1Pressed: () {
              Get.back();
            },
            onButton2Pressed: () {
              exit(0);
            },
          ),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomAppBar(
          accType: 'Company',
          title: 'Dashboard',
        ),
        drawer: CustomDrawer(
          userRole: 'Company',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                ProfileSection(
                  showAddress: true,
                  isCompany: true,
                ),
                SizedBox(
                  height: 2.h,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                const heading(
                  title: 'Quick Actions',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(ProductScreen(),
                              transition: Transition.cupertino,
                              duration: Duration(milliseconds: 500));
                        },
                        child: DashboardCard(
                          asset: 'assets/images/product.png',
                          title: 'Products',
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.COMPANYBAATTENDANCE);
                        },
                        child: const DashboardCard(
                          asset: 'assets/images/employee.png',
                          title: 'Attendance',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          addCategory();
                        },
                        child: DashboardCard(
                          asset: 'assets/images/category.png',
                          title: 'Add Category',
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(ShortStockScreen(),
                              transition: Transition.rightToLeft);
                        },
                        child: DashboardCard(
                          asset: 'assets/images/product.png',
                          title: 'Short-Stock Detail',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.COMPANYSALES);
                        },
                        child: DashboardCard(
                          asset: 'assets/images/economy.png',
                          title: 'Sales',
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(EmployeeListScreen(),
                              transition: Transition.cupertino,
                              duration: Duration(milliseconds: 500));
                        },
                        child: DashboardCard(
                          asset: 'assets/images/employee.png',
                          title: 'Employees',
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(MerchantRestockDetailCompany(),
                              transition: Transition.cupertino,
                              duration: Duration(milliseconds: 500));
                        },
                        child: const DashboardCard(
                          asset: 'assets/images/product.png',
                          title: 'Merchant Restock Detail',
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(CompetitorDataAdmin(),
                              transition: Transition.rightToLeft);
                        },
                        child: DashboardCard(
                          asset: 'assets/images/comp.png',
                          title: 'Competitor price View',
                        ),
                      ),
                    ),
                  ],
                ),

                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addCategory() {
    TextEditingController nameController = TextEditingController();

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
                      'Add new Category',
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
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() => RoundedButton(
                                  showLoader:
                                      controller.addCategoryLoader.value,
                                  text: 'Add Category',
                                  onPressed: () {
                                    controller.addNewCategory(
                                        nameController.text, context);
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
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String asset;

  const DashboardCard({
    required this.title,
    required this.asset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: Card(
        color: AppColors.primaryColor,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image(
                width: 80,
                height: 40,
                color: AppColors.primaryColorDark,
                image: AssetImage(
                  asset,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                title,
                style: CustomTextStyles.lightTextStyle(size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
