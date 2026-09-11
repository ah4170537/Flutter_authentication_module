import 'package:cloud_firestore/cloud_firestore.dart';

/// Merges every item from the guest's cart (`cart/{guestUserId}/user_cart`)
/// into the newly logged-in user's cart (`cart/{newUserId}/user_cart`).
/// If the same product exists in both, quantities are summed instead of
/// overwritten. After merging, the guest's cart documents are deleted.
///
/// You can either keep this as its own small service (as below) or move
/// the `mergeGuestCartIntoUser` method directly into your existing
/// CartService class — whichever fits your project structure better.
class CartMergeHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> mergeGuestCartIntoUser({
    required String guestUserId,
    required String newUserId,
  }) async {
    // Nothing to merge if it's the same id (shouldn't normally happen,
    // but guards against accidental no-op calls).
    if (guestUserId == newUserId || guestUserId.isEmpty) return;

    final guestCartRef = _db
        .collection('cart')
        .doc(guestUserId)
        .collection('user_cart');

    final newUserCartRef = _db
        .collection('cart')
        .doc(newUserId)
        .collection('user_cart');

    final guestCartSnapshot = await guestCartRef.get();

    if (guestCartSnapshot.docs.isEmpty) return; // guest cart was empty

    final batch = _db.batch();

    for (final guestDoc in guestCartSnapshot.docs) {
      final productId = guestDoc.id;
      final guestData = guestDoc.data();
      final num guestQuantity = guestData['quantity'] ?? 1;

      final existingDoc = await newUserCartRef.doc(productId).get();

      if (existingDoc.exists) {
        // Product already in the logged-in user's cart — sum quantities.
        final existingData = existingDoc.data() as Map<String, dynamic>;
        final num existingQuantity = existingData['quantity'] ?? 1;

        batch.update(newUserCartRef.doc(productId), {
          'quantity': existingQuantity + guestQuantity,
        });
      } else {
        // Product not in the user's cart yet — copy it over as-is.
        batch.set(newUserCartRef.doc(productId), guestData);
      }

      // Remove it from the guest cart regardless.
      batch.delete(guestCartRef.doc(productId));
    }

    await batch.commit();
  }
}