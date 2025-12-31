import 'package:emailjs/emailjs.dart' as emailjs;

class EmailService {
  // TODO: Replace these with your actual EmailJS credentials
  static const String _serviceId = 'YOUR_SERVICE_ID';
  static const String _templateId = 'YOUR_TEMPLATE_ID';
  static const String _publicKey = 'YOUR_PUBLIC_KEY';

  static Future<EmailResult> sendEmail({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      await emailjs.send(
        _serviceId,
        _templateId,
        {
          'from_name': name,
          'from_email': email,
          'message': message,
          'to_email': 'akshaychand.t@gmail.com',
        },
        const emailjs.Options(
          publicKey: _publicKey,
          limitRate: emailjs.LimitRate(
            throttle: 10000,
          ),
        ),
      );
      return EmailResult.success();
    } catch (e) {
      if (e is emailjs.EmailJSResponseStatus) {
        return EmailResult.failure('Failed to send email: ${e.text}');
      }
      return EmailResult.failure(e.toString());
    }
  }
}

class EmailResult {
  final bool isSuccess;
  final String? errorMessage;

  EmailResult._({required this.isSuccess, this.errorMessage});

  factory EmailResult.success() => EmailResult._(isSuccess: true);
  factory EmailResult.failure(String message) =>
      EmailResult._(isSuccess: false, errorMessage: message);
}
