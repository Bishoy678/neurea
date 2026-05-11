// // lib/services/chatbot_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ChatbotService {
//   static const String baseUrl = 'https://djangograduationprojectfinalversion-production.up.railway.app';
  
//   Future<Map<String, dynamic>> sendMessage(String message) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/chatbot/'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'message': message,
//         }),
//       );
      
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return {
//           'success': true,
//           'reply': data['reply'] ?? 'No reply',
//           'emotion': data['detected_emotion'] ?? '',
//           'isCrisis': data['is_crisis'] ?? false,
//           'conversationId': data['conversation_id'] ?? 0,
//         };
//       } else {
//         return {
//           'success': false,
//           'reply': 'Error: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'reply': 'Connection error: $e',
//       };
//     }
//   }
// }

import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static const String apiUrl = 'https://djangograduationprojectfinalversion-production.up.railway.app/api/chatbot/';
  
  static const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzc4NTA3NzQ3LCJpYXQiOjE3Nzg0MjEzNDcsImp0aSI6IjQ3NTFmZjE4MzU2ZjQ4MmZhZDVkNWJjODA4OGVhY2NmIiwidXNlcl9pZCI6IjciLCJyb2xlIjoicGF0aWVudCIsImVtYWlsIjoic29oYWliZW1hZGFpQGdtYWlsLmNvbSJ9.0C2SXGZzMpKZ807zQe1-AA8oycpBjBWchBcoD-JEO4w';
  
  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        },
        body: jsonEncode({'message': message}),
      );
      
      // ignore: avoid_print
      print('Response status: ${response.statusCode}');
      // ignore: avoid_print
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? 
               data['response'] ?? 
               data['bot_response'] ?? 
               data['message'] ?? 
               'تم استلام الرد ولكن لم أجد نصه';
      } else if (response.statusCode == 401) {
        return '❌ خطأ في المصادقة - التوكن غير صالح';
      } else {
        return 'خطأ ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      return 'خطأ في الاتصال: $e';
    }
  }
}