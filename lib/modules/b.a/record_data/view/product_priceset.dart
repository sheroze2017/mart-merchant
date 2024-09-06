import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/record_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProductPriceSet extends StatefulWidget {
  const ProductPriceSet({super.key});

  @override
  State<ProductPriceSet> createState() => _ProductPriceSetState();
}

class _ProductPriceSetState extends State<ProductPriceSet> {
  List<TextEditingController> _controllers = [];
  bool _isDetailVisible = false;
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
                      'Change individual product price of each product',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Obx(
                  () => (_controllers.length != controller.records.length)
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
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
                                      '${toothpaste.quantityGm} gm\n Current Price ${toothpaste.pricePkr} ',
                                      style: CustomTextStyles
                                          .lightSmallTextStyle()),
                                  trailing: SizedBox(
                                    width: 30.w,
                                    child: Expanded(
                                      child: TextField(
                                        controller: _controllers[index],
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              _controllers[index].clear();
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              size: 15,
                                            ),
                                          ),
                                          label: Text('Price'),
                                          labelStyle:
                                              CustomTextStyles.lightTextStyle(
                                                  size: 10),
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
                                  )),
                            );
                          }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: RoundedButtonSmall(
                            text: 'Save',
                            onPressed: () {
                              controller
                                  .updateProductPriceOfflineStore(_controllers);
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
