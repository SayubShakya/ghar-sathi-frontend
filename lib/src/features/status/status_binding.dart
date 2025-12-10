import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/status/status_controller.dart';

class StatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatusController>(() => StatusController(), fenix: true);
  }
}
