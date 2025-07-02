import 'package:ba_merchandise/common/style/custom_textstyle.dart';
import 'package:ba_merchandise/common/utils/function.dart';
import 'package:ba_merchandise/modules/admin/operation/model/sales_model.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/insert_sales_bloc.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../common/style/color.dart';

class EditRecordSalesScreen extends StatefulWidget {
  final IndividualSalesData saleData;

  const EditRecordSalesScreen({super.key, required this.saleData});

  @override
  State<EditRecordSalesScreen> createState() => _EditRecordSalesScreenState();
}

class _EditRecordSalesScreenState extends State<EditRecordSalesScreen> {
  final List<TextEditingController> _controllers = [];
  final InsertSalesRecord salesController = Get.put(InsertSalesRecord());

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers.clear();
    for (var product in widget.saleData.productsSold ?? []) {
      _controllers.add(TextEditingController(text: product.qty ?? '0'));
    }
  }

  void _saveEdits() {
    for (int i = 0; i < _controllers.length; i++) {
      widget.saleData.productsSold![i].qty = _controllers[i].text;
    }
    // Send updated data to server or pass it back
    Navigator.pop(context, widget.saleData); // return updated data
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.saleData.productsSold ?? [];
    final dateFormatted = Utils.formatDate(widget.saleData.createdAt ?? '');

    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Sales Record'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text('Date: $dateFormatted',
                style: CustomTextStyles.lightSmallTextStyle()),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                          '${product.productName}${product.variant} (${product.variant} )'),
                      subtitle: Text('Unit Price: ${product.unitPrice}'),
                      trailing: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controllers[index],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Qty',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        child: Obx(
          () => RoundedButton(
            showLoader: salesController.editRecordLoader.value,
            text: 'Save Changes',
            onPressed: () {
              List<Map<String, dynamic>> saleProducts = [];
              for (int i = 0; i < _controllers.length; i++) {
                var product = widget.saleData.productsSold![i];
                String qty =
                    _controllers[i].text.isEmpty ? "0" : _controllers[i].text;
                saleProducts.add({
                  "product_id": product.productId,
                  "qty": qty,
                });
              }
              Map<String, dynamic> body = {
                "sale_id":
                    widget.saleData.saleId, // Assuming saleId is available
                "sale_products": saleProducts,
              };
              salesController.editSaleRecord(body, context);
            },
            backgroundColor: AppColors.primaryColorDark,
            textColor: Colors.white,
          ),
        ),
      )),
    );
  }
}
