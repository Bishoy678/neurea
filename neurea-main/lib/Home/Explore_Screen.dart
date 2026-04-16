// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static const _items = [
    _ExploreItem(
      title: 'Breathing Exercises',
      subtitle: 'Calm your mind and reduce stress.',
      asset: 'assets/Explore1.png',
    ),
    _ExploreItem(
      title: 'Focusing',
      subtitle: 'Improve clarity and concentration.',
      asset: 'assets/Explore2.png',
    ),
    _ExploreItem(
      title: 'Mini Games',
      subtitle: 'Relax with engaging brain puzzles.',
      asset: 'assets/Explore3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC),
      appBar: _ExploreAppBar(canPop: Navigator.canPop(context)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final hPad = constraints.maxWidth * 0.04;
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 24),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _ExploreCard(item: _items[i]),
            ),
          );
        },
      ),
    );
  }
}

class _ExploreAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool canPop;
  const _ExploreAppBar({required this.canPop});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: canPop
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: const Text(
        'Explore',
        style: TextStyle(
          color: Color(0xFF7A2BAF),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}

class _ExploreItem {
  final String title;
  final String subtitle;
  final String asset;

  const _ExploreItem({
    required this.title,
    required this.subtitle,
    required this.asset,
  });
}

class _ExploreCard extends StatelessWidget {
  final _ExploreItem item;
  const _ExploreCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final imgSize = w * 0.25;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ItemImage(asset: item.asset, size: imgSize),
              const SizedBox(width: 14),
              Expanded(
                child: _ItemText(title: item.title, subtitle: item.subtitle),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _StartButton(onPressed: () {}),
        ],
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  final String asset;
  final double size;

  const _ItemImage({required this.asset, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: size,
        height: size,
        color: const Color(0xFFF3EDF7),
        child: const Icon(
          Icons.self_improvement_rounded,
          color: Color(0xFF7A2BAF),
          size: 50,
        ),
      ),
    );
  }
}

class _ItemText extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ItemText({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xE04D5D64),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xE04D5D64),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _StartButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _StartButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5C2D91),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Start Exercise',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}