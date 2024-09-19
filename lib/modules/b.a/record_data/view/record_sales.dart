import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/merchandiser/dasboard/view/dashboard.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:intl/intl.dart'; // To format date and time

import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/style/color.dart';
import '../bloc/record_bloc.dart';

class RecordSales extends StatefulWidget {
  const RecordSales({super.key});

  @override
  State<RecordSales> createState() => _RecordSalesState();
}

class _RecordSalesState extends State<RecordSales> {
  List<TextEditingController> _controllers = [];
  bool _isDetailVisible = false;
  bool statusCheck = false;
  final RecordController controller = Get.find();
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() async {
    _controllers = await List.generate(
      controller.records.length,
      (index) => TextEditingController(text: '0'),
    );
    setState(() {});
  }

  final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Record Sales',
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    darkHeading(
                      title: 'Record your product sales ',
                      color: Colors.black,
                    ),
                    IconButton(
                      icon: Icon(Icons.error_outline_rounded),
                      onPressed: () {
                        setState(() {
                          _isDetailVisible = !_isDetailVisible;
                        });
                      },
                    ),
                  ],
                ),
                Visibility(
                  visible: _isDetailVisible,
                  child: Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.5),
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      'Mark your individual product sales of each product in quantity',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Row(
                  children: [
                    darkHeading(
                      title: 'Record Sales for Dated:',
                      color: Colors.black,
                    ),
                    headingSmall(title: todayDate),
                  ],
                ),
                Obx(
                  () => (_controllers.length != controller.records.length)
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
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
                                      '*${controller.records[index].quantityGm} gm \n*PKR ${controller.records[index].pricePkr} \n*Stock ${controller.records.value[index].stock}',
                                      style:
                                          CustomTextStyles.lightSmallTextStyle(
                                              size: 13))),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _controllers[index],
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(fontSize: 12),
                                            decoration: const InputDecoration(
                                              labelText: 'Qty',
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              isDense: false,
                                              hintText: '0',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _controllers[index].clear();
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          }),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                            text: 'Save',
                            onPressed: () {
                              controller.updateSalesRecord(_controllers);
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
      ),
    );
  }
}
