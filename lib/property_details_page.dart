import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav.dart';

class PropertyDetailsPage extends StatefulWidget {
  final Map<String, dynamic> property;
  const PropertyDetailsPage({Key? key, required this.property})
    : super(key: key);

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  bool isLoading = true;
  Map<String, dynamic>? propertyDetails;
  String? error;
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    fetchPropertyDetails();
  }

  Future<void> fetchPropertyDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.env['SERVER_URL']}/properties/get-properties/${widget.property['_id']}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            propertyDetails = data['property'];
            isLoading = false;
            // Set up the marker for the property location
            final coordinates = data['property']['location']['coordinates'];
            markers.add(
              Marker(
                markerId: MarkerId('property_location'),
                position: LatLng(coordinates[1], coordinates[0]),
                infoWindow: InfoWindow(
                  title: data['property']['title'],
                  snippet: data['property']['address']['street'],
                ),
              ),
            );
          });
        } else {
          setState(() {
            error = 'Failed to load property details';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to load property details';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void _launchMapsDirections(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch maps')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: CustomAppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: CustomAppBar(),
        body: Center(child: Text(error!)),
      );
    }

    final property = propertyDetails ?? widget.property;
    final address = property['address'];
    final amenities = property['amenities'] as List<dynamic>;
    final coordinates = property['location']['coordinates'];

    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            property['title'],
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Property image
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                '${dotenv.env['SERVER_URL']}${property['mainImage']}',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text('Image not available'));
                },
              ),
            ),
          ),
          SizedBox(height: 24),

          // Price Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${property['price']} / night',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                if (property['weekendPrice'] != null)
                  Text(
                    '₹${property['weekendPrice']} / weekend',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Property Details
          Text(
            'Property Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Row(
            children: [
              _buildDetailItem(Icons.people, '${property['maxGuests']} Guests'),
              SizedBox(width: 24),
              _buildDetailItem(
                Icons.door_sliding,
                '${property['rooms']} Rooms',
              ),
            ],
          ),
          SizedBox(height: 24),

          // About this property
          Text(
            'About this property',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Text(property['description'] ?? 'No description available'),
          SizedBox(height: 24),

          // Location with Map
          Text(
            'Location',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${address['street']}', style: TextStyle(fontSize: 16)),
              Text(
                '${address['city']}, ${address['state']} - ${address['postalCode']}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(coordinates[1], coordinates[0]),
                          zoom: 15,
                        ),
                        markers: markers,
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        mapToolbarEnabled: false,
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: FloatingActionButton(
                          onPressed:
                              () => _launchMapsDirections(
                                coordinates[1],
                                coordinates[0],
                              ),
                          child: Icon(Icons.directions),
                          backgroundColor: Colors.teal[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Amenities
          Text(
            'What this place offers',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                amenities.map((amenity) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          '${dotenv.env['SERVER_URL']}${amenity['iconUrl']}',
                          height: 20,
                          width: 20,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, size: 20);
                          },
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            amenity['name'],
                            style: TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
          SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(selectedIndex: 0),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal[700]),
        SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
