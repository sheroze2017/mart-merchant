import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/merchant_restock_detail_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/model/merchant_restock_model.dart';
import 'package:ba_merchandise/modules/company/operation/view/stock_restock/restock_detail_screen.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MerchantRestockDetailCompany extends StatefulWidget {
  MerchantRestockDetailCompany({super.key});

  @override
  State<MerchantRestockDetailCompany> createState() =>
      _MerchantRestockDetailCompanyState();
}

class _MerchantRestockDetailCompanyState
    extends State<MerchantRestockDetailCompany> {
  final controllerCompany = Get.find<CompanyOperationBloc>();

  final TextEditingController martId = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (controllerCompany.marts.isEmpty) {
      controllerCompany.getAllMart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Merchant Report'),
      body: GetBuilder<MerchantRestockBloc>(
        init: MerchantRestockBloc(),
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        child: Obx(
                          () => CustomDropdown.search(
                            hintText: 'Select Mart',
                            items: controllerCompany.marts
                                .map((m) => m.martName)
                                .toList(),
                            onChanged: (value) {
                              int exactIndex = controllerCompany.marts
                                  .indexWhere((m) => m.martName == value);
                              if (exactIndex != -1) {
                                martId.text = controllerCompany
                                    .marts[exactIndex].martId
                                    .toString();
                                controller
                                    .getAllMerchantRestockDetail(martId.text);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.getAllMerchantRestockDetail('');
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
              Obx(
                () => Expanded(
                  child: controller.merchantstockDetailLoader.value
                      ? Center(
                          child:
                              CircularProgressIndicator()) // Show loader when loading data
                      : controller.merchantRestockRecordList.isEmpty
                          ? Center(
                              child: Text(
                                  'No Data Found')) // Show message if no data is found
                          : ListView.builder(
                              itemCount:
                                  controller.merchantRestockRecordList.length,
                              itemBuilder: (context, index) {
                                MerchantIndividualRestockDetail data =
                                    controller.merchantRestockRecordList[index];
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4),
                                    child: Card(
                                      color: AppColors.primaryColor,
                                      elevation: 2,
                                      child: ExpansionTile(
                                        title: Text(
                                          data.merchantDetails!.name.toString(),
                                          style:
                                              CustomTextStyles.darkTextStyle(),
                                        ),
                                        subtitle: Text(
                                          'Reported: ${Utils.formatDate(data.createdAt.toString())} ${Utils.formatDay(data.createdAt.toString())}',
                                          style: CustomTextStyles
                                              .lightSmallTextStyle(),
                                        ),
                                        trailing: const Icon(
                                            Icons.expand_more_rounded),
                                        childrenPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 0.0),
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Email: ${data.merchantDetails!.email}',
                                              style: CustomTextStyles
                                                  .lightTextStyle(size: 13),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'phone: ${data.merchantDetails!.phone}',
                                              style: CustomTextStyles
                                                  .lightTextStyle(size: 13),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '',
                                              style: CustomTextStyles
                                                  .lightTextStyle(size: 13),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: RoundedButton(
                                                    text: 'Details',
                                                    onPressed: () {
                                                      Get.to(
                                                          RestockDetailScreen(
                                                            data: data,
                                                          ),
                                                          transition: Transition
                                                              .rightToLeft);
                                                    },
                                                    backgroundColor: AppColors
                                                        .primaryColorDark,
                                                    textColor:
                                                        AppColors.whiteColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
