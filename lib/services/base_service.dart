import 'package:ba_merchandise/services/request.dart';

abstract class BaseService {
  late final DioClient dioClient;

  BaseService() {
    dioClient = DioClient.getInstance();
  }
}
