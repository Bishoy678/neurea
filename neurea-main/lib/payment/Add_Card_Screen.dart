// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neurea/payment/Payment_Success_Screen.dart';

class AddCardScreen extends StatefulWidget {
  final String therapistName;
  final String therapistImage;
  final String specialty;
  final String appointmentDay;
  final String appointmentDate;
  final String appointmentTime;

  const AddCardScreen({
    super.key,
    required this.therapistName,
    required this.therapistImage,
    required this.specialty,
    required this.appointmentDay,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  bool saveInfo = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  String? _cardNumberError;
  String? _expiryError;
  String? _cvcError;

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _cardNumberController.text.replaceAll(' ', '').length == 16 &&
        _expiryController.text.length == 5 &&
        _cvcController.text.length == 3 &&
        _cardNumberError == null &&
        _expiryError == null &&
        _cvcError == null;
  }

  String get cardHolderDisplay =>
      _nameController.text.isEmpty ? 'YOUR NAME' : _nameController.text;

  String get cardNumberDisplay {
    final text = _cardNumberController.text.replaceAll(' ', '');
    if (text.isEmpty) return 'XXXX  XXXX  XXXX  XXXX';
    final padded = text.padRight(16, 'X');
    return '${padded.substring(0, 4)}  ${padded.substring(4, 8)}  ${padded.substring(8, 12)}  ${padded.substring(12, 16)}';
  }

  String get expiryDisplay =>
      _expiryController.text.isEmpty ? 'MM/YY' : _expiryController.text;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _cardNumberController.addListener(() {
      setState(() => _validateCardNumber(_cardNumberController.text));
    });
    _expiryController.addListener(() {
      setState(() => _formatAndValidateExpiry(_expiryController.text));
    });
    _cvcController.addListener(() {
      setState(() => _validateCvc(_cvcController.text));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  void _validateCardNumber(String value) {
    final digits = value.replaceAll(' ', '');
    if (digits.isEmpty) {
      _cardNumberError = null;
    } else if (digits.length < 16)
      _cardNumberError = 'Card number must be 16 digits';
    else
      _cardNumberError = null;
  }

  void _formatAndValidateExpiry(String value) {
    String digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 4) digits = digits.substring(0, 4);
    
    if (digits.length >= 2) {
      final formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
      if (_expiryController.text != formatted) {
        _expiryController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }
    
    final currentText = _expiryController.text;
    if (currentText.isEmpty) {
      _expiryError = null;
    } else if (currentText.length < 5) {
      _expiryError = 'Complete MM/YY';
    } else if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(currentText)) {
      _expiryError = 'Invalid format. Use MM/YY';
    } else {
      final month = int.tryParse(currentText.split('/')[0]) ?? 0;
      final year = int.tryParse(currentText.split('/')[1]) ?? 0;
      if (month < 1 || month > 12) {
        _expiryError = 'Month must be 01–12';
      } else if (year < 24 || year > 35) {
        _expiryError = 'Year must be 24-35';
      } else {
        _expiryError = null;
      }
    }
  }

  void _validateCvc(String value) {
    if (value.isEmpty) {
      _cvcError = null;
    } else if (value.length < 3)
      _cvcError = 'CVC must be 3 digits';
    else if (value.length > 3)
      _cvcError = 'CVC must be 3 digits only';
    else
      _cvcError = null;
  }

  void _onAddCard() {
    if (!_isFormValid) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(
          therapistName: widget.therapistName,
          therapistImage: widget.therapistImage,
          specialty: widget.specialty,
          appointmentDay: widget.appointmentDay,
          appointmentDate: widget.appointmentDate,
          appointmentTime: widget.appointmentTime,
        ),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Add New Card',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      // ✅ التعديل: إضافة ScrollConfiguration لمنع الـ overscroll
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildCreditCard(),
              const SizedBox(height: 24),
              _buildLabel('Cardholder Name'),
              const SizedBox(height: 8),
              _buildTextField(_nameController, 'E.G. Bishoy K'),
              const SizedBox(height: 16),
              _buildLabel('Card Number'),
              const SizedBox(height: 8),
              _buildTextField(
                _cardNumberController,
                '0000 0000 0000 0000',
                keyboardType: TextInputType.number,
                maxLength: 19,
                errorText: _cardNumberError,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Expiry Date'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          _expiryController,
                          'MM/YY',
                          maxLength: 5,
                          errorText: _expiryError,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d/]')),
                            LengthLimitingTextInputFormatter(5),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('CVC'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          _cvcController,
                          '•••',
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          errorText: _cvcError,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: saveInfo,
                    onChanged: (val) => setState(() => saveInfo = val ?? false),
                    activeColor: const Color(0xFF5C2D91),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Text(
                    'Save my information',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _onAddCard : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C2D91),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add Card',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreditCard() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1035), Color(0xFF2D1B69)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'VISA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 2,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cardNumberDisplay,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Card Holder',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              cardHolderDisplay,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Expiry',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              expiryDisplay,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? errorText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      buildCounter:
          (_, {required currentLength, required isFocused, maxLength}) => null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        errorText: errorText,
        errorStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : Colors.grey.shade200,
            width: errorText != null ? 1.5 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : const Color(0xFF5C2D91),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}