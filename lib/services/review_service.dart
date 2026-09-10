import 'package:cloud_firestore/cloud_firestore.dart';

/// Handles all Firestore read/write logic for product reviews.
/// Reviews are stored as an array field inside `reviews/{productId}`.
class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Adds a new review to the product's review array.
  ///
  /// Each review gets a unique `reviewId` (timestamp-based) so it can be
  /// individually targeted later for edit/delete, since Firestore's
  /// arrayUnion/arrayRemove need an exact-match object to remove an entry.
  Future<void> addReview({
    required String productId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  }) async {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5.');
    }
    if (comment.trim().isEmpty) {
      throw ArgumentError('Comment cannot be empty.');
    }

    final reviewData = {
      'reviewId': DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment.trim(),
      'createdAt': DateTime.now().toIso8601String().split('T').first,
    };

    final docRef = _db.collection('reviews').doc(productId);

    // set with merge:true creates the document if it doesn't exist yet,
    // and arrayUnion appends to the existing `reviews` array otherwise.
    await docRef.set({
      'productId': productId,
      'reviews': FieldValue.arrayUnion([reviewData]),
    }, SetOptions(merge: true));
  }

  /// Checks whether the given user has already reviewed this product.
  /// Use this before showing the "Write a Review" form to either block
  /// a second review or let the user edit their existing one.
  Future<bool> hasUserReviewed({
    required String productId,
    required String userId,
  }) async {
    final doc = await _db.collection('reviews').doc(productId).get();
    if (!doc.exists) return false;

    final data = doc.data();
    final List<dynamic> reviews = data?['reviews'] ?? [];

    return reviews.any((r) => (r as Map<String, dynamic>)['userId'] == userId);
  }

  /// Optional: stream of live rating stats (average + count) for a product.
  /// Useful if you want to compute this in one place instead of duplicating
  /// the fold logic in multiple widgets.
  Stream<ReviewStats> watchReviewStats(String productId) {
    return _db.collection('reviews').doc(productId).snapshots().map((doc) {
      if (!doc.exists) return const ReviewStats(average: 0, count: 0);

      final data = doc.data();
      final List<dynamic> reviews = data?['reviews'] ?? [];

      if (reviews.isEmpty) return const ReviewStats(average: 0, count: 0);

      final total = reviews.fold<double>(0, (sum, r) {
        final rating = (r as Map<String, dynamic>)['rating'] ?? 0;
        return sum + (rating as num).toDouble();
      });

      return ReviewStats(average: total / reviews.length, count: reviews.length);
    });
  }
}

/// Simple value holder for average rating + review count.
class ReviewStats {
  final double average;
  final int count;

  const ReviewStats({required this.average, required this.count});
}