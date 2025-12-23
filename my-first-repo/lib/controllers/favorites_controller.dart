import 'package:cozy_app/modules/home/apartment_model.dart';
import 'package:get/get.dart';


class FavoritesController extends GetxController {
  // قائمة المفضلة
  RxList<Apartment> favorites = <Apartment>[].obs;

  // إضافة أو إزالة من المفضلة
  void toggleFavorite(Apartment apartment) {
    if (favorites.contains(apartment)) {
      favorites.remove(apartment);
    } else {
      favorites.add(apartment);
    }
  }

  // تحقق إذا الشقة موجودة بالمفضلة
  bool isFavorite(Apartment apartment) {
    return favorites.contains(apartment);
  }
}
