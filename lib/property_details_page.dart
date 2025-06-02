import 'package:flutter/material.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav.dart';

class PropertyDetailsPage extends StatelessWidget {
  final Map<String, dynamic> property;
  const PropertyDetailsPage({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(property['title'], style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          // Property image
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: property['imageUrl'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(property['imageUrl'], fit: BoxFit.cover, width: double.infinity),
                  )
                : Center(child: Text('No Image')),
          ),
          SizedBox(height: 16),
          Text('About this property', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Divider(),
          Text(property['description'] ?? ''),
          SizedBox(height: 24),
          Text('Location', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Divider(),
          // You can embed a map widget here
          SizedBox(height: 16),
          Text('What this place offers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Divider(),
          // Amenities list here
          SizedBox(height: 24),
          Text('₹${property['price']} / night', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          if (property['oldPrice'] != null)
            Text('₹${property['oldPrice']} / weekend', style: TextStyle(fontSize: 18, color: Colors.grey, decoration: TextDecoration.lineThrough)),
          // ... Add more details as per your screenshots ...
        ],
      ),
      bottomNavigationBar: CustomBottomNav(selectedIndex: 0),
    );
  }
} 