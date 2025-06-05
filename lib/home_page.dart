import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/property_card.dart';
import 'property_details_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> properties = [];
  List<Map<String, dynamic>> banners = [];
  List<Map<String, dynamic>> amenities = [];
  bool isLoadingBanners = true;
  bool isLoadingAmenities = true;
  bool isLoadingProperties = true;
  String? bannerError;
  String? amenitiesError;
  String? propertiesError;

  @override
  void initState() {
    super.initState();
    fetchBanners();
    fetchAmenities();
    fetchProperties();
  }

  bool isWeekend() {
    final now = DateTime.now();
    return now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
  }

  Future<void> fetchProperties() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['SERVER_URL']}/properties/get-properties'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            properties = List<Map<String, dynamic>>.from(data['properties']);
            isLoadingProperties = false;
          });
        } else {
          setState(() {
            propertiesError = 'Failed to load properties';
            isLoadingProperties = false;
          });
        }
      } else {
        setState(() {
          propertiesError = 'Failed to load properties';
          isLoadingProperties = false;
        });
      }
    } catch (e) {
      setState(() {
        propertiesError = 'Error: $e';
        isLoadingProperties = false;
      });
    }
  }

  Future<void> fetchBanners() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['SERVER_URL']}/banners'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            banners = List<Map<String, dynamic>>.from(data['banners']);
            isLoadingBanners = false;
          });
        } else {
          setState(() {
            bannerError = 'Failed to load banners';
            isLoadingBanners = false;
          });
        }
      } else {
        setState(() {
          bannerError = 'Failed to load banners';
          isLoadingBanners = false;
        });
      }
    } catch (e) {
      setState(() {
        bannerError = 'Error: $e';
        isLoadingBanners = false;
      });
    }
  }

  Future<void> fetchAmenities() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['SERVER_URL']}/amenities'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            amenities = List<Map<String, dynamic>>.from(data['amenities']);
            isLoadingAmenities = false;
          });
        } else {
          setState(() {
            amenitiesError = 'Failed to load amenities';
            isLoadingAmenities = false;
          });
        }
      } else {
        setState(() {
          amenitiesError = 'Failed to load amenities';
          isLoadingAmenities = false;
        });
      }
    } catch (e) {
      setState(() {
        amenitiesError = 'Error: $e';
        isLoadingAmenities = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Banner Container
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.teal[700],
              borderRadius: BorderRadius.circular(16),
            ),
            child:
                isLoadingBanners
                    ? Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                    : bannerError != null
                    ? Center(
                      child: Text(
                        bannerError!,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    : banners.isEmpty
                    ? Center(
                      child: Text(
                        'No banners available',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    : PageView.builder(
                      itemCount: banners.length,
                      itemBuilder: (context, index) {
                        final banner = banners[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(
                                '${dotenv.env['SERVER_URL']}${banner['imagePath']}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
          ),
          SizedBox(height: 24),
          // Filter by Amenities
          Text(
            'Filter by Amenities',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          isLoadingAmenities
              ? Center(child: CircularProgressIndicator())
              : amenitiesError != null
              ? Center(child: Text(amenitiesError!))
              : amenities.isEmpty
              ? Center(child: Text('No amenities available'))
              : Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: amenities.length,
                  itemBuilder: (context, index) {
                    final amenity = amenities[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Image.network(
                              '${dotenv.env['SERVER_URL']}${amenity['iconUrl']}',
                              height: 32,
                              width: 32,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.error,
                                  size: 32,
                                  color: Colors.teal[700],
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Text(
                              amenity['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          SizedBox(height: 24),
          // Price Range
          Text(
            'Price Range',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Slider(value: 0, min: 0, max: 50000, onChanged: (v) {}),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹0', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('₹50,000', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 24),
          // All Properties
          Text(
            'All Properties',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          isLoadingProperties
              ? Center(child: CircularProgressIndicator())
              : propertiesError != null
              ? Center(child: Text(propertiesError!))
              : properties.isEmpty
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
                    Text(
                      'No properties found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Try adjusting your filters to see more results.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Reset Filters'),
                    ),
                  ],
                ),
              )
              : Column(
                children:
                    properties.map((property) {
                      final isWeekendDay = isWeekend();
                      final currentPrice =
                          isWeekendDay
                              ? property['weekendPrice']
                              : property['price'];
                      final otherPrice =
                          isWeekendDay
                              ? property['price']
                              : property['weekendPrice'];
                      final discountPercent =
                          isWeekendDay
                              ? 0
                              : ((property['weekendPrice'] -
                                          property['price']) /
                                      property['weekendPrice'] *
                                      100)
                                  .round();

                      return PropertyCard(
                        imageUrl:
                            '${dotenv.env['SERVER_URL']?.replaceAll(RegExp(r'/$'), '')}${property['mainImage']}',
                        title: property['title'],
                        location:
                            '${property['address']['city']}, ${property['address']['state']}',
                        description: property['description'],
                        guests: property['maxGuests'],
                        rooms: property['rooms'],
                        price: currentPrice,
                        oldPrice: isWeekendDay ? null : otherPrice,
                        discountPercent: discountPercent,
                        isFavorite: false,
                        additionalImages:
                            (property['additionalImages'] as List<dynamic>?)
                                ?.map(
                                  (img) =>
                                      '${dotenv.env['SERVER_URL']?.replaceAll(RegExp(r'/$'), '')}$img',
                                )
                                .toList() ??
                            [],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      PropertyDetailsPage(property: property),
                            ),
                          );
                        },
                      );
                    }).toList(),
              ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(selectedIndex: 0),
    );
  }
}
