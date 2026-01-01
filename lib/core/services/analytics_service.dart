import 'package:flutter/foundation.dart';
import 'dart:js_interop';

/// Analytics service for tracking user interactions.
/// Uses Google Analytics 4 on web platform.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  /// Track a custom event
  void trackEvent(String eventName, [Map<String, dynamic>? params]) {
    if (!kIsWeb) return;

    try {
      final jsParams = params?.jsify() ?? {}.jsify();
      _trackEvent(eventName.toJS, jsParams as JSObject);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Track page/section view
  void trackPageView(String pageName) {
    if (!kIsWeb) return;

    try {
      _trackPageView(pageName.toJS);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Track resume download
  void trackResumeDownload() {
    if (!kIsWeb) return;

    try {
      _trackResumeDownload();
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Track social link click
  void trackSocialClick(String platform, String url) {
    if (!kIsWeb) return;

    try {
      _trackSocialClick(platform.toJS, url.toJS);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Track contact form submission
  void trackContactFormSubmit() {
    if (!kIsWeb) return;

    try {
      _trackContactFormSubmit();
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Track section view (for scroll tracking)
  void trackSectionView(String sectionName) {
    if (!kIsWeb) return;

    try {
      _trackSectionView(sectionName.toJS);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  /// Track button click
  void trackButtonClick(String buttonName, [String? context]) {
    trackEvent('button_click', {
      'button_name': buttonName,
      if (context != null) 'context': context,
    });
  }

  /// Track project view
  void trackProjectView(String projectTitle) {
    trackEvent('project_view', {
      'project_title': projectTitle,
    });
  }

  /// Track external link click
  void trackExternalLinkClick(String url, String linkText) {
    trackEvent('external_link_click', {
      'link_url': url,
      'link_text': linkText,
    });
  }
}

// JS interop bindings
@JS('trackEvent')
external void _trackEvent(JSString eventName, JSObject params);

@JS('trackPageView')
external void _trackPageView(JSString pageName);

@JS('trackResumeDownload')
external void _trackResumeDownload();

@JS('trackSocialClick')
external void _trackSocialClick(JSString platform, JSString url);

@JS('trackContactFormSubmit')
external void _trackContactFormSubmit();

@JS('trackSectionView')
external void _trackSectionView(JSString sectionName);
