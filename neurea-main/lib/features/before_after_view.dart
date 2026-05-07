import 'package:flutter/material.dart';
import 'package:neurea/features/Onboarding_One_View .dart';

class BeforeAfterView extends StatelessWidget {
  const BeforeAfterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Take a step today! Nurture your mind and embrace your growth.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2A2F41),
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 50),
                            padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAEAEA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Before',
                                  style: TextStyle(
                                    color: Color(0xFF2A2F41),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildBeforeItem('Overthinking'),
                                _buildBeforeItem('Feeling drained'),
                                _buildBeforeItem(
                                  'Struggling to focus\nand stay on track',
                                ),
                                _buildBeforeItem('Anxiety and\ndepression'),
                                _buildBeforeItem('Envy other\npeople\'s life'),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Image.asset(
                                    'assets/before_image_view.png',
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -12,
                            right: -12,
                            child: Image.asset(
                              'assets/before_view.png',
                              width: 110,
                              height: 110,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: const Alignment(0, -4.2),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 50),
                            padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9C4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'After',
                                  style: TextStyle(
                                    color: Color(0xFF2A2F41),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildAfterItem('Mental clarity and\npeace'),
                                _buildAfterItem('Sustained energy\nand focus'),
                                _buildAfterItem(
                                  'Healthy and\nproductive habits',
                                ),
                                _buildAfterItem('Mindfulness'),
                                _buildAfterItem('Brand new life'),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Image.asset(
                                    'assets/After_image_view.png',
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -15,
                            right: -10,
                            child: Image.asset(
                              'assets/After_view.png',
                              width: 110,
                              height: 110,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => OnboardingOneView()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A2BAF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Container(
                width: 150,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildBeforeItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'X',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF2A2F41),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAfterItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, color: Colors.green, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF2A2F41),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
