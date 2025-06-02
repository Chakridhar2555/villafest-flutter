import 'package:flutter/material.dart';

class PropertyCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String description;
  final int guests;
  final int rooms;
  final int price;
  final int? oldPrice;
  final int? discountPercent;
  final bool isFavorite;
  final VoidCallback? onTap;

  const PropertyCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.description,
    required this.guests,
    required this.rooms,
    required this.price,
    this.oldPrice,
    this.discountPercent,
    this.isFavorite = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and favorite icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: Center(child: Text('demo')),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.purpleAccent],
                      ),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(location, style: TextStyle(color: Colors.black54)),
                  ),
                  SizedBox(height: 8),
                  Text(description, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people, size: 18, color: Colors.blueGrey),
                      SizedBox(width: 4),
                      Text('$guests guests'),
                      SizedBox(width: 12),
                      Icon(Icons.bed, size: 18, color: Colors.brown),
                      SizedBox(width: 4),
                      Text('$rooms rooms'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      if (oldPrice != null)
                        Text(
                          '₹${oldPrice!}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      if (oldPrice != null) SizedBox(width: 8),
                      Text(
                        '₹$price',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black87,
                        ),
                      ),
                      Text(' / night', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  if (discountPercent != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '$discountPercent% OFF',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 