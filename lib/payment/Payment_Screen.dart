// ignore_for_file: use_build_context_synchronously, deprecated_member_use, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/cubit/payment/payment_cubit.dart';
import 'package:neurea/cubit/payment/payment_state.dart';
import 'package:neurea/payment/Add_Card_Screen.dart';
import 'package:neurea/payment/Payment_Success_Screen.dart';
import 'package:neurea/payment/Payment_Failure_Screen.dart';

class PaymentScreen extends StatelessWidget {
  final String therapistName;
  final String therapistImage;
  final String specialty;
  final String appointmentDay;
  final String appointmentDate;
  final String appointmentTime;
  final double price;
  final String therapistId;

  const PaymentScreen({
    super.key,
    required this.therapistName,
    required this.therapistImage,
    required this.specialty,
    required this.appointmentDay,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.price,
    required this.therapistId,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ فعّل وضع الاختبار عشان تظهر صفحة الفشل
    // PaymentCubit.testMode = true;
    // PaymentCubit.forceError = true;
    
    return BlocProvider(
      create: (_) => PaymentCubit(),
      child: _PaymentBody(
        therapistName: therapistName,
        therapistImage: therapistImage,
        specialty: specialty,
        appointmentDay: appointmentDay,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
        price: price,
        therapistId: therapistId,
      ),
    );
  }
}

class _PaymentBody extends StatefulWidget {
  final String therapistName;
  final String therapistImage;
  final String specialty;
  final String appointmentDay;
  final String appointmentDate;
  final String appointmentTime;
  final double price;
  final String therapistId;

  const _PaymentBody({
    required this.therapistName,
    required this.therapistImage,
    required this.specialty,
    required this.appointmentDay,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.price,
    required this.therapistId,
  });

  @override
  State<_PaymentBody> createState() => _PaymentBodyState();
}

class _PaymentBodyState extends State<_PaymentBody> {
  bool saveInfo = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  String? _cardNumberError;
  String? _expiryError;
  String? _cvcError;
  String? _nameError;

  bool _isValidName(String name) {
    if (name.isEmpty) return false;
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegex.hasMatch(name);
  }

  bool get _isFormValid {
    return _isValidName(_nameController.text) &&
        _cardNumberController.text.replaceAll(' ', '').length == 16 &&
        _expiryController.text.length == 5 &&
        _cvcController.text.length == 3 &&
        _cardNumberError == null &&
        _expiryError == null &&
        _cvcError == null &&
        _nameError == null;
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      _validateName(_nameController.text);
      setState(() {});
    });
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

  void _validateName(String value) {
    if (value.isEmpty) {
      _nameError = 'Cardholder name is required';
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      _nameError = 'Name must contain only letters';
    } else {
      _nameError = null;
    }
  }

  void _validateCardNumber(String value) {
    final digits = value.replaceAll(' ', '');
    if (digits.isEmpty)
      _cardNumberError = null;
    else if (digits.length < 16)
      _cardNumberError = 'Card number must be 16 digits';
    else
      _cardNumberError = null;
  }

  void _formatAndValidateExpiry(String value) {
    final digits = value.replaceAll('/', '');
    if (digits.length >= 2) {
      final formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
      if (_expiryController.text != formatted) {
        _expiryController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }
    if (value.isEmpty) {
      _expiryError = null;
    } else if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      _expiryError = 'Invalid format. Use MM/YY';
    } else {
      final month = int.tryParse(value.split('/')[0]) ?? 0;
      _expiryError = (month < 1 || month > 12) ? 'Month must be 01–12' : null;
    }
  }

  void _validateCvc(String value) {
    if (value.isEmpty)
      _cvcError = null;
    else if (value.length < 3)
      _cvcError = 'CVC must be 3 digits';
    else if (value.length > 3)
      _cvcError = 'CVC must be 3 digits only';
    else
      _cvcError = null;
  }

  String get _cardNumberDisplay {
    final text = _cardNumberController.text.replaceAll(' ', '');
    if (text.isEmpty) return 'XXXX  XXXX  XXXX  XXXX';
    final padded = text.padRight(16, 'X');
    return '${padded.substring(0, 4)}  ${padded.substring(4, 8)}  ${padded.substring(8, 12)}  ${padded.substring(12, 16)}';
  }

