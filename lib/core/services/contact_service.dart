import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class ContactService {
  static final _firestore = FirebaseFirestore.instance;
  static const _collection = 'contact_messages';

  static Future<ContactResult> submitMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      await _firestore.collection(_collection).add({
        'name': name,
        'email': email,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 10));
      return ContactResult.success();
    } on TimeoutException {
      return ContactResult.failure(
          'Request timed out. Please try again later.');
    } catch (e) {
      return ContactResult.failure('Failed to send message: $e');
    }
  }
}

class ContactResult {
  final bool isSuccess;
  final String? errorMessage;

  ContactResult._({required this.isSuccess, this.errorMessage});

  factory ContactResult.success() => ContactResult._(isSuccess: true);
  factory ContactResult.failure(String message) =>
      ContactResult._(isSuccess: false, errorMessage: message);
}
