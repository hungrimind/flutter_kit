import 'package:flutter/material.dart';
import 'package:flutter_kit/core/utils/internal_notification/in_app_message/in_app_message_event.dart';

class NotifyService {
  final ValueNotifier<InAppMessageEvent?> inAppMessageEvent =
      ValueNotifier<InAppMessageEvent?>(null);

  void setInAppMessageEvent(InAppMessageEvent? event) {
    inAppMessageEvent.value = event;
  }

  void clearInAppMessageEvent() {
    inAppMessageEvent.value = null;
  }
}
