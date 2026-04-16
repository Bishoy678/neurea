import 'package:flutter/material.dart';

class ProProfile extends StatelessWidget {
  const ProProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
     body: ScrollConfiguration(
  behavior: const ScrollBehavior().copyWith(overscroll: false),
  child: SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
    child: Column(
          children: [
            SizedBox(height: sw * 0.02),
            Text(
              'Choose Your Plan',
              style: TextStyle(
                fontSize: sw * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: sw * 0.02),
            Text(
              'Find the perfect plan to enjoy extra insights and\nexclusive benefits.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: sw * 0.033, color: Colors.grey),
            ),
            SizedBox(height: sw * 0.06),
            _PlanCard(
              sw: sw,
              title: 'Premium',
              price: '\$80',
              period: 'USD / Year',
              description:
                  'Best for dedicated users seeking unlimited insights and priority access.',
              features: const [
                'Advanced Mood Reports',
                'Unlimited AI Chats',
                'Priority Therapist Booking',
                'Ad-Free Experience',
              ],
              onSubscribe: () {},
            ),
            SizedBox(height: sw * 0.04),
            _PlanCard(
              sw: sw,
              title: 'Standard',
              price: '\$15',
              period: 'USD / Month',
              description:
                  'Great for regular users wanting more features month-to-month.',
              features: const ['Advanced Mood Reports', 'Unlimited AI Chats'],
              onSubscribe: () {},
            ),
            SizedBox(height: sw * 0.08),
          ],
        ),
  ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final double sw;
  final String title, price, period, description;
  final List<String> features;
  final VoidCallback onSubscribe;

  const _PlanCard({
    required this.sw,
    required this.title,
    required this.price,
    required this.period,
    required this.description,
    required this.features,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(sw * 0.06),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: sw * 0.055, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: sw * 0.01),
          Text(
            price,
            style: TextStyle(fontSize: sw * 0.09, fontWeight: FontWeight.bold),
          ),
          Text(
            period,
            style: TextStyle(fontSize: sw * 0.033, color: Colors.grey),
          ),
          SizedBox(height: sw * 0.03),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: sw * 0.033, color: Colors.grey),
          ),
          SizedBox(height: sw * 0.04),
          ...features.map(
            (f) => Padding(
              padding: EdgeInsets.only(bottom: sw * 0.025),
              child: Row(
                children: [
                  Container(
                    width: sw * 0.055,
                    height: sw * 0.055,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5C2D91),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: sw * 0.035,
                    ),
                  ),
                  SizedBox(width: sw * 0.025),
                  Text(
                    f,
                    style: TextStyle(
                      fontSize: sw * 0.035,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: sw * 0.05),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C2D91),
                padding: EdgeInsets.symmetric(vertical: sw * 0.04),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'Subscribe Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: sw * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
