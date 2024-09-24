import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/modules/company/dashboard/view/company_home.dart';
import 'package:ba_merchandise/modules/company/operation/view/location/new_location.dart';
import 'package:ba_merchandise/widgets/appbar/custom_appbar.dart';
import 'package:ba_merchandise/widgets/dailog/mark_absent_dailog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../common/style/custom_textstyle.dart';
import '../../../../b.a/dashboard/view/dashboard.dart';
import '../../bloc/operation_bloc.dart';

class CompanyLocationScreen extends StatelessWidget {
  CompanyLocationScreen({super.key});

  final OperationBloc operationBloc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Set Location',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
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
                      return Slidable(
                          key: ValueKey(0),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                spacing: 1,
                                flex: 2,
                                onPressed: null,
                                backgroundColor: Color(0xFF0392CF),
                                foregroundColor: AppColors.whiteColor,
                                icon: Icons.edit,
                              ),
                              SlidableAction(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                flex: 2,
                                onPressed: (context) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => MarkAbsentDialog(
                                      dailogText:
                                          'Are you certain you wish to delete this location?',
                                      onMarkAbsent: () async {
                                        operationBloc
                                            .deleteLocation(location.placeId);
                                      },
                                      markAbsentText: 'Delete',
                                    ),
                                  );
                                },
                                backgroundColor:
                                    Color.fromARGB(255, 240, 110, 101),
                                foregroundColor: AppColors.whiteColor,
                                icon: Icons.delete,
                              ),
                            ],
                          ),

                          // The child of the Slidable is what the user sees when the
                          // component is not dragged.
                          child: Card(
                              color: AppColors.primaryColor,
                              elevation: 4,
                              child: Column(
                                children: [
                                  ListTile(
                                    minVerticalPadding: 16,
                                    title: Text(
                                      location.placeName,
                                      style:
                                          CustomTextStyles.darkHeadingTextStyle(
                                              size: 18, color: Colors.blue),
                                    ),
                                    subtitle: Text(
                                      'Lat: ${location.latitude}\nLng: ${location.longitude}',
                                      style: CustomTextStyles.lightTextStyle(),
                                    ),

                                    // leading: Icon(Icons.location_on),
                                  ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceEvenly,
                                  //   children: [
                                  //     Text(
                                  //       'Edit',
                                  //       style: CustomTextStyles.lightTextStyle(
                                  //           size: 16, color: Colors.black),
                                  //     ),
                                  //     InkWell(
                                  //       onTap: () {
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) => MarkAbsentDialog(
                                  //     dailogText:
                                  //         'Are you certain you wish to delete this location?',
                                  //     onMarkAbsent: () async {
                                  //       operationBloc.deleteLocation(
                                  //           location['locationId']);
                                  //     },
                                  //     markAbsentText: 'Delete',
                                  //   ),
                                  // );
                                  //       },
                                  //       child: Text(
                                  //         'Delete',
                                  //         style: CustomTextStyles.lightTextStyle(
                                  //             size: 16, color: Colors.red),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: 3.h,
                                  // )
                                ],
                              )));
                      // Card(
                      //     color: AppColors.primaryColor,
                      //     elevation: 4,
                      //     child: Column(
                      //       children: [
                      //         ListTile(
                      //           title: Text(
                      //             location['name'],
                      //             style: CustomTextStyles.lightSmallTextStyle(
                      //                 size: 18, color: Colors.blue),
                      //           ),
                      //           subtitle: Text(
                      //             'Lat: ${location['lat']}\nLng: ${location['lng']}',
                      //             style: CustomTextStyles.lightSmallTextStyle(),
                      //           ),
                      //           trailing: Column(
                      //             children: [],
                      //           ),
                      //           // leading: Icon(Icons.location_on),
                      //         ),
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceEvenly,
                      //           children: [
                      //             Text(
                      //               'Edit',
                      //               style: CustomTextStyles.lightTextStyle(
                      //                   size: 16, color: Colors.black),
                      //             ),
                      //             InkWell(
                      //               onTap: () {
                      //                 showDialog(
                      //                   context: context,
                      //                   builder: (context) => MarkAbsentDialog(
                      //                     dailogText:
                      //                         'Are you certain you wish to delete this location?',
                      //                     onMarkAbsent: () async {
                      //                       operationBloc.deleteLocation(
                      //                           location['locationId']);
                      //                     },
                      //                     markAbsentText: 'Delete',
                      //                   ),
                      //                 );
                      //               },
                      //               child: Text(
                      //                 'Delete',
                      //                 style: CustomTextStyles.lightTextStyle(
                      //                     size: 16, color: Colors.red),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         SizedBox(
                      //           height: 3.h,
                      //         )
                      //       ],
                      //     ));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
