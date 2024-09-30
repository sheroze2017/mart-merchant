import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/insert_sales_bloc.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/record_bloc.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/restock_data_model.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockCount extends StatefulWidget {
  @override
  State<StockCount> createState() => _StockCountState();
}

class _StockCountState extends State<StockCount> with TickerProviderStateMixin {
  late TabController _tabController;

  final controller = Get.put(RecordController());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller.getallRestockRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'Stock Management',
          style: CustomTextStyles.w600TextStyle(),
        ),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: CustomTextStyles.w600TextStyle(size: 18),
          controller: _tabController,
          tabs: [
            Tab(text: 'Stock'),
            Tab(text: 'Restock'),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        StockPage(), // Page for viewing stock
        RestockPage(), // Page for restocking items
      ]),
    );
  }
}

// Page to view stock
class StockPage extends StatelessWidget {
  final RecordController controller = Get.find();
  final InsertSalesRecord salesController = Get.put(InsertSalesRecord());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        itemCount: salesController.productList.length,
        itemBuilder: (context, index) {
          final toothpaste = salesController.productList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Card(
              color: AppColors.primaryColor,
              elevation: 2,
              child: ListTile(
                minVerticalPadding: 20,
                title: Text(toothpaste.productName.toString(),
                    style: CustomTextStyles.darkTextStyle()),
                subtitle: Text(
                    '${toothpaste.variant} \nQty Available ${toothpaste.qty}',
                    style: CustomTextStyles.lightSmallTextStyle()),
                trailing: RoundedButtonSmall(
                  onPressed: () {
                    controller.restockRequest(
                        toothpaste.productId.toString(), context);
                  },
                  text: 'Restock',
                  textColor: AppColors.whiteColor,
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

// Page to restock items
class RestockPage extends StatelessWidget {
  final c = Get.put(RecordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RecordController>(
        init: RecordController(),
        builder: (controller) {
          return controller.allRestockLoader.value
              ? Center(child: CircularProgressIndicator())
              : controller.restockRecord.isEmpty
                  ? Center(
                      child: Text(
                          'No Restock Data Found')) // Show message if no data is found
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: controller.restockRecord.length,
                      itemBuilder: (context, index) {
                        IndividualRestockData toothpaste =
                            controller.restockRecord[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 4),
                          child: Card(
                            color: AppColors.primaryColor,
                            elevation: 2,
                            child: ListTile(
                                minVerticalPadding: 20,
                                title: Text(
                                    toothpaste.productDetails!.productName ??
                                        'N/a',
                                    style: CustomTextStyles.darkTextStyle()),
                                subtitle: Text(
                                    '${toothpaste.productDetails!.variant} \nPrice Available ${toothpaste.productDetails!.price}',
                                    style:
                                        CustomTextStyles.lightSmallTextStyle()),
                                trailing: Column(
                                  children: [
                                    RoundedButtonSmall(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(16.0),
                                              content: Column(
                                                mainAxisSize: MainAxisSize
                                                    .min, // Keep the dialog size to its content size
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Change Status',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'If you ask for restock by mistaken then cancel your request from below',
                                                    style: CustomTextStyles
                                                        .lightTextStyle(),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: RoundedButton(
                                                          text: 'Cancelled',
                                                          onPressed: () {
                                                            controller.removeRestockRequest(
                                                                toothpaste
                                                                    .restockId
                                                                    .toString(),
                                                                'Cancelled by BA',
                                                                context);
                                                          },
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white)),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'If restock is done then change status to completed',
                                                    style: CustomTextStyles
                                                        .lightTextStyle(),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: RoundedButton(
                                                          text: 'Completed',
                                                          onPressed: () {
                                                            controller.removeRestockRequest(
                                                                toothpaste
                                                                    .restockId
                                                                    .toString(),
                                                                'Completed',
                                                                context);
                                                          },
                                                          backgroundColor: AppColors
                                                              .primaryColorDark,
                                                          textColor: AppColors
                                                              .whiteColor)),
                                                ],
                                              ),
                                            );
                                          },
                                        );

                                        // Call a metho
                                        //d from the controller to remove the item
                                        ///controller.removeRestockRecord(toothpaste);
                                      },
                                      text: 'Change',
                                      textColor: AppColors.whiteColor,
                                      backgroundColor:
                                          AppColors.primaryColorDark,
                                    ),
                                  ],
                                )),
                          ),
                        );
                      },
                    );
        },
      ),
    );
  }
}
