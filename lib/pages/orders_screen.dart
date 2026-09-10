import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatelessWidget {
  final String userId;

  const OrdersScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Fallback to current Firebase user if the passed userId is empty
    final String effectiveUserId = userId.isNotEmpty 
        ? userId 
        : (FirebaseAuth.instance.currentUser?.uid ?? '');

    if (effectiveUserId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primaryDark,
          elevation: 0,
        ),
        body: const Center(
          child: Text('Error: User session not found. Please log in again.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Removed .orderBy() to prevent index errors; you can add it back later once the index is created
        stream: FirebaseFirestore.instance
    .collection('orders')
    .doc(effectiveUserId)
    .collection('user_orders')
    .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryDark),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading orders: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No orders found yet.'),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;

              // Safely handle different possible keys and types for the price
              final dynamic rawPrice = orderData['totalPrice'] ?? 
                                       orderData['total'] ?? 
                                       orderData['amount'] ?? 
                                       orderData['grandTotal'] ?? 0;
              final num totalPrice = (rawPrice is num) ? rawPrice : (num.tryParse(rawPrice.toString()) ?? 0);

              final status = orderData['status'] ?? 'Pending';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    'Order #${orderId.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text('Total: PKR $totalPrice'),
                      const SizedBox(height: 4),
                      Text('Status: $status', style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(orderId: orderId,
                        userId: effectiveUserId,),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}