  void _onConfirmPayment(PaymentCubit cubit) {
    if (!_isFormValid) return;

    cubit.confirmPayment(
      therapistId: widget.therapistId,
      therapistName: widget.therapistName,
      therapistImage: widget.therapistImage,
      specialty: widget.specialty,
      appointmentDay: widget.appointmentDay,
      appointmentDate: widget.appointmentDate,
      appointmentTime: widget.appointmentTime,
      price: widget.price,
      cardNumber: _cardNumberController.text,
      cardHolder: _nameController.text,
      expiry: _expiryController.text,
      cvc: _cvcController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        final cubit = context.read<PaymentCubit>();
        if (cubit.state is PaymentLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please wait, payment is in progress...'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 1),
            ),
          );
          return false;
        }
        return true;
      },
      child: BlocConsumer<PaymentCubit, PaymentState>(
        buildWhen: (prev, curr) => prev != curr,
        listener: (context, state) {
          if (state is PaymentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            
            Navigator.push(
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
            );
          } else if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentFailureScreen(
                  therapistName: widget.therapistName,
                  therapistImage: widget.therapistImage,
                  specialty: widget.specialty,
                  appointmentDay: widget.appointmentDay,
                  appointmentDate: widget.appointmentDate,
                  appointmentTime: widget.appointmentTime,
                  errorMessage: state.message,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PaymentLoading;
          final cubit = context.read<PaymentCubit>();

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
              backgroundColor: const Color(0xFFF5F5F5),
              elevation: 0,
              leading: BackButton(
                color: Colors.black,
                onPressed: () {
                  if (isLoading) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please wait, payment is in progress...'),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              title: Text(
                'Payment',
                style: TextStyle(
                  color: const Color(0xFF5C2D91),
                  fontWeight: FontWeight.bold,
                  fontSize: sw * 0.045,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: sh * 0.01),
                  _buildCreditCard(sw, sh),
                  SizedBox(height: sh * 0.02),
                  _buildAddAnotherCard(context, sw, sh),
                  SizedBox(height: sh * 0.03),
                  _buildLabel('Cardholder Name', sw),
                  SizedBox(height: sh * 0.01),
                  _buildTextField(_nameController, 'E.G. Mohamed A', sw, sh, errorText: _nameError),
                  SizedBox(height: sh * 0.02),
                  _buildLabel('Card Number', sw),
                  SizedBox(height: sh * 0.01),
                  _buildTextField(
                    _cardNumberController,
                    '0000 0000 0000 0000',
                    sw,
                    sh,
                    keyboardType: TextInputType.number,
                    errorText: _cardNumberError,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      _CardNumberFormatter(),
                    ],
                  ),
                  SizedBox(height: sh * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Expiry number', sw),
                            SizedBox(height: sh * 0.01),
                            _buildTextField(
                              _expiryController,
                              'MM/YY',
                              sw,
                              sh,
                              keyboardType: TextInputType.number,
                              errorText: _expiryError,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[\d/]'),
                                ),
                                LengthLimitingTextInputFormatter(5),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: sw * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('CVC', sw),
                            SizedBox(height: sh * 0.01),
                            _buildTextField(
                              _cvcController,
                              '•••',
                              sw,
                              sh,
                              keyboardType: TextInputType.number,
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
                  SizedBox(height: sh * 0.02),
                  Row(
                    children: [
                      Checkbox(
                        value: saveInfo,
                        onChanged: (val) =>
                            setState(() => saveInfo = val ?? false),
                        activeColor: const Color(0xFF5C2D91),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Text(
                        'Save my information',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: sw * 0.035,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sh * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price\n\$${widget.price.toStringAsFixed(0)}/hr',
                        style: TextStyle(
                          color: const Color(0xFF2A2F41),
                          fontSize: sw * 0.04,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: sw * 0.04),
                          child: ElevatedButton(
                            onPressed: (isLoading || !_isFormValid)
                                ? null
                                : () => _onConfirmPayment(cubit),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5C2D91),
                              padding: EdgeInsets.symmetric(vertical: sh * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    height: sw * 0.05,
                                    width: sw * 0.05,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Confirm Payment',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: sw * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sh * 0.04),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreditCard(double sw, double sh) {
    return Container(
      width: double.infinity,
      height: sh * 0.23,
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
            right: -(sw * 0.08),
            top: -(sw * 0.08),
            child: Container(
              width: sw * 0.4,
              height: sw * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            right: sw * 0.1,
            bottom: -(sw * 0.1),
            child: Container(
              width: sw * 0.3,
              height: sw * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(sw * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'VISA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: sw * 0.07,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 2,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _cardNumberDisplay,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: sw * 0.038,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: sh * 0.015),
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
                                fontSize: sw * 0.028,
                              ),
                            ),
                            Text(
                              _nameController.text.isEmpty
                                  ? 'YOUR NAME'
                                  : _nameController.text,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: sw * 0.035,
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
                                fontSize: sw * 0.028,
                              ),
                            ),
                            Text(
                              _expiryController.text.isEmpty
                                  ? 'MM/YY'
                                  : _expiryController.text,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: sw * 0.035,
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

  Widget _buildAddAnotherCard(BuildContext context, double sw, double sh) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddCardScreen(
            therapistName: widget.therapistName,
            therapistImage: widget.therapistImage,
            specialty: widget.specialty,
            appointmentDay: widget.appointmentDay,
            appointmentDate: widget.appointmentDate,
            appointmentTime: widget.appointmentTime,
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: sh * 0.02),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF5C2D91), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: sw * 0.06,
              height: sw * 0.06,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF5C2D91), width: 1.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: sw * 0.04,
                color: const Color(0xFF5C2D91),
              ),
            ),
            SizedBox(width: sw * 0.02),
            Text(
              'Add another Card',
              style: TextStyle(
                color: const Color(0xFF5C2D91),
                fontWeight: FontWeight.w600,
                fontSize: sw * 0.038,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, double sw) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: sw * 0.037,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    double sw,
    double sh, {
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(fontSize: sw * 0.038),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: sw * 0.037),
        filled: true,
        fillColor: Colors.white,
        counterText: '',
        errorText: errorText,
        errorStyle: TextStyle(fontSize: sw * 0.03),
        contentPadding: EdgeInsets.symmetric(
          horizontal: sw * 0.04,
          vertical: sh * 0.018,
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