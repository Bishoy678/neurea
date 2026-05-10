// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmergencyContactProfile extends StatefulWidget {
  const EmergencyContactProfile({super.key});

  @override
  State<EmergencyContactProfile> createState() =>
      _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactProfile> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadPhone();
  }

  Future<void> _loadPhone() async {
    setState(() => _isLoading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;
      
      
      final result = await Supabase.instance.client
          .from('emergency_contacts')
          .select('phone')
          .eq('user_id', userId)
          .maybeSingle();
      
      if (result != null && result['phone'] != null && result['phone'].toString().isNotEmpty) {
    
        _phoneController.text = result['phone'];
      } else {
      
        final profileResult = await Supabase.instance.client
            .from('profiles')
            .select('phone')
            .eq('id', userId)
            .maybeSingle();
        
        if (profileResult != null && profileResult['phone'] != null) {
          _phoneController.text = profileResult['phone'];
        }
      }
    } catch (e) {
      print('Error loading phone: $e');
    }
    setState(() => _isLoading = false);
  }

  bool _isValidPhone(String phone) {

    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-]'), '');
 
    final regex = RegExp(r'^\d{10,11}$');
    return regex.hasMatch(cleanPhone);
  }

  Future<void> _saveUpdates() async {
    final phone = _phoneController.text.trim();
    
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (!_isValidPhone(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid phone number (10-11 digits only)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() => _isSaving = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;
      
      final existing = await Supabase.instance.client
          .from('emergency_contacts')
          .select('user_id')
          .eq('user_id', userId)
          .maybeSingle();
      
      if (existing != null) {

        await Supabase.instance.client
            .from('emergency_contacts')
            .update({'phone': phone})
            .eq('user_id', userId);
      } else {
    
        await Supabase.instance.client.from('emergency_contacts').insert({
          'user_id': userId,
          'phone': phone,
        });
      }
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Emergency contact updated! ✅'),
          backgroundColor: Color(0xFF5C2D91),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
    setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
          'Emergency Contact',
          style: TextStyle(
            color: const Color(0xFF5C2D91),
            fontSize: sw * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF5C2D91)),
            )
          : Padding(
              padding: EdgeInsets.all(sw * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Container(
                    padding: EdgeInsets.all(sw * 0.04),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EDF7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(sw * 0.025),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.notifications_active_outlined,
                            color: const Color(0xFF5C2D91),
                            size: sw * 0.06,
                          ),
                        ),
                        SizedBox(width: sw * 0.035),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Crisis Mode SOS',
                                style: TextStyle(
                                  fontSize: sw * 0.038,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: sw * 0.015),
                              Text(
                                'If you trigger a crisis alert, we will immediately send an automated SMS to this number to ensure you get help fast.',
                                style: TextStyle(
                                  fontSize: sw * 0.03,
                                  color: Colors.grey,
                                  height: 1.5,
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
                    'Emergency Phone Number',
                    style: TextStyle(
                      fontSize: sw * 0.035,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: sw * 0.025),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      decoration: InputDecoration(
                        hintText: '01012345678',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        counterText: '',
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: Colors.grey.shade400,
                          size: sw * 0.05,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: sw * 0.04,
                          vertical: sw * 0.035,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  SizedBox(height: sw * 0.02),
                  Text(
                    'Enter 10-11 digits only (e.g., 01012345678)',
                    style: TextStyle(fontSize: sw * 0.03, color: Colors.grey),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: sw * 0.14,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveUpdates,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C2D91),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Save Updates',
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
