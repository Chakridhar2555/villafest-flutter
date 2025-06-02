import 'package:flutter/material.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav.dart';

class HostAndEarnPage extends StatefulWidget {
  @override
  State<HostAndEarnPage> createState() => _HostAndEarnPageState();
}

class _HostAndEarnPageState extends State<HostAndEarnPage> {
  int _currentStep = 0;

  // Example amenities and rules
  final List<String> _amenities = ['Swimming Pool', 'Music System', 'Barbecue Area'];
  final List<String> _selectedAmenities = [];
  final TextEditingController _customAmenitiesController = TextEditingController();
  final List<String> _propertyRules = [
    'Strictly no hookah, ganja, or any kind of drugs.',
    "You're responsible for your personal belongings during the stay.",
    '₹2500 or more will be charged for any misbehavior or property damage (final amount depends on the extent of damage).',
    '₹500 fine for each broken beer bottle.',
    '₹1500 fine for cleaning in case of vomiting.',
    'Alcohol is allowed only for guests.',
    'Up to 6 liters of alcohol allowed per booking.',
    'For events with alcohol, an official permit from the Excise Department is mandatory',
  ];
  final List<String> _selectedRules = [];
  final TextEditingController _customRulesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildStepper(),
          SizedBox(height: 16),
          if (_currentStep == 0) _locationForm(),
          if (_currentStep == 1) _propertyDetailsForm(),
          if (_currentStep == 2) _amenitiesAndRulesForm(),
          if (_currentStep == 3) _propertyPhotosForm(),
          if (_currentStep == 4) _bankDetailsForm(),
          SizedBox(height: 32),
          Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: Color(0xFF00897B)),
                      padding: EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () {
                      setState(() {
                        _currentStep--;
                      });
                    },
                    child: Text('Back', style: TextStyle(fontSize: 18, color: Color(0xFF00897B))),
                  ),
                ),
              if (_currentStep > 0) SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00897B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (_currentStep < 4) {
                          _currentStep++;
                        } else {
                          // Submit logic here
                        }
                      });
                    },
                    child: Text(
                      _currentStep == 4 ? 'Submit' : 'Next',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(selectedIndex: 2),
    );
  }

  Widget _buildStepper() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _stepCircle(1, 'Location', _currentStep == 0),
          SizedBox(width: 24),
          _stepCircle(2, 'Property Details', _currentStep == 1),
          SizedBox(width: 24),
          _stepCircle(3, 'Amenities & Rules', _currentStep == 2),
          SizedBox(width: 24),
          _stepCircle(4, 'Photos', _currentStep == 3),
          SizedBox(width: 24),
          _stepCircle(5, 'Bank & GOV ID', _currentStep == 4),
        ],
      ),
    );
  }

  Widget _stepCircle(int step, String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: isActive ? Color(0xFF00897B) : Colors.white,
          child: Text(
            '$step',
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? Color(0xFF00897B) : Colors.black54)),
      ],
    );
  }

  Widget _locationForm() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          _formField('Address', 'Street address', true),
          SizedBox(height: 16),
          _formField('City', 'City', true),
          SizedBox(height: 16),
          _formField('State', 'State', true),
          SizedBox(height: 16),
          _formField('Postal Code', 'Postal/ZIP code', true),
          SizedBox(height: 16),
          _formField('Country', 'Country', true),
          SizedBox(height: 24),
          Text('Select Location on Map', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Click on the map, drag the marker, or enter coordinates to set your property's location", style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 16),
          _formField('Latitude', 'Enter latitude (-90 to 90)', true, helper: 'Enter a value between -90 and 90'),
          SizedBox(height: 16),
          _formField('Longitude', 'Enter longitude (-180 to 180)', true, helper: 'Enter a value between -180 and 180'),
          SizedBox(height: 16),
          _mapPlaceholder(),
        ],
      ),
    );
  }

  Widget _propertyDetailsForm() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Property Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          _formField('Property Title', 'Enter a catchy title for your property', true),
          SizedBox(height: 16),
          _formField('Number of Rooms', 'Enter the number of rooms', true),
          SizedBox(height: 16),
          _formField('Regular Price (per night)', 'Regular price', true),
          SizedBox(height: 16),
          _formField('Weekend Price (per night)', 'Weekend price', true),
          SizedBox(height: 16),
          _formField('Guest Limit', 'Maximum number of guests allowed', true, helper: 'Enter a positive number'),
          SizedBox(height: 16),
          _formField('Description', 'Describe your property', true, maxLines: 4),
        ],
      ),
    );
  }

  Widget _amenitiesAndRulesForm() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amenities & Rules', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          Text('Select Amenities', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _amenities.map((amenity) {
              return FilterChip(
                label: Text(amenity),
                selected: _selectedAmenities.contains(amenity),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedAmenities.add(amenity);
                    } else {
                      _selectedAmenities.remove(amenity);
                    }
                  });
                },
                selectedColor: Color(0xFF00897B).withOpacity(0.2),
                checkmarkColor: Color(0xFF00897B),
              );
            }).toList(),
          ),
          SizedBox(height: 24),
          Text('Add Custom Amenities', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Separate multiple amenities with commas', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customAmenitiesController,
                  decoration: InputDecoration(
                    hintText: 'e.g., BBQ Grill, Fire Pit, Garden',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00897B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Add custom amenities logic
                },
                child: Text('Add'),
              ),
            ],
          ),
          SizedBox(height: 32),
          Text('Property Rules', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Common Property Rules', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          Column(
            children: _propertyRules.map((rule) {
              return CheckboxListTile(
                value: _selectedRules.contains(rule),
                onChanged: (selected) {
                  setState(() {
                    if (selected == true) {
                      _selectedRules.add(rule);
                    } else {
                      _selectedRules.remove(rule);
                    }
                  });
                },
                title: Text(rule),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Color(0xFF00897B),
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
          SizedBox(height: 24),
          Text('Add Custom rules', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Add custom rules (separate multiple rules with commas)', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customRulesController,
                  decoration: InputDecoration(
                    hintText: 'e.g., No smoking, No parties, Quiet hours',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00897B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Add custom rules logic
                },
                child: Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _propertyPhotosForm() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Property Photos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid, width: 2, ),
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[50],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey[600]),
                  SizedBox(height: 12),
                  Text('Drag photos here or click to upload', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                  SizedBox(height: 4),
                  Text('Upload up to 10 photos\n(PNG, JPG, JPEG only)', style: TextStyle(color: Colors.grey[500], fontSize: 14), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bankDetailsForm() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bank Details & GOV ID', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          _formField('Account Holder Name', 'Enter account holder name', true),
          SizedBox(height: 16),
          _formField('Bank Name', 'Enter bank name', true),
          SizedBox(height: 16),
          _formField('Account Number', 'Enter account number', true),
          SizedBox(height: 16),
          _formField('IFSC Code', 'Enter IFSC code', true),
          SizedBox(height: 24),
          Text('Upload PAN Card', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _uploadPlaceholder('Upload PAN Card'),
          SizedBox(height: 16),
          Text('Upload Aadhaar Card', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _uploadPlaceholder('Upload Aadhaar Card'),
        ],
      ),
    );
  }

  Widget _uploadPlaceholder(String label) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid, width: 2),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[50],
      ),
      child: Center(
        child: Text(label, style: TextStyle(color: Colors.grey[600])),
      ),
    );
  }

  Widget _formField(String label, String hint, bool required, {String? helper, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            if (required) Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        if (helper != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(helper, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ),
      ],
    );
  }

  Widget _mapPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Center(
        child: Text('Map Placeholder', style: TextStyle(color: Colors.grey[600])),
      ),
    );
  }
} 