import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 
  await dotenv.load(fileName: ".env");

 
  final String? imgBbApiKey = dotenv.env['IMGBB_API_KEY'];

  if (imgBbApiKey == null || imgBbApiKey.isEmpty) {
    print('Error: IMGBB_API_KEY is missing from the .env file!');
    return;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('Connecting to Firestore...');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference productsRef = firestore.collection('products');

  final List<Map<String, dynamic>> localProducts = [
    // --- FEATURED PRODUCTS ---
    {
      'id': 'prod-001',
      'name': 'Wireless Headphones',
      'description': 'Premium active noise-canceling over-ear headphones.',
      'price': 3000,
      'category': 'featured',
      'localImagePath': 'assets/products/headphones.jpg',
    },
    {
      'id': 'prod-005',
      'name': 'DSLR Digital Camera',
      'description': '4K video recording with 24.2 MP sensor and kit lens.',
      'price': 250000,
      'category': 'featured',
      'localImagePath': 'assets/products/camera.jpg',
    },
    {
      'id': 'prod-009',
      'name': 'Ultra Slim Laptop',
      'description': '14-inch display, 16GB RAM, 512GB SSD high performance.',
      'price': 150000,
      'category': 'featured',
      'localImagePath': 'assets/products/laptop.png',
    },
    {
      'id': 'prod-014',
      'name': 'Studio Monitor Headphones',
      'description': 'Professional audio monitoring headphones for producers.',
      'price': 50000,
      'category': 'featured',
      'localImagePath': 'assets/products/studio_headphones.jpg',
    },

    // --- BEST SELLING PRODUCTS ---
    {
      'id': 'prod-002',
      'name': 'Smart Watch Series 7',
      'description':
          'Fitness tracker with heart rate monitor and AMOLED display.',
      'price': 2000,
      'category': 'best_selling',
      'localImagePath': 'assets/products/smartwatch.jpg',
    },
    {
      'id': 'prod-003',
      'name': 'Nike Air Running Shoes',
      'description': 'Lightweight and breathable athletic running sneakers.',
      'price': 25000,
      'category': 'best_selling',
      'localImagePath': 'assets/products/shoes.jpg',
    },
    {
      'id': 'prod-007',
      'name': 'Pro Gaming Headset',
      'description': '7.1 Surround sound with noise-canceling microphone.',
      'price': 10000,
      'category': 'best_selling',
      'localImagePath': 'assets/products/gaming_headset.jpg',
    },
    {
      'id': 'prod-011',
      'name': 'Luxury EDP Perfume',
      'description': 'Long-lasting floral and woody fragrance 100ml.',
      'price': 9000,
      'category': 'best_selling',
      'localImagePath': 'assets/products/perfume.png',
    },

    // --- POPULAR PRODUCTS ---
    {
      'id': 'prod-004',
      'name': 'Classic Leather Shoes',
      'description': 'Formal genuine leather shoes for men.',
      'price': 8000,
      'category': 'popular',
      'localImagePath': 'assets/products/leather_shoes.jpg',
    },
    {
      'id': 'prod-006',
      'name': 'Classic Aviator Sunglasses',
      'description': 'UV400 protection polarized lenses with metal frame.',
      'price': 4000,
      'category': 'popular',
      'localImagePath': 'assets/products/sunglasses.jpg',
    },
    {
      'id': 'prod-010',
      'name': 'Puma Classic Sneakers',
      'description': 'Iconic suede low-top sneakers with durable rubber outsole.',
      'price': 14000,
      'category': 'popular',
      'localImagePath': 'assets/products/puma_sneakers.jpg',
    },
    {
      'id': 'prod-012',
      'name': 'Minimalist Wooden Stool',
      'description': 'Solid oak wood aesthetic seating for modern home decor.',
      'price': 7000,
      'category': 'popular',
      'localImagePath': 'assets/products/wooden_stool.jpg',
    },
    {
      'id': 'prod-013',
      'name': 'Sport Smartwatch Matte Black',
      'description': 'Waterproof IP68 watch with GPS tracking.',
      'price': 11000,
      'category': 'popular',
      'localImagePath': 'assets/products/black_watch.jpg',
    },
  ];

  final WriteBatch batch = firestore.batch();
  int newProductsCount = 0;

  for (var product in localProducts) {
    final String docId = product['id'];
    final DocumentReference docRef = productsRef.doc(docId);

    // 1. Check if the product document ID already exists in Firestore
    final DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      print('Skipping "${product['name']}" (ID: $docId) — Already exists in database.');
      continue; // Skip image upload and doc creation entirely
    }

    // 2. Upload image to ImgBB only for new products
    print('New product detected: "${product['name']}" (ID: $docId). Uploading image...');
    final String? imageUrl = await uploadAssetToImgBB(product['localImagePath'], imgBbApiKey);

    if (imageUrl != null) {
      batch.set(docRef, {
        'id': docId,
        'name': product['name'],
        'description': product['description'],
        'price': product['price'],
        'category': product['category'],
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      newProductsCount++;
    } else {
      print('Failed to upload image for "${product['name']}". Skipping...');
    }
  }

  if (newProductsCount > 0) {
    await batch.commit();
    print('\nSync complete! Added $newProductsCount new product(s) to Firestore.');
  } else {
    print('\nNo new products to add. Everything is up to date!');
  }
}

/// Reads asset bundle bytes and uploads to ImgBB
Future<String?> uploadAssetToImgBB(String assetPath, String apiKey) async {
  try {
    final ByteData byteData = await rootBundle.load(assetPath);
    final Uint8List imageBytes = byteData.buffer.asUint8List();
    final String base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey'),
      body: {'image': base64Image},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['url'];
    } else {
      print('ImgBB API Error: ${response.body}');
    }
  } catch (e) {
    print('Exception during asset upload ($assetPath): $e');
  }
  return null;
}