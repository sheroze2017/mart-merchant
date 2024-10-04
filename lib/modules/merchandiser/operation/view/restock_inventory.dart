import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/merchandiser/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/merchandiser/operation/view/upload_image.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import '../../../b.a/dashboard/view/dashboard.dart';

class RestockInventory extends StatelessWidget {
  RestockInventory({super.key});
  final TextEditingController locationController = TextEditingController();
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final controller = Get.put(MerchantOperationBloc());
  List<int> restockCount = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Restock Inventory'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomDropdown(
                decoration: CustomDropdownDecoration(
                  prefixIcon: Icon(Icons.location_on_sharp),
                  expandedFillColor: AppColors.primaryColor,
                  closedFillColor: AppColors.primaryColor,
                ),
                hintText: 'Select Location',
                items: ['Location 1', 'Location 2'],
                onChanged: (value) {
                  locationController.text = value.toString();
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  const darkHeading(
                    title: 'Record Inventory update for dated:',
                    color: Colors.black,
                  ),
                  headingSmall(title: today),
                ],
              ),
              Obx(
                () => ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.records.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: AppColors.primaryColor,
                        elevation: 2,
                        child: ListTile(
                            minVerticalPadding: 10,
                            title: Text(controller.records[index].name,
                                style: CustomTextStyles.darkTextStyle()),
                            subtitle: Obx(() => Text(
                                '${controller.records[index].quantityGm} gm - PKR ${controller.records[index].pricePkr} - Stock ${controller.records.value[index].stock}',
                                style: CustomTextStyles.lightSmallTextStyle())),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InputQty(
                                    initVal: 0,
                                    minVal: 0,
                                    steps: 1,
                                    onQtyChanged: (val) {
                                      restockCount[index] = int.parse(val);
                                    },
                                  ),
                                ],
                              ),
                            )),
                      );
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: RoundedButtonSmall(
                          text: 'Save',
                          onPressed: () {
                            Get.to(CameraScreen());
                          },
                          backgroundColor: Colors.black,
                          textColor: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
