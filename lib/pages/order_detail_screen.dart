import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'checkout_screen.dart'; // Apni checkout screen ka sahi import path yahan dein

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  final String? userId;

  const OrderDetailScreen({super.key, required this.orderId, this.userId});

  @override
  Widget build(BuildContext context) {
    final String effectiveUserId = userId != null && userId!.isNotEmpty
        ? userId!
        : (FirebaseAuth.instance.currentUser?.uid ?? '');

    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('orders')
            .doc(effectiveUserId)
            .collection('user_orders')
            .doc(orderId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryDark),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Order details not found.'));
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final items = orderData['items'] as List<dynamic>? ?? [];
          
          final dynamic rawPrice = orderData['totalPrice'] ?? 
                                   orderData['total'] ?? 
                                   orderData['amount'] ?? 
                                   orderData['grandTotal'] ?? 0;
          final num totalPrice = (rawPrice is num) ? rawPrice : (num.tryParse(rawPrice.toString()) ?? 0);
          
          final status = orderData['status'] ?? 'Pending';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: #${orderId.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textGrey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text('Status: ', style: TextStyle(fontWeight: FontWeight.w500)),
                    Text(status, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 24),
                const Text(
                  'Items Purchased',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index] as Map<String, dynamic>;
                      final itemName = item['name'] ?? 'Product';
                      final dynamic itemPriceRaw = item['price'] ?? 0;
                      final num itemPrice = (itemPriceRaw is num) ? itemPriceRaw : (num.tryParse(itemPriceRaw.toString()) ?? 0);
                      
                      // Safe quantity parsing to avoid type errors
                      final dynamic rawQty = item['quantity'] ?? 1;
                      final int quantity = (rawQty is num) ? rawQty.toInt() : (int.tryParse(rawQty.toString()) ?? 1);
                      
                      final String imageUrl = item['imageUrl'] ?? '';

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
                                        ),
                                      )
                                    : Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey.shade200,
                                        child: const Icon(Icons.shopping_bag, size: 24, color: Colors.grey),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itemName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Qty: $quantity',
                                      style: const TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'PKR ${itemPrice * quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'PKR $totalPrice',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Reorder Button
                SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            userId: effectiveUserId,
            subtotal: totalPrice.toDouble(),
            deliveryFee: 0, 
            cartItems: items.map((item) {
              return {
                'productId': item['productId'] ?? '',
                'name': item['name'] ?? 'Product',
                'price': item['price'] ?? 0,
                'quantity': item['quantity'] ?? 1,
                'imageUrl': item['imageUrl'] ?? '',
              };
            }).toList(),
          ),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: const Text(
      'Reorder',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
              ],
            ),
          );
        },
      ),
    );
  }
}