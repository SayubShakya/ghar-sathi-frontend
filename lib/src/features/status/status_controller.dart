import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/status/status_model.dart';
import 'package:ghar_sathi/src/features/status/status_services.dart';


class StatusController extends GetxController {
  final StatusRepository repository = StatusRepository();

  var statuses = <PropertyStatus>[].obs;
  var isLoading = false.obs;
  var selectedStatusId = ''.obs; // store ID not name

  @override
  void onInit() {
    super.onInit();
    fetchStatuses();
  }

  Future<void> fetchStatuses() async {
    try {
      isLoading.value = true;
      final result = await repository.fetchStatuses();
      statuses.assignAll(result);

      if (statuses.isNotEmpty && selectedStatusId.value.isEmpty) {
        selectedStatusId.value = statuses.first.id; // auto select first
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
