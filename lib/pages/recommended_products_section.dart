import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import 'product_details_screen.dart';
import '../theme/app_colors.dart';

class RecommendedProductsSection extends StatelessWidget {
  final String subCategory;
  final String currentProductId;

  const RecommendedProductsSection({
    super.key,
    required this.subCategory,
    required this.currentProductId,
  });

  @override
  Widget build(BuildContext context) {
    if (subCategory.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Similar Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(AppStrings.productsCollection)
              .where('subCategory', isEqualTo: subCategory)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 50,
                  child: CircularProgressIndicator(color: AppColors.primaryDark),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const SizedBox.shrink();
            }

            // Filter out the current product in Dart to avoid missing index errors
            final docs = snapshot.data!.docs
                .where((doc) => doc.id != currentProductId)
                .toList();

            if (docs.isEmpty) {
              return const SizedBox.shrink();
            }

            return SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final String productId = doc.id;
                  final String name =
                      data[AppStrings.nameField] ?? AppStrings.defaultProductName;
                  final num price = data[AppStrings.priceField] ?? 0;

                  // Safely parse image URLs
                  final List<dynamic> imageUrlsList =
                      (data['imageUrls'] is List) ? data['imageUrls'] : [];
                  final String imageUrl = imageUrlsList.isNotEmpty
                      ? imageUrlsList[0].toString()
                      : (data[AppStrings.imageUrlField]?.toString() ?? '');

                  return GestureDetector(
                    onTap: () {
                      // Navigate to the tapped recommendation's detail screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(productId: productId),
                        ),
                      );
                    },
                    child: Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: AppColors.hintGrey),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.hintGrey,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'PKR $price',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}