import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('Connecting to Firestore to save reviews with respective product IDs...');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Unique reviews mapped directly to each product ID
  final Map<String, List<Map<String, dynamic>>> productReviews = {
    'prod-001': [
      {
        'userName': 'Hamza Tariq',
        'rating': 5,
        'comment': 'The active noise cancellation on these wireless headphones is incredible for daily commutes.',
        'createdAt': '2026-06-10',
      },
      {
        'userName': 'Sana Javed',
        'rating': 4,
        'comment': 'Very comfortable for long hours of listening, battery life holds up well.',
        'createdAt': '2026-06-11',
      },
      {
        'userName': 'Bilal Raza',
        'rating': 5,
        'comment': 'Clean crisp sound and deep bass. Worth every rupee.',
        'createdAt': '2026-06-12',
      },
      {
        'userName': 'Mariam Noor',
        'rating': 4,
        'comment': 'Good build quality, though the carrying case could be slightly more compact.',
        'createdAt': '2026-06-14',
      },
      {
        'userName': 'Zubair Ahmed',
        'rating': 5,
        'comment': 'Seamless Bluetooth pairing and great microphone clarity during calls.',
        'createdAt': '2026-06-15',
      },
    ],
    'prod-005': [
      {
        'userName': 'Farhan Akram',
        'rating': 5,
        'comment': 'The 4K video recording and 24.2 MP sensor deliver stunning professional details.',
        'createdAt': '2026-06-05',
      },
      {
        'userName': 'Nida Yasir',
        'rating': 5,
        'comment': 'An absolute powerhouse for photography enthusiasts. The kit lens is versatile.',
        'createdAt': '2026-06-08',
      },
      {
        'userName': 'Danish Ali',
        'rating': 4,
        'comment': 'Takes sharp images in low light. Menu interface takes a little time to master.',
        'createdAt': '2026-06-10',
      },
      {
        'userName': 'Hassan Malik',
        'rating': 5,
        'comment': 'Superb autofocus tracking and incredible battery performance on long shoots.',
        'createdAt': '2026-06-12',
      },
      {
        'userName': 'Ayesha Siddique',
        'rating': 4,
        'comment': 'Slightly heavy to carry all day, but the photo quality completely makes up for it.',
        'createdAt': '2026-06-15',
      },
    ],
    'prod-009': [
      {
        'userName': 'Usman Ghani',
        'rating': 5,
        'comment': 'Extremely fast performance, 16GB RAM handles heavy coding environments effortlessly.',
        'createdAt': '2026-06-01',
      },
      {
        'userName': 'Rabia Basri',
        'rating': 5,
        'comment': 'The ultra-slim design makes it super lightweight and easy to slip into a backpack.',
        'createdAt': '2026-06-03',
      },
      {
        'userName': 'Kashif Mehmood',
        'rating': 4,
        'comment': 'Crisp display resolution and fast boot times thanks to the 512GB SSD.',
        'createdAt': '2026-06-07',
      },
      {
        'userName': 'Sidra Tul Muntaha',
        'rating': 4,
        'comment': 'Fans can get a bit loud under heavy multi-tasking loads, but otherwise brilliant.',
        'createdAt': '2026-06-11',
      },
      {
        'userName': 'Waqas Shafique',
        'rating': 5,
        'comment': 'Phenomenal battery life for an ultra-book. Highly recommend for students and pros.',
        'createdAt': '2026-06-14',
      },
    ],
    'prod-014': [
      {
        'userName': 'Taha Hussain',
        'rating': 5,
        'comment': 'Flat response and incredible audio separation. Ideal for studio mixing.',
        'createdAt': '2026-06-04',
      },
      {
        'userName': 'Mehwish Hayat',
        'rating': 5,
        'comment': 'Super comfortable ear cushions and sturdy build for long studio sessions.',
        'createdAt': '2026-06-06',
      },
      {
        'userName': 'Adnan Siddiqui',
        'rating': 4,
        'comment': 'Great reference headphones, though the cable is a bit too long for casual use.',
        'createdAt': '2026-06-09',
      },
      {
        'userName': 'Nimra Khan',
        'rating': 5,
        'comment': 'Every subtle frequency nuance is clearly audible. Worth every penny.',
        'createdAt': '2026-06-12',
      },
      {
        'userName': 'Saad Riaz',
        'rating': 4,
        'comment': 'Solid professional gear that delivers accurate acoustic sound monitoring.',
        'createdAt': '2026-06-16',
      },
    ],
    'prod-002': [
      {
        'userName': 'Zainab Qureshi',
        'rating': 5,
        'comment': 'The AMOLED display is breathtakingly bright and clear even under direct sunlight.',
        'createdAt': '2026-06-02',
      },
      {
        'userName': 'Ali Raza',
        'rating': 4,
        'comment': 'Accurate fitness tracking and heart rate monitor. Battery easily lasts 2 days.',
        'createdAt': '2026-06-05',
      },
      {
        'userName': 'Hira Mani',
        'rating': 5,
        'comment': 'Loved the interchangeable watch straps and smooth software navigation.',
        'createdAt': '2026-06-09',
      },
      {
        'userName': 'Umer Akmal',
        'rating': 4,
        'comment': 'Notification sync is instant. Step counter is reliable compared to others.',
        'createdAt': '2026-06-13',
      },
      {
        'userName': 'Kiran Naz',
        'rating': 5,
        'comment': 'Fantastic value for a smart fitness watch packed with features.',
        'createdAt': '2026-06-17',
      },
    ],
    'prod-003': [
      {
        'userName': 'Shoaib Malik',
        'rating': 5,
        'comment': 'Incredibly lightweight and bouncy foam sole. Perfect for morning running routines.',
        'createdAt': '2026-06-06',
      },
      {
        'userName': 'Sania Mirza',
        'rating': 5,
        'comment': 'Breathable mesh keeps feet cool during intense workouts. True to size fit.',
        'createdAt': '2026-06-08',
      },
      {
        'userName': 'Imran Khan',
        'rating': 4,
        'comment': 'Stylish sneaker design that works well both for gym and casual wear.',
        'createdAt': '2026-06-11',
      },
      {
        'userName': 'Fizza Ali',
        'rating': 4,
        'comment': 'Good ankle support and grip on wet asphalt surfaces.',
        'createdAt': '2026-06-14',
      },
      {
        'userName': 'Kamran Akmal',
        'rating': 5,
        'comment': 'Durable build quality. Even after heavy mileage, cushioning feels fresh.',
        'createdAt': '2026-06-18',
      },
    ],
    'prod-007': [
      {
        'userName': 'Daniyal Zafar',
        'rating': 5,
        'comment': 'The 7.1 surround sound gives a huge competitive advantage in tactical shooters.',
        'createdAt': '2026-06-03',
      },
      {
        'userName': 'Mahira Khan',
        'rating': 4,
        'comment': 'Microphone clarity is crystal clean with zero background static hum.',
        'createdAt': '2026-06-07',
      },
      {
        'userName': 'Faizan Sheikh',
        'rating': 5,
        'comment': 'RGB lighting looks awesome and the ear cups fit very plush and soft.',
        'createdAt': '2026-06-10',
      },
      {
        'userName': 'Anum Fayyaz',
        'rating': 4,
        'comment': 'A bit bulky for travel, but top tier for home gaming setups.',
        'createdAt': '2026-06-15',
      },
      {
        'userName': 'Shehryar Munawar',
        'rating': 5,
        'comment': 'Long braided cable prevents tangling easily. Exceptional sound isolation.',
        'createdAt': '2026-06-19',
      },
    ],
    'prod-011': [
      {
        'userName': 'Momina Mustehsan',
        'rating': 5,
        'comment': 'Captivating long-lasting fragrance that draws compliments all day long.',
        'createdAt': '2026-06-01',
      },
      {
        'userName': 'Asim Azhar',
        'rating': 5,
        'comment': 'Woody and floral notes blend together perfectly. Premium glass bottle design.',
        'createdAt': '2026-06-04',
      },
      {
        'userName': 'Yumna Zaidi',
        'rating': 4,
        'comment': 'Strong projection during the first few hours. Scent profile is very elegant.',
        'createdAt': '2026-06-08',
      },
      {
        'userName': 'Bilal Abbas',
        'rating': 5,
        'comment': 'Stays on clothes even after washing. Definitely worth the luxury tag.',
        'createdAt': '2026-06-12',
      },
      {
        'userName': 'Hania Amir',
        'rating': 4,
        'comment': 'A bit pricey, but the scent longevity is unmatched by other brands.',
        'createdAt': '2026-06-16',
      },
    ],
    'prod-004': [
      {
        'userName': 'Javeria Saud',
        'rating': 5,
        'comment': 'Genuine formal leather shoes with exceptional polish finish and comfort.',
        'createdAt': '2026-06-05',
      },
      {
        'userName': 'Saud Qasmi',
        'rating': 4,
        'comment': 'Took a day or two to break in, but now extremely comfortable for office wear.',
        'createdAt': '2026-06-09',
      },
      {
        'userName': 'Bushra Ansari',
        'rating': 5,
        'comment': 'Classy stitching and durable outer sole. Looks very premium.',
        'createdAt': '2026-06-13',
      },
      {
        'userName': 'Noman Ijaz',
        'rating': 4,
        'comment': 'Great formal styling that pairs wonderfully with tailored suits.',
        'createdAt': '2026-06-16',
      },
      {
        'userName': 'Saba Qamar',
        'rating': 5,
        'comment': 'Exquisite quality leather that maintains its shine with minimal upkeep.',
        'createdAt': '2026-06-20',
      },
    ],
    'prod-006': [
      {
        'userName': 'Fawad Khan',
        'rating': 5,
        'comment': 'Polarized lenses cut harsh glare completely while driving in bright sunlight.',
        'createdAt': '2026-06-02',
      },
      {
        'userName': 'Mahnoor Baloch',
        'rating': 5,
        'comment': 'Timeless aviator frame style. Lightweight and comfortable on the nose bridge.',
        'createdAt': '2026-06-06',
      },
      {
        'userName': 'Mikaal Zulfiqar',
        'rating': 4,
        'comment': 'Comes with a sturdy hard case and cleaning cloth. Great build.',
        'createdAt': '2026-06-10',
      },
      {
        'userName': 'Armeena Rana',
        'rating': 4,
        'comment': 'UV400 protection is solid, eyes feel relaxed even during midday outdoors.',
        'createdAt': '2026-06-14',
      },
      {
        'userName': 'Osman Khalid',
        'rating': 5,
        'comment': 'Classic design that never goes out of fashion. Excellent craftsmanship.',
        'createdAt': '2026-06-18',
      },
    ],
    'prod-010': [
      {
        'userName': 'Ahmed Ali Butt',
        'rating': 5,
        'comment': 'Iconic suede low-top design looks super trendy with casual streetwear.',
        'createdAt': '2026-06-04',
      },
      {
        'userName': 'Urwa Hocane',
        'rating': 4,
        'comment': 'Rubber outsole provides great traction. Suede requires careful cleaning though.',
        'createdAt': '2026-06-07',
      },
      {
        'userName': 'Mawra Hocane',
        'rating': 5,
        'comment': 'Super comfortable inner lining for all-day walking around the city.',
        'createdAt': '2026-06-11',
      },
      {
        'userName': 'Farhan Saeed',
        'rating': 4,
        'comment': 'Classic silhouette that matches with almost any casual pair of jeans.',
        'createdAt': '2026-06-15',
      },
      {
        'userName': 'Sohail Ahmed',
        'rating': 5,
        'comment': 'Sturdy build and premium materials make these long-lasting sneakers.',
        'createdAt': '2026-06-19',
      },
    ],
    'prod-012': [
      {
        'userName': 'Noman Ali',
        'rating': 5,
        'comment': 'Solid oak wood texture gives a stunning minimalist aesthetic to the room.',
        'createdAt': '2026-06-01',
      },
      {
        'userName': 'Sanam Saeed',
        'rating': 5,
        'comment': 'Sturdy, well-balanced seating that requires zero assembly out of the box.',
        'createdAt': '2026-06-05',
      },
      {
        'userName': 'Adeel Hussain',
        'rating': 4,
        'comment': 'Smooth polished finish, though it is slightly compact in height.',
        'createdAt': '2026-06-09',
      },
      {
        'userName': 'Amina Sheikh',
        'rating': 4,
        'comment': 'Wonderful wooden decor piece that also doubles up as a handy extra seat.',
        'createdAt': '2026-06-13',
      },
      {
        'userName': 'Zahid Ahmed',
        'rating': 5,
        'comment': 'Exceptional craftsmanship using genuine timber. Highly recommended.',
        'createdAt': '2026-06-17',
      },
    ],
    'prod-013': [
      {
        'userName': 'Ali Zafar',
        'rating': 5,
        'comment': 'Matte black finish looks rugged and sophisticated on the wrist.',
        'createdAt': '2026-06-03',
      },
      {
        'userName': 'Meesha Shafi',
        'rating': 4,
        'comment': 'IP68 waterproof rating handled swimming pool sessions without any issues.',
        'createdAt': '2026-06-08',
      },
      {
        'userName': 'Ali Noor',
        'rating': 5,
        'comment': 'Built-in GPS tracking is accurate for outdoor cycling and running workouts.',
        'createdAt': '2026-06-12',
      },
      {
        'userName': 'Quratulain Baloch',
        'rating': 4,
        'comment': 'App connection is stable, notifications pop up cleanly without delay.',
        'createdAt': '2026-06-16',
      },
      {
        'userName': 'Farhan Akhtar',
        'rating': 5,
        'comment': 'Rugged sport build that feels lightweight yet durable against scratches.',
        'createdAt': '2026-06-20',
      },
    ],
  };

  final WriteBatch batch = firestore.batch();
  int count = 0;

  for (var entry in productReviews.entries) {
    final String productId = entry.key;
    final List<Map<String, dynamic>> reviews = entry.value;

    // Separate 'reviews' collection, but document ID is explicitly the product ID (e.g., prod-001)
    final DocumentReference reviewRef = firestore.collection('reviews').doc(productId);

    batch.set(reviewRef, {
      'productId': productId,
      'reviews': reviews,
    });
    
    count++;
  }

  await batch.commit();
  print('\nSuccessfully saved $count review documents in the "reviews" collection using respective product IDs!');
}