import 'package:ba_merchandise/common/style/color.dart';
import 'package:ba_merchandise/core/local/hive_db/hive.dart';
import 'package:ba_merchandise/firebase_options.dart';
import 'package:ba_merchandise/modules/attendence/bloc/attendance_bloc.dart';
import 'package:ba_merchandise/modules/b.a/record_data/bloc/record_bloc.dart';
import 'package:ba_merchandise/modules/company/operation/bloc/operation_bloc.dart';
import 'package:ba_merchandise/modules/notification/api/firebase_api.dart';
import 'package:ba_merchandise/modules/sync/bloc/sync_bloc.dart';
import 'package:ba_merchandise/services/local_storage/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'core/routes/routes.dart';
import 'modules/auth/bloc/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

late Box attendanceBox;
late Box<SalesRecordModel> salesRecord;
late Box<RecordModel> recordModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//  await FirebaseApi().initNotification();

  Hive.registerAdapter(AttendanceAdapter());
  Hive.registerAdapter(SalesRecordModelAdapter());
  Hive.registerAdapter(RecordModelAdapter());

  attendanceBox = await Hive.openBox<Attendance>('attendanceBox');
  salesRecord = await Hive.openBox<SalesRecordModel>('SalesRecord');
  recordModel = await Hive.openBox<RecordModel>('RecordModel');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.WELCOMESCREEN,
        getPages: Routes.routes,
        title: 'Canvas Connect',
        initialBinding: YourBinding(),
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.whiteColor,
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
  void dependencies() async {
    Get.lazyPut(() => AuthStorage(), fenix: true);
    Get.put(SyncController());
    Get.put(AuthenticationController());
    Get.put(RecordController());
    Get.put(CompanyOperationBloc());
    Get.put(AttendanceController());
  }
}
