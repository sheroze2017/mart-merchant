import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/record_bloc.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StockCount extends StatefulWidget {
  @override
  State<StockCount> createState() => _StockCountState();
}

class _StockCountState extends State<StockCount> with TickerProviderStateMixin {
  late TabController _tabController;

  final RecordController controller = Get.put(RecordController());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        itemCount: controller.records.length,
        itemBuilder: (context, index) {
          final toothpaste = controller.records[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Card(
              color: AppColors.primaryColor,
              elevation: 2,
              child: ListTile(
                minVerticalPadding: 20,
                title: Text(toothpaste.name,
                    style: CustomTextStyles.darkTextStyle()),
                subtitle: Text(
                    '${toothpaste.quantityGm} gm\nQty Available ${toothpaste.stock}',
                    style: CustomTextStyles.lightSmallTextStyle()),
                trailing: RoundedButtonSmall(
                  onPressed: () {
                    controller.RestockRecord(toothpaste);
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
  final RecordController controller = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        itemCount: controller.restockRecord.length,
        itemBuilder: (context, index) {
          final toothpaste = controller.restockRecord[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Card(
              color: AppColors.primaryColor,
              elevation: 2,
              child: ListTile(
                minVerticalPadding: 20,
                title: Text(toothpaste.name,
                    style: CustomTextStyles.darkTextStyle()),
                subtitle: Text(
                    '${toothpaste.quantityGm} gm\nQty Available ${toothpaste.stock}',
                    style: CustomTextStyles.lightSmallTextStyle()),
                trailing: RoundedButtonSmall(
                  onPressed: () {
                    controller.RemoveRestockRecord(toothpaste);
                  },
                  text: 'Remove',
                  textColor: AppColors.whiteColor,
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
