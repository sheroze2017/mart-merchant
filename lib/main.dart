import 'package:ba_merchandise/core/local/hive_db/hive.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/record_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

import 'core/routes/routes.dart';
import 'modules/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(AttendanceAdapter());
  Hive.registerAdapter(RecordModelAdapter());
  Hive.registerAdapter(SalesRecordModelAdapter());
  await Hive.openBox<Attendance>('attendanceBox');
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
        theme: ThemeData(
          // Define the headline text styles in the textTheme
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            displayMedium: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            displaySmall: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            headlineMedium: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
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
    Get.put(RecordController());
    Get.put(OperationBloc());
  }
}
