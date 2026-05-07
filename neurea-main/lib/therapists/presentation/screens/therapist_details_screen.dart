// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/core/presentation/screens/Notification_Helper.dart';
import 'package:neurea/cubit/payment/payment_cubit.dart';
import 'package:neurea/cubit/payment/payment_state.dart';
import 'package:neurea/payment/payment_screen.dart';
import 'package:neurea/therapists/presentation/screens/Therapist_Chat_With_Messages_Screen.dart';
import 'package:neurea/therapists/presentation/screens/therapist_voice_call_screen.dart';
import 'package:neurea/therapists/presentation/screens/therapist_video_call_screen.dart';

class TherapistDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> therapist;
  const TherapistDetailsScreen({super.key, required this.therapist});

  void _showBookingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (_) => PaymentCubit(),
        child: BookingBottomSheet(
          therapistId: therapist['id']?.toString() ?? '',
          therapistName: therapist['name'] ?? '',
          therapistImage: therapist['image'] ?? '',
          specialty: therapist['specialty'] ?? '',
          price: (therapist['price'] as num).toDouble(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Therapist Details',
          style: TextStyle(
            color: Color(0xFF011821),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.favorite_border, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x66BFE9D4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          therapist['is_online'] == true
                              ? "● Online"
                              : "● Offline",
                          style: TextStyle(
                            color: therapist['is_online'] == true
                                ? const Color(0xFF4AD991)
                                : Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        therapist['name'] ?? '',
                        style: const TextStyle(
                          color: Color(0xFF011821),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        therapist['specialty'] ?? '',
                        style: const TextStyle(
                          color: Color(0xFF5C2D91),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${therapist['rating']} (${therapist['reviews']} Reviews)",
                            style: const TextStyle(
                              color: Color(0xFF4D5D64),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                (therapist['image'] == null ||
                        therapist['image'].toString().isEmpty)
                    ? Container(
                        width: 166,
                        height: 247,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        ),
                      )
                    : therapist['image'].toString().startsWith('assets/')
                    ? Image.asset(
                        therapist['image'],
                        width: 166,
                        height: 247,
                        fit: BoxFit.fill,
                      )
                    : Image.network(
                        therapist['image'],
                        width: 166,
                        height: 247,
                        fit: BoxFit.fill,
                        errorBuilder: (_, __, ___) => Container(
                          width: 166,
                          height: 247,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                _actionButton(
                  context,
                  Icons.call,
                  "Audio Call",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TherapistVoiceCallScreen(
                        therapistName: therapist['name'] ?? '',
                        therapistImage: therapist['image'] ?? '',
                        specialty: therapist['specialty'] ?? '',
                        therapistId: therapist['id']?.toString() ?? '', 
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _actionButton(
                  context,
                  Icons.videocam,
                  "Video Call",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TherapistVideoCallScreen(
                        therapistName: therapist['name'] ?? '',
                        therapistImage: therapist['image'] ?? '',
                        specialty: therapist['specialty'] ?? '',
                        therapistId: therapist['id']?.toString() ?? '',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _actionButton(
                  context,
                  Icons.message,
                  "Message",
                  filled: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TherapistChatWithMessagesScreen(
                        therapistName: therapist['name'] ?? '',
                        therapistImage: therapist['image'] ?? '',
                        therapistId: therapist['id']?.toString(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "About Therapist",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              therapist['about'] ?? '',
              style: const TextStyle(color: Color(0xFF67747A), fontSize: 12),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "${therapist['patients']}+",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text("Patients"),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${therapist['experience']} Yrs",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text("Exp."),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${therapist['rating']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text("Rating"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Price\n\$${therapist['price']}/hr",
                  style: const TextStyle(
                    color: Color(0xFF2A2F41),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C2D91),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => _showBookingBottomSheet(context),
                      child: const Text(
                        "Booking Appointment",
                        style: TextStyle(
                          color: Color(0xFFFCFCFC),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _actionButton(
  BuildContext context,
  IconData icon,
  String text, {
  bool filled = false,
  VoidCallback? onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF5C2D91) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: filled ? Colors.white : const Color(0xFF5C2D91)),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: filled ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class BookingBottomSheet extends StatefulWidget {
  final String therapistId, therapistName, therapistImage, specialty;
  final double price;

  const BookingBottomSheet({
    super.key,
    required this.therapistId,
    required this.therapistName,
    required this.therapistImage,
    required this.specialty,
    required this.price,
  });

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  int selectedDay = 0;
  int? selectedTime;

  final List<Map<String, String>> days = [
    {'day': 'Mon', 'date': '10'},
    {'day': 'Wed', 'date': '12'},
    {'day': 'Sat', 'date': '15'},
    {'day': 'Sun', 'date': '16'},
  ];

  final List<String> times = ['13:00 PM', '16:00 PM', '18:00 PM'];
  
  void _confirmBooking(BuildContext context) {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final day = days[selectedDay]['day']!;
    final date = days[selectedDay]['date']!;
    final time = times[selectedTime!];
    

    final now = DateTime.now();
    final appointmentDate = DateTime(
      now.year,
      now.month,
      int.parse(date),
    );
    
    NotificationHelper.sendAppointmentReminder(
      therapistName: widget.therapistName,
      appointmentDate: appointmentDate,
      appointmentTime: time,
    );

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          therapistName: widget.therapistName,
          therapistImage: widget.therapistImage,
          specialty: widget.specialty,
          appointmentDay: day,
          appointmentDate: date,
          appointmentTime: time,
          price: widget.price,
          therapistId: widget.therapistId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      "Booking Session",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF011821),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        days.length,
                        (index) => _DayBox(
                          day: days[index]['day']!,
                          date: days[index]['date']!,
                          selected: selectedDay == index,
                          onTap: () => setState(() => selectedDay = index),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Available Time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF011821),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(
                      times.length,
                      (index) => _TimeBox(
                        time: times[index],
                        selected: selectedTime == index,
                        onTap: () => setState(() => selectedTime = index),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Price\n\$${widget.price.toStringAsFixed(0)}/hr",
                          style: const TextStyle(
                            color: Color(0xFF2A2F41),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5C2D91),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _confirmBooking(context),
                              child: const Text(
                                "Confirm Booking",
                                style: TextStyle(
                                  color: Color(0xFFFCFCFC),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayBox extends StatelessWidget {
  final String day, date;
  final bool selected;
  final VoidCallback onTap;
  const _DayBox({
    required this.day,
    required this.date,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF5C2D91) : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String time;
  final bool selected;
  final VoidCallback onTap;
  const _TimeBox({
    required this.time,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF5C2D91) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: TextStyle(
                color: selected ? const Color(0xFF5C2D91) : Colors.black,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.add_circle_outline,
              color: selected ? const Color(0xFF5C2D91) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}