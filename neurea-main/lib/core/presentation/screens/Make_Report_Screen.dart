// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';

class MakeReportScreen extends StatefulWidget {
  const MakeReportScreen({super.key});

  @override
  State<MakeReportScreen> createState() => _MakeReportScreenState();
}

class _MakeReportScreenState extends State<MakeReportScreen> {
  String? selectedIssue;
  final _detailsController = TextEditingController();
  bool _isSending = false;

  final List<String> issues = [
    'Therapist No-show',
    'Unprofessional Behavior',
    'Inappropriate Language',
    'Connection/Tech Issues',
    'Other',
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (selectedIssue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an issue'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_detailsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide details'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSending = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report submitted successfully ✅'),
        backgroundColor: Color(0xFF5C2D91),
      ),
    );
    Navigator.pop(context);
  }

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
          'Make a Report',
          style: TextStyle(
            color: const Color(0xFF5C2D91),
            fontSize: sw * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sw * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(sw * 0.04),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(sw * 0.025),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C2D91),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: sw * 0.05,
                    ),
                  ),
                  SizedBox(width: sw * 0.035),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Safe Space',
                          style: TextStyle(
                            fontSize: sw * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: sw * 0.01),
                        Text(
                          'At Neurea, your mental health journey is strictly private. We use bank-level encryption to ensure your data stays yours.',
                          style: TextStyle(
                            fontSize: sw * 0.03,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sw * 0.06),
            Text(
              'What was the primary issue?',
              style: TextStyle(
                fontSize: sw * 0.038,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: sw * 0.03),
            Wrap(
              spacing: sw * 0.02,
              runSpacing: sw * 0.02,
              children: issues.map((issue) {
                final isSelected = selectedIssue == issue;
                return GestureDetector(
                  onTap: () => setState(() => selectedIssue = issue),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.04,
                      vertical: sw * 0.025,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF5C2D91)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF5C2D91)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      issue,
                      style: TextStyle(
                        fontSize: sw * 0.033,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: sw * 0.06),
            Text(
              'Please provide details',
              style: TextStyle(
                fontSize: sw * 0.038,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: sw * 0.03),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _detailsController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Please describe your issue in detail...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: sw * 0.033,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(sw * 0.04),
                ),
              ),
            ),
            SizedBox(height: sw * 0.08),
            SizedBox(
              width: double.infinity,
              height: sw * 0.14,
              child: ElevatedButton(
                onPressed: _isSending ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C2D91),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: _isSending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Submit Report',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: sw * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: sw * 0.05),
          ],
        ),
      ),
    );
  }
}
