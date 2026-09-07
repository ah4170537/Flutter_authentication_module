import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../pages/product_details_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'product_card.dart';

// Generic Horizontal Carousel Builder
class ProductHorizontalSection extends StatelessWidget {
  final String title;
  final String categoryFilter;
  final VoidCallback? onSeeAllPressed;

  const ProductHorizontalSection({
    super.key,
    required this.title,
    required this.categoryFilter,
    this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.brandTitle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              TextButton(
                onPressed: onSeeAllPressed ?? () {},
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Firestore Stream
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(AppStrings.productsCollection)
              .where(AppStrings.categoryField, isEqualTo: categoryFilter)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 170,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primaryDark),
                ),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Error loading $title',
                  style: const TextStyle(color: AppColors.textDark),
                ),
              );
            }

            final docs = snapshot.data?.docs ?? [];

            if (docs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'No $title items found.',
                  style: const TextStyle(color: AppColors.textGrey),
                ),
              );
            }

            return SizedBox(
              height: 175,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final String productId = doc.id;
                  final String name = data[AppStrings.nameField] ?? AppStrings.defaultProductName;
                  final num price = data[AppStrings.priceField] ?? 0;
                  final String imageUrl = data[AppStrings.imageUrlField] ?? '';

                  return ProductCard(
                    name: name,
                    price: price,
                    imageUrl: imageUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(
                            productId: productId,
                          ),
                        ),
                      );
                    },
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

// Dedicated Popular Section
class PopularProductsSection extends StatelessWidget {
  const PopularProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductHorizontalSection(
      title: 'Popular Items',
      categoryFilter: 'popular',
    );
  }
}

// Dedicated Best Selling Section
class BestSellingProductsSection extends StatelessWidget {
  const BestSellingProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductHorizontalSection(
      title: 'Best Selling',
      categoryFilter: 'best_selling',
    );
  }
}