// // ignore_for_file: deprecated_member_use
// import 'package:flutter/material.dart';

// const kPurple = Color(0xFF7B2FBE);

// class FocusingScreen extends StatelessWidget {
//   const FocusingScreen({super.key});

//   static const List<Map<String, String>> _items = [
//     {
//       'title': 'Restorative Stillness',
//       'desc': 'A gentle soundscape designed to lower cortisol and clear mental clutter through total relaxation.',
//       'image': 'assets/focusing1.jpeg',
//     },
//     {
//       'title': 'Zen Productivity',
//       'desc': 'Use this guided session to bridge the gap between mindfulness and high-level cognitive performance.',
//       'image': 'assets/focusing2.jpeg',
//     },
//     {
//       'title': 'Laser-Point Precision',
//       'desc': 'An abstract audio journey that helps you filter out distractions and channel your energy into a single point of focus.',
//       'image': 'assets/focusing3.jpeg',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8F8),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Focusing',
//           style: TextStyle(
//             color: kPurple,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
//           onPressed: () => Navigator.maybePop(context),
//         ),
//       ),
//       body: ScrollConfiguration(
//         behavior: const ScrollBehavior().copyWith(overscroll: false),
//         child: ListView.separated(
//           padding: const EdgeInsets.all(16),
//           itemCount: _items.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 16),
//           itemBuilder: (context, i) => _VideoCard(
//             title: _items[i]['title']!,
//             description: _items[i]['desc']!,
//             image: _items[i]['image']!,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _VideoCard extends StatelessWidget {
//   final String title;
//   final String description;
//   final String image;

//   const _VideoCard({
//     required this.title,
//     required this.description,
//     required this.image,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Image.asset(
//                   image,
//                   height: 180,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     height: 180,
//                     width: double.infinity,
//                     color: const Color(0xFF5D4037),
//                     child: const Icon(Icons.self_improvement,
//                         color: Colors.white54, size: 60),
//                   ),
//                 ),
//                 Container(
//                   width: 52,
//                   height: 52,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.9),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.play_arrow, color: kPurple, size: 30),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey[600],
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// } 




// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const kPurple = Color(0xFF7B2FBE);

class FocusingScreen extends StatelessWidget {
  const FocusingScreen({super.key});

  static const List<Map<String, String>> _items = [
    {
      'title': 'Restorative Stillness',
      'desc': 'A gentle soundscape designed to lower cortisol and clear mental clutter through total relaxation.',
      'image': 'assets/focusing1.jpeg',
      'videoId': 'w1Twc5oT8CY',
    },
    {
      'title': 'Zen Productivity',
      'desc': 'Use this guided session to bridge the gap between mindfulness and high-level cognitive performance.',
      'image': 'assets/focusing2.jpeg',
      'videoId': 'ZToicYcHIOU',
    },
    {
      'title': 'Laser-Point Precision',
      'desc': 'An abstract audio journey that helps you filter out distractions and channel your energy into a single point of focus.',
      'image': 'assets/focusing3.jpeg',
      'videoId': '7EGWrRC0ljU',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Focusing',
          style: TextStyle(
            color: kPurple,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) => _VideoCard(
            title: _items[i]['title']!,
            description: _items[i]['desc']!,
            image: _items[i]['image']!,
            videoId: _items[i]['videoId']!,
          ),
        ),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String videoId;

  const _VideoCard({
    required this.title,
    required this.description,
    required this.image,
    required this.videoId,
  });

  Future<void> _openYoutube() async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: GestureDetector(
              onTap: _openYoutube,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      width: double.infinity,
                      color: const Color(0xFF5D4037),
                      child: const Icon(Icons.self_improvement,
                          color: Colors.white54, size: 60),
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: kPurple, size: 30),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}