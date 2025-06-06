import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';
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
  
  // Calendar related variables
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  Map<DateTime, List<String>> _events = {};

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

          // Add Calendar Section
          SizedBox(height: 24),
          Text(
            'Select Dates',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: (day) {
                return _events[day] ?? [];
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.red),
                holidayTextStyle: TextStyle(color: Colors.red),
                selectedDecoration: BoxDecoration(
                  color: Colors.teal[700],
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.teal[100],
                  shape: BoxShape.circle,
                ),
                rangeStartDecoration: BoxDecoration(
                  color: Colors.teal[700],
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: BoxDecoration(
                  color: Colors.teal[700],
                  shape: BoxShape.circle,
                ),
                withinRangeDecoration: BoxDecoration(
                  color: Colors.teal[100],
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _rangeStart = null;
                    _rangeEnd = null;
                    _rangeSelectionMode = RangeSelectionMode.toggledOff;
                  });
                }
              },
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _selectedDay = null;
                  _focusedDay = focusedDay;
                  _rangeStart = start;
                  _rangeEnd = end;
                  _rangeSelectionMode = RangeSelectionMode.toggledOn;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          SizedBox(height: 16),
          if (_rangeStart != null && _rangeEnd != null)
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
                    'Selected Dates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Check-in: ${_rangeStart!.day}/${_rangeStart!.month}/${_rangeStart!.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Check-out: ${_rangeEnd!.day}/${_rangeEnd!.month}/${_rangeEnd!.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Total Nights: ${_rangeEnd!.difference(_rangeStart!).inDays}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Total Price: ₹${property['price'] * _rangeEnd!.difference(_rangeStart!).inDays}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: (_rangeStart != null && _rangeEnd != null)
                  ? () {
                      // TODO: Implement booking logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Booking functionality coming soon!'),
                          backgroundColor: Colors.teal[700],
                        ),
                      );
                    }
                  : null,
              child: Text(
                'Book Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
