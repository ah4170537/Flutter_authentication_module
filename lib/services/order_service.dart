import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class OrderService {
  OrderService._();
  static final OrderService instance = OrderService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // EmailJS Credentials (update template ID if you use a separate one for orders)
  static const String _emailJsServiceId = 'service_ooo5xze';
  static const String _emailJsTemplateId = 'template_w5z2xdc';
  static const String _emailJsPublicKey = 'xLJyWo6CV8LvFq26t';

  Future<void> placeOrder({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String secondaryPhone,
    required String address,
    required String postalCode,
    required String deliveryMode,
    required List<Map<String, dynamic>> cartItems,
    required double subtotal,
    required double deliveryFee,
  }) async {
    final total = subtotal + deliveryFee;
    final trimmedEmail = email.trim().toLowerCase();
    final fullName = '${firstName.trim()} ${lastName.trim()}';

    // 1. Save order to Firestore
    await _firestore.collection('orders').add({
      'userId': userId,
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': trimmedEmail,
      'phone': phone.trim(),
      'secondaryPhone': secondaryPhone.trim(),
      'address': address.trim(),
      'postalCode': postalCode.trim(),
      'deliveryMode': deliveryMode,
      'items': cartItems,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Format cart items neatly into a single multi-line string for EmailJS
    String formattedItems = cartItems.map((item) {
      final name = item['name'] ?? 'Product';
      final quantity = item['quantity'] ?? 1;
      final price = item['price'] ?? 0.0;
      return '• $name (Qty: $quantity) - PKR ${(price * quantity).toStringAsFixed(2)}';
    }).join('\n');

    // 3. Send Email via EmailJS
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': _emailJsServiceId,
        'template_id': _emailJsTemplateId,
        'user_id': _emailJsPublicKey,
        'template_params': {
          'to_name': fullName,
          'to_email': trimmedEmail,
          'order_address': '${address.trim()}, Postal Code: ${postalCode.trim()}',
          'phone': phone.trim(),
          'delivery_mode': deliveryMode,
          'order_items': formattedItems,
          'subtotal': 'PKR ${subtotal.toStringAsFixed(2)}',
          'delivery_fee': 'PKR ${deliveryFee.toStringAsFixed(2)}',
          'total_amount': 'PKR ${total.toStringAsFixed(2)}',
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Email delivery failed: ${response.body}');
    }
  }
}