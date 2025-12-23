import 'dart:io';
import 'package:cozy_app/controllers/owner_apartments_controller.dart';
import 'package:cozy_app/modules/home/apartment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
class AddApartmentPage extends StatefulWidget {
  const AddApartmentPage({super.key});

  @override
  State<AddApartmentPage> createState() => _AddApartmentPageState();
}

class _AddApartmentPageState extends State<AddApartmentPage> {
  final formKey = GlobalKey<FormState>();
final ownerController = Get.find<OwnerApartmentsController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();
final TextEditingController locationController = TextEditingController();
//final TextEditingController roomsController = TextEditingController();
final TextEditingController cityController = TextEditingController();
int roomsCount = 1;
  final ImagePicker picker = ImagePicker();

  File? apartmentImage;

  String? selectedGovernorate;
  

  Future<void> pickImage() async {
    final XFile? selected =
        await picker.pickImage(source: ImageSource.gallery);

    if (selected != null) {
      setState(() {
        apartmentImage = File(selected.path);
      });
    }
  }

  // void saveApartment() {
  //   if (!formKey.currentState!.validate()) return;

  //   if (apartmentImage == null) {
  //     Get.snackbar("خطأ", "يجب اختيار صورة للشقة",
  //         backgroundColor: Colors.red, colorText: Colors.white);
  //     return;
  //   }

  //   // حفظ البيانات (لاحقًا سيتم إرسالها إلى Laravel)
  //   Get.snackbar("نجاح", "تم إضافة الشقة بنجاح",
  //       backgroundColor: Colors.green, colorText: Colors.white);

  //   Get.back(); // ارجع للصفحة السابقة (HomePage)
  // }
  void saveApartment() {
  if (!formKey.currentState!.validate()) return;

  if (apartmentImage == null) {
    Get.snackbar("خطأ", "يجب اختيار صورة للشقة",
        backgroundColor: Colors.red, colorText: Colors.white);
    return;
  }

  final controller = Get.find<OwnerApartmentsController>();

  // إنشاء ID عشوائي مؤقت
  int newId = DateTime.now().millisecondsSinceEpoch;

  Apartment newApartment = Apartment(
    id: newId,
    name: nameController.text,
    price: double.parse(priceController.text),
    rooms: roomsCount,
    image: apartmentImage!.path, // لاحقاً ترفعها Laravel
    governorate: selectedGovernorate!,
    city: cityController.text,
    description: descController.text,
  );

  controller.addApartment(newApartment);

  Get.snackbar("نجاح", "تم إضافة الشقة بنجاح",
      backgroundColor: Colors.green, colorText: Colors.white);

  Get.back();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Apartment"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة الشقة
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    width: 180,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                      image: apartmentImage != null
                          ? DecorationImage(
                              image: FileImage(apartmentImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: apartmentImage == null
                        ? const Icon(Icons.camera_alt,
                            size: 40, color: Colors.black54)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // الاسم
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Apartment Name",
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "الاسم مطلوب" : null,
              ),
              const SizedBox(height: 15),

              // السعر
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price per night",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "السعر مطلوب" : null,
              ),
              const SizedBox(height: 15),


// 🔥 اختيار المحافظة
DropdownButtonFormField<String>(
  value: selectedGovernorate,
  decoration: const InputDecoration(
    labelText: "المحافظة",
    prefixIcon: Icon(Icons.map),
    border: OutlineInputBorder(),
  ),
  items: [
    "Damascus",
    "Aleppo",
    "Homs",
    "Hama",
    "Lattakia",
    "Tartous",
    "Daraa",
    "As-Suwayda",
    "Quneitra",
    "Idlib",
    "Raqqa",
    "Deir ez-Zor",
    "Hasakah",
  ].map((gov) {
    return DropdownMenuItem(
      value: gov,
      child: Text(gov),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedGovernorate = value;
    });
  },
  validator: (v) => v == null ? "اختر المحافظة" : null,
),
const SizedBox(height: 15),

// 🔥 إدخال المدينة بشكل يدوي
TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: "Apartment City",
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "المدينة مطلوب" : null,
              ),
              const SizedBox(height: 15),

TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Apartment location",
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "الموقع مطلوب" : null,
              ),
              const SizedBox(height: 15),

              // TextFormField(
              //   controller: roomsController,
              //   decoration: const InputDecoration(
              //     labelText: "Apartment rooms",
              //     prefixIcon: Icon(Icons.meeting_room),
              //   ),
              //   validator: (v) =>
              //       v == null || v.isEmpty ? "عدد الغرف مطلوب" : null,
              // ),
              // const SizedBox(height: 15),

 // القيمة الابتدائية

// داخل الـ build:
Row(
  children: [
    const Icon(Icons.meeting_room, color: Colors.teal),
    const SizedBox(width: 10),
    Text("عدد الغرف: $roomsCount", style: const TextStyle(fontSize: 16)),
    const Spacer(),
    IconButton(
      icon: const Icon(Icons.remove_circle, color: Colors.red),
      onPressed: () {
        setState(() {
          if (roomsCount > 1) roomsCount--; // ما ينقص أقل من 1
        });
      },
    ),
    
    IconButton(
      icon: const Icon(Icons.add_circle, color: Colors.green),
      onPressed: () {
        setState(() {
          roomsCount++;
        });
      },
          
    ),
  ],
),

              // الوصف
              TextFormField(
                controller: descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Description",
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "الوصف مطلوب" : null,
              ),
              const SizedBox(height: 25),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveApartment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Add Apartment",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
//مثال كيف تستدعي إضافة شقة من صفحة AddApartmentPage
// final apartmentController = Get.find<ApartmentController>();
//داخل زر الإرسال)////
// onPressed: () {
//   final data = {
//     "name": nameController.text,
//     "price": int.parse(priceController.text),
//     "description": descController.text,
//     "location": locationController.text,
//   };

//   apartmentController.addNewApartment(data);
// }


