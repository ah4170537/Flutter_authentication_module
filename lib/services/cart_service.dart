import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Root collection 'cart' -> {userId} -> 'user_cart' -> {productId}
  CollectionReference<Map<String, dynamic>> _cartRef(String userId) {
    return _firestore.collection('cart').doc(userId).collection('user_cart');
  }

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
      final currentQuantity = docSnap.data()?['quantity'] ?? 1;
      await docRef.update({'quantity': currentQuantity + quantity});
    } else {
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

  Future<void> removeFromCart({
    required String userId,
    required String productId,
  }) async {
    await _cartRef(userId).doc(productId).delete();
  }

  // Clear entire cart (Used after completing checkout)
  Future<void> clearCart(String userId) async {
    final snapshots = await _cartRef(userId).get();
    final batch = _firestore.batch();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCartStream(String userId) {
    return _cartRef(userId).orderBy('updatedAt', descending: true).snapshots();
  }
}