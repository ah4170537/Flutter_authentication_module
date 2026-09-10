import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'product_details_screen.dart';

class SeeAllProductsScreen extends StatelessWidget {
  final String categoryTitle;
  final String categoryKey;

  const SeeAllProductsScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textDark,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryTitle,
          style: AppTextStyles.brandTitle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(AppStrings.productsCollection)
            .where(AppStrings.categoryField, isEqualTo: categoryKey)
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
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Something went wrong: ${snapshot.error}',
                  style: const TextStyle(color: AppColors.textGrey),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: AppColors.textGrey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No products found in this category',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final String productId = doc.id;
              final String name =
                  data[AppStrings.nameField] ?? AppStrings.defaultProductName;
              final num price = data[AppStrings.priceField] ?? 0;
          
              final List<dynamic> imageUrlsList = data['imageUrls'] ?? [];
              final String imageUrl = imageUrlsList.isNotEmpty
                  ? imageUrlsList.first
                  : (data[AppStrings.imageUrlField] ?? '');

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailsScreen(productId: productId),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(color: AppColors.hintGrey),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: AppColors.hintGrey,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Product Info
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTextStyles.productName.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${AppStrings.currencyPrefix}$price',
                              style: AppTextStyles.productPrice.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
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
          );
        },
      ),
    );
  }
}
