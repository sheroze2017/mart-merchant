import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/record_data/model/record_model.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../bloc/record_bloc.dart';

class RecordSales extends StatefulWidget {
  const RecordSales({super.key});

  @override
  State<RecordSales> createState() => _RecordSalesState();
}

class _RecordSalesState extends State<RecordSales> {
  TextEditingController? _controllers;
  bool _isDetailVisible = false;
  bool statusCheck = false;
  final RecordController controller = Get.put(RecordController());
  @override
  void initState() {
    super.initState();
    screenloaded();
  }

  // _initializeControllers() {
  //   _controllers = List.generate(
  //     controller.records.length,
  //     (index) => TextEditingController(text: '0'),
  //   );
  // }

  void screenloaded() async {
    // await _initializeControllers();
    // statusCheck = true;
    // setState(() {});
  }

  @override
  void dispose() {
    // Dispose of all controllers to prevent memory leaks
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Record Sales',
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Record your product sales ',
                      style: CustomTextStyles.lightSmallTextStyle(size: 16),
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
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.5),
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(12)),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Mark your individual product sales of each product in quantity',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.records.length,
                      itemBuilder: (context, index) {
                        final toothpaste = controller.records[index];
                        return Card(
                          color: Colors.blue.shade50,
                          elevation: 2,
                          child: ListTile(
                              minVerticalPadding: 20,
                              title: Text(toothpaste.name,
                                  style: CustomTextStyles.darkTextStyle()),
                              subtitle: Text(
                                  '${toothpaste.quantityGm} gm - PKR ${toothpaste.pricePkr}',
                                  style:
                                      CustomTextStyles.lightSmallTextStyle()),
                              trailing: SizedBox(
                                width: 100, // Adjust width as needed
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _controllers,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          label: Text('Qty'),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                          isDense: true,
                                          hintText: '0',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        _controllers!.clear();
                                      },
                                    ),
                                  ],
                                ),
                              )),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
