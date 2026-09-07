import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to user's cart subcollection
  CollectionReference<Map<String, dynamic>> _cartRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('cart');
  }

  // Add or increment item in cart
  Future<void> addToCart({
    required String userId,
    required String productId,
    required String name,
    required num price,
    required String imageUrl,
    required int quantity,
  }) async {
    final docRef = _cartRef(userId).doc(productId);
    
    final docSnap = await docRef.get();
    if (docSnap.exists) {
      // If item already exists, increment its quantity atomically
      final currentQuantity = docSnap.data()?['quantity'] ?? 1;
      await docRef.update({'quantity': currentQuantity + quantity});
    } else {
      // Otherwise, create a new cart entry
      await docRef.set({
        'productId': productId,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Update item quantity (Plus / Minus)
  Future<void> updateQuantity({
    required String userId,
    required String productId,
    required int newQuantity,
  }) async {
    if (newQuantity <= 0) {
      await removeFromCart(userId: userId, productId: productId);
    } else {
      await _cartRef(userId).doc(productId).update({'quantity': newQuantity});
    }
  }

  // Remove single item
  Future<void> removeFromCart({
    required String userId,
    required String productId,
  }) async {
    await _cartRef(userId).doc(productId).delete();
  }

  // Stream cart items for real-time UI updates
  Stream<QuerySnapshot<Map<String, dynamic>>> getCartStream(String userId) {
    return _cartRef(userId).orderBy('updatedAt', descending: true).snapshots();
  }
}