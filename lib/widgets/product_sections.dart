import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../pages/product_details_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'product_card.dart';
import '../pages/see_all_products_screen.dart';

class ProductHorizontalSection extends StatefulWidget {
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
  State<ProductHorizontalSection> createState() => _ProductHorizontalSectionState();
}

class _ProductHorizontalSectionState extends State<ProductHorizontalSection> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  bool _isForward = true;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    if (_timer != null) return;

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted || !_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final minScroll = _scrollController.position.minScrollExtent;
      final currentScroll = _scrollController.offset;

      const scrollStep = 500.0;

      if (_isForward) {
        if (currentScroll < maxScroll) {
          _scrollController.animateTo(
            (currentScroll + scrollStep).clamp(minScroll, maxScroll),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _isForward = false;
        }
      } else {
        if (currentScroll > minScroll) {
          _scrollController.animateTo(
            (currentScroll - scrollStep).clamp(minScroll, maxScroll),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _isForward = true;
        }
      }
    });
  }

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
                widget.title,
                style: AppTextStyles.brandTitle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              TextButton(
                onPressed: widget.onSeeAllPressed ?? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeeAllProductsScreen(
                        categoryTitle: widget.title,
                        categoryKey: widget.categoryFilter,
                      ),
                    ),
                  );
                },
                child: const Text('See All'),
              )
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Firestore Stream
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(AppStrings.productsCollection)
              .where(AppStrings.categoryField, isEqualTo: widget.categoryFilter)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 220,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primaryDark),
                ),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Error loading ${widget.title}',
                  style: const TextStyle(color: AppColors.textDark),
                ),
              );
            }

            final docs = snapshot.data?.docs ?? [];

            if (docs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'No ${widget.title} items found.',
                  style: const TextStyle(color: AppColors.textGrey),
                ),
              );
            }

            return SizedBox(
              height: 225,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final String productId = doc.id;
                  final String name = data[AppStrings.nameField] ?? AppStrings.defaultProductName;
                  final num price = data[AppStrings.priceField] ?? 0;
                  
                  // Support both list array `imageUrls` and legacy single string field
                  final List<dynamic> imageUrlsList = data['imageUrls'] ?? [];
                  final String imageUrl = imageUrlsList.isNotEmpty 
                      ? imageUrlsList.first 
                      : (data[AppStrings.imageUrlField] ?? '');

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