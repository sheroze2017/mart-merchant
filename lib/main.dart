import 'package:ba_merchandise/modules/auth/view/login_view.dart';
import 'package:ba_merchandise/modules/auth/view/role_select_view.dart';
import 'package:ba_merchandise/modules/sync/bloc/appdata_bloc.dart';
import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'core/routes/routes.dart';
import 'modules/auth/bloc/auth_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.BAHOME,
        getPages: Routes.routes,
        title: 'Merchandiser',
        initialBinding: YourBinding(),
        //home: UserRoleSelect(),
      );
    });
  }
}

class YourBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SyncController());
    Get.put(AuthenticationController());
  }
}
