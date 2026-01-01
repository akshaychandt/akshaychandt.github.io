import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import '../services/analytics_service.dart';

class UrlLauncherHelper {
  static final _analytics = AnalyticsService.instance;

  static Future<void> launchURL(String url) async {
    // Handle relative asset paths for web
    String finalUrl = url;
    if (kIsWeb && url.startsWith('assets/')) {
      // On web, assets are served from the root
      finalUrl = url;
    }

    final uri = Uri.parse(finalUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (kIsWeb) {
      // Fallback for web: try opening directly
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }

  static Future<void> launchEmail(String email, {String? subject, String? body}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> downloadResume(String resumeUrl) async {
    _analytics.trackResumeDownload();
    await launchURL(resumeUrl);
  }

  static Future<void> launchSocialLink(String platform, String url) async {
    _analytics.trackSocialClick(platform, url);
    await launchURL(url);
  }
}
