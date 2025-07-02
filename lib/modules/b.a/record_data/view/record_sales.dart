import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/insert_sales_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // To format date and time

import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/style/color.dart';

class RecordSales extends StatefulWidget {
  const RecordSales({super.key});

  @override
  State<RecordSales> createState() => _RecordSalesState();
}

class _RecordSalesState extends State<RecordSales> {
  bool _isDetailVisible = false;
  bool statusCheck = false;
  final InsertSalesRecord salesController = Get.put(InsertSalesRecord());
  @override
  void initState() {
    super.initState();
  }

  final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Record Sales',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  darkHeading(
                    title: 'Record Sales for Dated:',
                    color: Colors.black,
                  ),
                  headingSmall(title: Utils.formatDate(todayDate)),
                ],
              ),
              Expanded(
                child: Obx(
                  () => (salesController.fetchProductCompanyLoader.value)
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: salesController.productList.length,
                          itemBuilder: (context, index) {
                            final data = salesController.productList[index];
                            if (data.status!.toLowerCase() == 'pending') {
                              return const SizedBox();
                            } else {
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// Product Name and Variant
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${data.productName!} ${data.companyName!} (${data.variant})',
                                              style: CustomTextStyles
                                                      .darkTextStyle()
                                                  .copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              salesController
                                                  .textControllers[index]
                                                  .clear();
                                            },
                                            icon: const Icon(Icons.clear,
                                                size: 20),
                                            tooltip: 'Clear quantity',
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 4),

                                      /// Price and Stock Info
                                      Text(
                                        'Price: ${data.price}  •  Stock: ${data.qty}',
                                        style: CustomTextStyles
                                            .lightSmallTextStyle(
                                          size: 14,
                                          color: AppColors.primaryColorDark,
                                        ),
                                      ),

                                      SizedBox(height: 12),

                                      /// Quantity Field
                                      Row(
                                        children: [
                                          const Text(
                                            'Qty:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: TextField(
                                              controller: salesController
                                                  .textControllers[index],
                                              keyboardType:
                                                  TextInputType.number,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: '0',
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 10),
                                                isDense: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors
                                                          .primaryColorDark),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
                child: Obx(
              () => RoundedButton(
                  showLoader: salesController.statusRecordLoader.value,
                  text: 'Save',
                  onPressed: () {
                    salesController.statusRecordLoader.value
                        ? null
                        : salesController.insertSalesRecord(context);
                  },
                  backgroundColor: AppColors.primaryColorDark,
                  textColor: Colors.white),
            )),
          ],
        ),
      ),
    );
  }
}
