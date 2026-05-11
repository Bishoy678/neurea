// // ignore_for_file: deprecated_member_use
// import 'package:flutter/material.dart';

// const kPurple = Color(0xFF7B2FBE);

// class BreathingExercisesScreen extends StatelessWidget {
//   const BreathingExercisesScreen({super.key});

//   static const List<Map<String, String>> _items = [
//     {
//       'title': 'The 5-Minute Reset | Breathe to Sharpen Your Focus',
//       'desc': 'Pause the noise. Use this guided session to lower your heart rate, clear mental clutter, and return to your task with total clarity.',
//       'image': 'assets/Breasing4.jpeg',
//     },
//     {
//       'title': 'Rhythmic Expansion',
//       'desc': 'A gentle, fluid breathing session designed to help you release physical tension and find your natural internal rhythm.',
//       'image': 'assets/Breasing2.jpeg',
//     },
//     {
//       'title': 'Mindful Architecture',
//       'desc': 'Precise, intentional breathwork aimed at clearing mental fog and building a foundation for deep creative breakthroughs.',
//       'image': 'assets/Breasing3.jpeg',
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
//           'Breathing Exercises',
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
//                     color: const Color(0xFF3D2A05),
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


// // ignore_for_file: deprecated_member_use
// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// const kPurple = Color(0xFF7B2FBE);

// class BreathingExercisesScreen extends StatelessWidget {
//   const BreathingExercisesScreen({super.key});

//   static const List<Map<String, String>> _items = [
//     {
//       'title': 'The 5-Minute Reset | Breathe to Sharpen Your Focus',
//       'desc': 'Pause the noise. Use this guided session to lower your heart rate, clear mental clutter, and return to your task with total clarity.',
//       'image': 'assets/Breasing4.jpeg',
//       'videoId': 'QtltKD73vfI',
//     },
//     {
//       'title': 'Rhythmic Expansion',
//       'desc': 'A gentle, fluid breathing session designed to help you release physical tension and find your natural internal rhythm.',
//       'image': 'assets/Breasing2.jpeg',
//       'videoId': '_1GZAHIVHGk',
//     },
//     {
//       'title': 'Mindful Architecture',
//       'desc': 'Precise, intentional breathwork aimed at clearing mental fog and building a foundation for deep creative breakthroughs.',
//       'image': 'assets/Breasing3.jpeg',
//       'videoId': 'xL6z1-03Gzo',
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
//           'Breathing Exercises',
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
//             videoId: _items[i]['videoId']!,
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
//   final String videoId;

//   const _VideoCard({
//     required this.title,
//     required this.description,
//     required this.image,
//     required this.videoId,
//   });

//   void _openVideoPlayer(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => _VideoPlayerScreen(videoId: videoId, title: title),
//       ),
//     );
//   }

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
//             child: GestureDetector(
//               onTap: () => _openVideoPlayer(context),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Image.asset(
//                     image,
//                     height: 180,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       height: 180,
//                       width: double.infinity,
//                       color: const Color(0xFF3D2A05),
//                       child: const Icon(Icons.self_improvement,
//                           color: Colors.white54, size: 60),
//                     ),
//                   ),
//                   Container(
//                     width: 52,
//                     height: 52,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.9),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.play_arrow,
//                       color: kPurple,
//                       size: 30,
//                     ),
//                   ),
//                 ],
//               ),
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

// class _VideoPlayerScreen extends StatefulWidget {
//   final String videoId;
//   final String title;

//   const _VideoPlayerScreen({required this.videoId, required this.title});

//   @override
//   State<_VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<_VideoPlayerScreen> {
//   late YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: widget.videoId,
//       flags: const YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//         hideControls: false,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           widget.title,
//           style: const TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: kPurple,
//         progressColors: const ProgressBarColors(
//           playedColor: kPurple,
//           handleColor: kPurple,
//         ),
//       ),
//     );
//   }
// }




// // ignore_for_file: deprecated_member_use
// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// const kPurple = Color(0xFF7B2FBE);

// class BreathingExercisesScreen extends StatelessWidget {
//   const BreathingExercisesScreen({super.key});

