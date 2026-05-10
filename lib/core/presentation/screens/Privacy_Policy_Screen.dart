// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final List<Map<String, dynamic>> _policies = [
    {
      'asset': 'assets/AI Therapist Chats_privacy.png',
      'title': 'AI Therapist Chats',
      'content':
          'Every conversation you have with our AI Therapist is completely anonymous and encrypted. We do not use your personal chats to train public AI models. Your thoughts are processed securely and deleted from active servers once your session ends.',
      'expanded': false,
    },
    {
      'asset': 'assets/Advanced Data Protection_privacy.png',
      'title': 'Advanced Data Protection',
      'content':
          'Your data is accessible only to you and your therapist, and is protected by an emergency "kill switch" that instantly deletes your records during a cyberattack to guarantee they are never stolen.',
      'expanded': false,
    },
    {
      'asset': 'assets/Emergency Disclaimer-privacy.png',
      'title': 'Emergency Disclaimer',
      'content':
          'Neurea provides de-escalation support and emergency alerts but is not legally liable for self-harm; users are strictly responsible for providing accurate emergency contacts and should always dial 911 in life-threatening situations.',
      'expanded': false,
    },
    {
      'asset': 'assets/PrivacyPolicyScreen3.png',
      'title': 'Therapy Sessions',
      'content':
          'Chats, Video and audio calls with professional therapists are strictly confidential under doctor-patient privilege (HIPAA compliant). Sessions are never recorded unless explicitly requested by you for your own records.',
      'expanded': false,
    },
    {
      'asset': 'assets/Zero Data Selling_privacy.png',
      'title': 'Zero Data Selling',
      'content':
          'We have a strict Zero Data Selling policy. We make our revenue through Neurea Pro subscriptions and therapist booking fees, not by monetizing your vulnerability. Your data will never be shared with advertisers or insurance companies without your consent.',
      'expanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: sw * 0.05,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy & Policy',
          style: TextStyle(
            color: const Color(0xFF5C2D91),
            fontSize: sw * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(sw * 0.05),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(sw * 0.06),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: sw * 0.16,
                              height: sw * 0.16,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3EDF7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/logo_privacy.png',
                                  width: sw * 0.16,
                                  height: sw * 0.16,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.shield_outlined,
                                    color: const Color(0xFF5C2D91),
                                    size: sw * 0.08,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: sw * 0.04),
                            Text(
                              'Your Safe Space',
                              style: TextStyle(
                                fontSize: sw * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: sw * 0.02),
                            Text(
                              'At Neurea, your mental health journey is strictly private. We use bank-level encryption to ensure your data stays yours.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: sw * 0.033,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: sw * 0.04),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: sw * 0.04,
                                vertical: sw * 0.02,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lock_outline,
                                    size: sw * 0.035,
                                    color: Colors.grey.shade500,
                                  ),
                                  SizedBox(width: sw * 0.015),
                                  Text(
                                    'Messages are end-to-end encrypted.',
                                    style: TextStyle(
                                      fontSize: sw * 0.028,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: sw * 0.05),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Policy Details',
                          style: TextStyle(
                            fontSize: sw * 0.033,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: sw * 0.025),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: List.generate(_policies.length, (i) {
                            final item = _policies[i];
                            return Column(
                              children: [
                                ListTile(
                                  leading: Container(
                                    width: sw * 0.09,
                                    height: sw * 0.09,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3EDF7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(sw * 0.015),
                                      child: Image.asset(
                                        item['asset'] as String,
                                        color: const Color(0xFF5C2D91),
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.policy_outlined,
                                          color: const Color(0xFF5C2D91),
                                          size: sw * 0.045,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontSize: sw * 0.035,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: Icon(
                                    item['expanded']
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                  onTap: () => setState(
                                    () => _policies[i]['expanded'] =
                                        !item['expanded'],
                                  ),
                                ),
                                if (item['expanded'])
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: sw * 0.04,
                                      right: sw * 0.04,
                                      bottom: sw * 0.03,
                                    ),
                                    child: Text(
                                      item['content'],
                                      style: TextStyle(
                                        fontSize: sw * 0.03,
                                        color: Colors.grey,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                if (i < _policies.length - 1)
                                  Divider(
                                    height: 1,
                                    indent: sw * 0.04,
                                    endIndent: sw * 0.04,
                                    color: Colors.grey.shade100,
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: sw * 0.04),
            SizedBox(
              width: double.infinity,
              height: sw * 0.14,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C2D91),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'I Understand & Agree',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: sw * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: sw * 0.025),
          ],
        ),
      ),
    );
  }
}