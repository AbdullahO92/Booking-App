import 'package:cozy_app/controllers/auth_controller.dart';
import 'package:cozy_app/modules/apartment/apartment_details_page.dart';
import 'package:cozy_app/modules/home/add_apartment_page.dart';
import 'package:cozy_app/modules/home/apartment_model.dart';
import 'package:cozy_app/modules/home/dummy_apartments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'apartment_card.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authController = Get.find<AuthController>();

  List<Apartment> filteredApartments = dummyApartments;

  String selectedSearchType = "الاسم"; // النوع الافتراضي
  TextEditingController searchController = TextEditingController();

  void search(String query) {
    final q = query.toLowerCase();

    setState(() {
      switch (selectedSearchType) {
        case "الاسم":
          filteredApartments = dummyApartments
              .where((apt) => apt.name.toLowerCase().contains(q))
              .toList();
          break;

        case "المدينة":
          filteredApartments = dummyApartments
              .where((apt) => apt.city.toLowerCase().contains(q))
              .toList();
          break;

        case "المحافظة":
          filteredApartments = dummyApartments
              .where((apt) => apt.governorate.toLowerCase().contains(q))
              .toList();
          break;

        case "السعر":
          double? price = double.tryParse(query);
          filteredApartments = price == null
              ? []
              : dummyApartments.where((apt) => apt.price <= price).toList();
          break;

        case "عدد الغرف":
          int? rooms = int.tryParse(query);
          filteredApartments = rooms == null
              ? []
              : dummyApartments.where((apt) => apt.rooms >= rooms).toList();
          break;

        default:
          filteredApartments = dummyApartments;
      }
    });
  }

 
  void showSearchOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("اختر طريقة البحث:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 16),

              buildSearchTypeOption("الاسم"),
              buildSearchTypeOption("المدينة"),
              buildSearchTypeOption("المحافظة"),
              buildSearchTypeOption("السعر"),
              buildSearchTypeOption("عدد الغرف"),
            ],
          ),
        );
      },
    );
  }

 
  Widget buildSearchTypeOption(String type) {
    return ListTile(
      title: Text(type),
      leading: Icon(
        selectedSearchType == type
            ? Icons.radio_button_checked
            : Icons.radio_button_off,
        color: Colors.teal,
      ),
      onTap: () {
        setState(() => selectedSearchType = type);
        Navigator.pop(context); // إغلاق البوتوم شيت
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Apartments"),
        backgroundColor: Colors.teal,
      ),

      body: Column(
        children: [
          // ================== 🔍 صندوق البحث ==================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // زر اختيار نوع البحث
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "البحث حسب: $selectedSearchType",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: showSearchOptions,
                      child: const Text("تغيير"),
                    )
                  ],
                ),

                const SizedBox(height: 10),

                // صندوق البحث
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "أدخل كلمة للبحث...",
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey.shade600),
                    ),
                    onChanged: search,
                  ),
                ),
              ],
            ),
          ),

          // ================== قائمة الشقق ==================
          Expanded(
            child: ListView.builder(
              itemCount: filteredApartments.length,
              itemBuilder: (context, index) {
                final apt = filteredApartments[index];
                return ApartmentCard(
                  apartment: apt,
                  onTap: () => Get.to(() => ApartmentDetailsPage(apartment: apt)),
                );
              },
            ),
          ),
        ],
      ),

      // زر إضافة شقة للمالك
      floatingActionButton: authController.userType == UserType.owner
          ? FloatingActionButton(
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add),
              onPressed: () {
                Get.to(() => const AddApartmentPage());
              },
            )
          : null,
    );
  }
}
