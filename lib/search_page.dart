import 'package:flutter/material.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _searchField('Where', 'Search destinations'),
          SizedBox(height: 16),
          _searchField('Check in', 'Add dates'),
          SizedBox(height: 16),
          _searchField('Check out', 'Add dates'),
          SizedBox(height: 16),
          _searchField('Who', 'Add guests'),
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00897B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {},
              child: Text(
                'Search',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(selectedIndex: 1),
    );
  }

  Widget _searchField(String label, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 4),
          Text(hint, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
        ],
      ),
    );
  }
} 