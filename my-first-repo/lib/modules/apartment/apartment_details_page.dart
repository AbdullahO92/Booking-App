import 'package:cozy_app/modules/booking/booking_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/apartment_model.dart';

class ApartmentDetailsPage extends StatefulWidget {
  final Apartment apartment;

  const ApartmentDetailsPage({Key? key, required this.apartment})
      : super(key: key);

  @override
  State<ApartmentDetailsPage> createState() => _ApartmentDetailsPageState();
}

class _ApartmentDetailsPageState extends State<ApartmentDetailsPage> {
  
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildImage(String path, BoxFit fit) {
   
    try {
    
     
      
        return Image.asset(path, fit: fit, width: double.infinity, height: double.infinity);
      
    } catch (e) {
    
      return Container(
        color: Colors.grey[300],
        child: const Center(child: Icon(Icons.broken_image, size: 50)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.apartment;

    // ignore: unnecessary_null_comparison
    final gallery = (a.gallery ?? []).isNotEmpty ? a.gallery! : (a.image != null ? [a.image] : []);

    return Scaffold(
      appBar: AppBar(
        title: Text(a.name),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            SizedBox(
              height: 260,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: gallery.length,
                onPageChanged: (idx) => setState(() => _currentIndex = idx),
                itemBuilder: (context, index) {
                  return _buildImage(gallery[index], BoxFit.cover);
                },
              ),
            ),

           
            if (gallery.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(gallery.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == i ? 12 : 8,
                        height: _currentIndex == i ? 12 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == i ? Colors.teal : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ),
              ),

            if (gallery.length > 1)
              SizedBox(
                height: 90,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: gallery.length,
                  itemBuilder: (context, index) {
                    final img = gallery[index];
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: _currentIndex == index ? Colors.teal : Colors.transparent, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: _buildImage(img, BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      a.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    // ignore: unnecessary_null_comparison
                    a.price != null ? "\$${a.price}" : "-",
                    style: const TextStyle(fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

         
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(a.location ?? "Unknown location", style: const TextStyle(fontSize: 15))),
                  const SizedBox(width: 10),
                  const Icon(Icons.meeting_room, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text("${a.rooms } rooms", style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(a.description ?? "No description provided.", style: const TextStyle(fontSize: 15, height: 1.4)),
                const SizedBox(height: 16),
                if (a.ownerPhone != null)
                  Text("Owner: ${a.ownerPhone}", style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ]),
            ),

            const SizedBox(height: 24),




            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text("Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("⭐ 4.6 (34 reviews)"),
                SizedBox(height: 8),
              ]),
            ),

            const SizedBox(height: 20),

            
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  onPressed: () {
                  //  Get.snackbar("Booking", "Booking page coming soon!");
                    Get.to(() => BookingPage(apartment: a, ));
                  },
                  child: const Text("Book Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
