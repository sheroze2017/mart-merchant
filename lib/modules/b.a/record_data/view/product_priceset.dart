import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/record_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProductPriceSet extends StatefulWidget {
  const ProductPriceSet({super.key});

  @override
  State<ProductPriceSet> createState() => _ProductPriceSetState();
}

class _ProductPriceSetState extends State<ProductPriceSet> {
  final TextEditingController _controller = TextEditingController();
  bool _isDetailVisible = false;
  final RecordController controller = Get.put(RecordController());
  @override
  void initState() {
    super.initState();
    //_initializeControllers();
  }

  // void _initializeControllers() {
  //   _controllers = List.generate(
  //     controller.records.length,
  //     (index) => TextEditingController(
  //         text: controller.records[index].pricePkr.toString()),
  //   );
  // }

  @override
  void dispose() {
    // Dispose of all controllers to prevent memory leaks
    // for (var controller in _controllers) {
    //   controller.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Product Price',
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
                      'Record your product price ',
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
                              subtitle: Text('${toothpaste.quantityGm} gm',
                                  style:
                                      CustomTextStyles.lightSmallTextStyle()),
                              trailing: SizedBox(
                                width: 33.w, // Adjust width as needed
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _controller,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          label: Text('Price'),
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
                                        style:
                                            CustomTextStyles.lightTextStyle(),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        _controller.clear();
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