//   static const List<Map<String, String>> _items = [
//     {
//       'title': 'The 5-Minute Reset | Breathe to Sharpen Your Focus',
//       'desc': 'Pause the noise. Use this guided session to lower your heart rate, clear mental clutter, and return to your task with total clarity.',
//       'image': 'assets/Breasing4.jpeg',
//       'videoId': 'QtltKD73vfI',
//     },
//     {
//       'title': 'Rhythmic Expansion',
//       'desc': 'A gentle, fluid breathing session designed to help you release physical tension and find your natural internal rhythm.',
//       'image': 'assets/Breasing2.jpeg',
//       'videoId': '_1GZAHIVHGk',
//     },
//     {
//       'title': 'Mindful Architecture',
//       'desc': 'Precise, intentional breathwork aimed at clearing mental fog and building a foundation for deep creative breakthroughs.',
//       'image': 'assets/Breasing3.jpeg',
//       'videoId': 'xL6z1-03Gzo',
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
//           'Breathing Exercises',
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
//             videoId: _items[i]['videoId']!,
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
//   final String videoId;

//   const _VideoCard({
//     required this.title,
//     required this.description,
//     required this.image,
//     required this.videoId,
//   });

//   void _openVideoPlayer(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => _VideoPlayerScreen(videoId: videoId, title: title),
//       ),
//     );
//   }

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
//             child: GestureDetector(
//               onTap: () => _openVideoPlayer(context),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Image.asset(
//                     image,
//                     height: 180,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       height: 180,
//                       width: double.infinity,
//                       color: const Color(0xFF3D2A05),
//                       child: const Icon(Icons.self_improvement,
//                           color: Colors.white54, size: 60),
//                     ),
//                   ),
//                   Container(
//                     width: 52,
//                     height: 52,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.9),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.play_arrow,
//                       color: kPurple,
//                       size: 30,
//                     ),
//                   ),
//                 ],
//               ),
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

// class _VideoPlayerScreen extends StatefulWidget {
//   final String videoId;
//   final String title;

//   const _VideoPlayerScreen({required this.videoId, required this.title});

//   @override
//   State<_VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<_VideoPlayerScreen> {
//   late YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: widget.videoId,
//       flags: const YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//         hideControls: false,
//         forceHD: true,
//       ),
//     );
//     // رفع الصوت للأعلى
//     _controller.setVolume(100);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           widget.title,
//           style: const TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // استخدام AspectRatio لتحديد حجم الفيديو بشكل صحيح
//             AspectRatio(
//               aspectRatio: 16 / 9,
//               child: YoutubePlayer(
//                 controller: _controller,
//                 showVideoProgressIndicator: true,
//                 progressIndicatorColor: kPurple,
//                 progressColors: const ProgressBarColors(
//                   playedColor: kPurple,
//                   handleColor: kPurple,
//                 ),
//               ),
//             ),
//             // المساحة المتبقية تعبئها بمعلومات عن التمرين
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.self_improvement,
//                       size: 48,
//                       color: Colors.white.withOpacity(0.5),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       widget.title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'Follow the breathing guidance\nRelax and focus on your breath',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.7),
//                         fontSize: 14,
//                         height: 1.5,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 





// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const kPurple = Color(0xFF7B2FBE);

class BreathingExercisesScreen extends StatelessWidget {
  const BreathingExercisesScreen({super.key});

  static const List<Map<String, String>> _items = [
    {
      'title': 'The 5-Minute Reset | Breathe to Sharpen Your Focus',
      'desc': 'Pause the noise. Use this guided session to lower your heart rate, clear mental clutter, and return to your task with total clarity.',
      'image': 'assets/Breasing4.jpeg',
      'videoId': 'QtltKD73vfI',
    },
    {
      'title': 'Rhythmic Expansion',
      'desc': 'A gentle, fluid breathing session designed to help you release physical tension and find your natural internal rhythm.',
      'image': 'assets/Breasing2.jpeg',
      'videoId': '_1GZAHIVHGk',
    },
    {
      'title': 'Mindful Architecture',
      'desc': 'Precise, intentional breathwork aimed at clearing mental fog and building a foundation for deep creative breakthroughs.',
      'image': 'assets/Breasing3.jpeg',
      'videoId': 'xL6z1-03Gzo',
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
          'Breathing Exercises',
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
                      color: const Color(0xFF3D2A05),
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
                    child: const Icon(
                      Icons.play_arrow,
                      color: kPurple,
                      size: 30,
                    ),
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