import 'package:get/get.dart';
import 'package:ghar_sathi/src/features/property_type/property_type_model.dart';
import 'package:ghar_sathi/src/features/property_type/property_type_services.dart';


class PropertyTypeController extends GetxController {
  final PropertyTypeService _service = PropertyTypeService();

  var typeList = <PropertyTypeModel>[].obs;
  var selectedTypeId = "".obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    fetchPropertyTypes();
    super.onInit();
  }

  void fetchPropertyTypes() async {
    try {
      isLoading.value = true;
      final types = await _service.getPropertyTypes();
      typeList.assignAll(types);

      if (types.isNotEmpty) {
        selectedTypeId.value = types.first.id;
      }
    } catch (e) {
      print("Error loading types: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
