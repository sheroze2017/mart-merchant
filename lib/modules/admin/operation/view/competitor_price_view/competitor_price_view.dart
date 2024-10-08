import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/validator.dart';
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

class CompetitorDataAdmin extends StatefulWidget {
  const CompetitorDataAdmin({super.key});

  @override
  State<CompetitorDataAdmin> createState() => _CompetitorDataAdminState();
}

class _CompetitorDataAdminState extends State<CompetitorDataAdmin> {
  final InsertSalesRecord salesController = Get.put(InsertSalesRecord());

  @override
  void initState() {
    super.initState();
    if (salesController.compititorNameList.isEmpty) {
      salesController.getAllCompititor();
    }
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
              const heading(title: 'Select company to find products'),
              Obx(() => Card(
                    elevation: 2,
                    child: CustomDropdown.search(
                      decoration: CustomDropdownDecoration(
                        prefixIcon: Icon(Icons.location_on_sharp),
                        expandedFillColor: AppColors.primaryColor,
                        closedFillColor: AppColors.primaryColor,
                      ),
                      hintText: 'Select Company',
                      items: salesController.compititorNameList
                          .map((company) => company.name)
                          .toList(),
                      onChanged: (selected) async {
                        if (selected != null) {
                          salesController.selectedCompanyIndividual.value =
                              await salesController.compititorNameList
                                  .firstWhere((c) => c.name == selected);
                          salesController.getAllCompetitorProductByCompanyMart(
                              int.tryParse(salesController
                                      .selectedCompanyIndividual.value!.userId
                                      .toString()) ??
                                  null);
                        }
                      },
                    ),
                  )),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [],
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
                                            leading: Text('PKR\n${data.price}',
                                                style: CustomTextStyles
                                                    .darkHeadingTextStyle(
                                                        color: AppColors
                                                            .primaryColorDark,
                                                        size: 14)),
                                            minVerticalPadding: 10,
                                            title: Text(
                                                '${data.productName!} -  ${data.companyName}',
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
                          })))
            ],
          ),
        ),
      ),
    );
  }
}
