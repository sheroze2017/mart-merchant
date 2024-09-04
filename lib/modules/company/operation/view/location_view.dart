import 'package:ba_merchandise/modules/company/dashboard/view/company_home.dart';
import 'package:ba_merchandise/modules/company/operation/view/new_location.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/dailog/mark_absent_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/style/custom_textstyle.dart';
import '../../../b.a/dashboard/view/dashboard.dart';
import '../bloc/operation_bloc.dart';

class CompanyLocationScreen extends StatelessWidget {
  CompanyLocationScreen({super.key});

  final OperationBloc operationBloc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Set Location',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationPickerScreen()),
                        );

                        if (result != null) {
                          final latLng = result['latLng'] as LatLng;
                          final placeName = result['placeName'] as String;

                          print('Selected Location: $placeName');
                          print(
                              'Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}');
                        }
                      },
                      child: const DashboardCard(
                        asset: 'assets/images/location.png',
                        title: 'Add New Location',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              const heading(
                title: 'All Locations',
              ),
              SizedBox(
                height: 2.h,
              ),
              Obx(
                () => ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: operationBloc.locations.length,
                    itemBuilder: (context, index) {
                      final location = operationBloc.locations[index];
                      return Card(
                          color: Colors.blue.shade50,
                          elevation: 4,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  location['name'],
                                  style: CustomTextStyles.lightSmallTextStyle(
                                      size: 18, color: Colors.blue),
                                ),
                                subtitle: Text(
                                  'Lat: ${location['lat']}\nLng: ${location['lng']}',
                                  style: CustomTextStyles.lightSmallTextStyle(),
                                ),
                                // leading: Icon(Icons.location_on),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Edit',
                                    style: CustomTextStyles.lightTextStyle(
                                        size: 16, color: Colors.black),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => MarkAbsentDialog(
                                          dailogText:
                                              'Are you certain you wish to delete this location?',
                                          onMarkAbsent: () async {
                                            operationBloc.deleteLocation(
                                                location['locationId']);
                                          },
                                          markAbsentText: 'Delete',
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Delete',
                                      style: CustomTextStyles.lightTextStyle(
                                          size: 16, color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3.h,
                              )
                            ],
                          ));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
