import 'package:flutter/material.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/property_card.dart';
import 'property_details_page.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> properties = [
    {
      'imageUrl': 'https://via.placeholder.com/400x200',
      'title': 'demo',
      'location': 'Hyderabad, Telangana',
      'description': 'testing',
      'guests': 5,
      'rooms': 5,
      'price': 2000,
      'oldPrice': 3000,
      'discountPercent': 33,
      'isFavorite': false,
    },
    // Add more properties here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.teal[700],
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage('assets/banner.jpg'), // Add your banner image
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.teal.withOpacity(0.7),
                  BlendMode.srcATop,
                ),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 16,
                  top: 16,
                  child: Text(
                    'Celebration\nLife',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // Add carousel arrows if needed
              ],
            ),
          ),
          SizedBox(height: 24),
          // Filter by Amenities
          Text('Filter by Amenities', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _amenityCard(Icons.pool, 'Swimming\npool'),
                SizedBox(width: 12),
                _amenityCard(Icons.music_note, 'Music\nsystem'),
                SizedBox(width: 12),
                _amenityCard(Icons.outdoor_grill, 'Barbecue\narea'),
                // Add more amenities here if needed
              ],
            ),
          ),
          SizedBox(height: 24),
          // Price Range
          Text('Price Range', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Slider(
            value: 0,
            min: 0,
            max: 50000,
            onChanged: (v) {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹0', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('₹50,000', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 24),
          // All Properties
          Text('All Properties', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          properties.isEmpty
              ? Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text('No properties found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Try adjusting your filters to see more results.', style: TextStyle(color: Colors.grey[600])),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Reset Filters'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: properties
                      .map((prop) => PropertyCard(
                            imageUrl: prop['imageUrl'],
                            title: prop['title'],
                            location: prop['location'],
                            description: prop['description'],
                            guests: prop['guests'],
                            rooms: prop['rooms'],
                            price: prop['price'],
                            oldPrice: prop['oldPrice'],
                            discountPercent: prop['discountPercent'],
                            isFavorite: prop['isFavorite'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PropertyDetailsPage(property: prop),
                                ),
                              );
                            },
                          ))
                      .toList(),
                ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(selectedIndex: 0),
    );
  }

  Widget _amenityCard(IconData icon, String label) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.teal[700]),
          SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
} 