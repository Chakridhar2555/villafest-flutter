import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu', style: TextStyle(color: Colors.teal[900])),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal[900]),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          // Top actions
          ListTile(
            leading: Icon(Icons.favorite_border, color: Colors.pink),
            title: Text('Wishlists'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.login, color: Colors.teal),
            title: Text('Login'),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add, color: Colors.teal),
            title: Text('Sign Up'),
            onTap: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
          Divider(height: 32),
          // Quick Links
          Text('Quick Links', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ListTile(title: Text('About Us'), onTap: () {}),
          ListTile(title: Text('Contact'), onTap: () {}),
          ListTile(title: Text('FAQ'), onTap: () {}),
          ListTile(title: Text('Blog'), onTap: () {}),
          ListTile(
            title: Text('List Your Property'),
            onTap: () {
              Navigator.pushNamed(context, '/host');
            },
          ),
          Divider(height: 32),
          // Legal
          Text('Legal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ListTile(title: Text('Terms & Conditions'), onTap: () {}),
          ListTile(title: Text('Privacy Policy'), onTap: () {}),
          ListTile(title: Text('Cancellation Policy'), onTap: () {}),
          ListTile(title: Text('Disclaimer'), onTap: () {}),
          ListTile(title: Text('Refund Policy'), onTap: () {}),
          Divider(height: 32),
          // Contact Info
          Text('Contact Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ListTile(
            leading: Icon(Icons.email, color: Colors.teal),
            title: Text('info@villafest.in'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
} 