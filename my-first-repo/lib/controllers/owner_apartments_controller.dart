import 'package:get/get.dart';
import 'package:cozy_app/modules/home/apartment_model.dart';

class OwnerApartmentsController extends GetxController {
  /// قائمة الشقق التي أضافها المالك
  var myApartments = <Apartment>[].obs;
var allApartments = <Apartment>[].obs;   // كل الشقق
  /// إضافة شقة جديدة
  void addApartment(Apartment apt) {
    allApartments.add(apt);
    myApartments.add(apt);
  }

  /// حذف شقة
  void deleteApartment(int id) {
    allApartments.removeWhere((apt) => apt.id == id);
    myApartments.removeWhere((apt) => apt.id == id);
  }

  /// تعديل شقة
  void updateApartment(Apartment updated) {
    int index = myApartments.indexWhere((apt) => apt.id == updated.id);
    if (index != -1) {
      myApartments[index] = updated;
    }
  }
}
