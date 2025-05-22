import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kit/core/utils/internal_notification/notify_service.dart';
import 'package:flutter_kit/core/utils/internal_notification/in_app_message/in_app_message_event.dart';

class InAppMessageViewModel {
  InAppMessageViewModel({required NotifyService notifyService})
    : _notifyService = notifyService;

  final NotifyService _notifyService;

  ValueNotifier<InAppMessageEvent?> get inAppMessageEvent =>
      _notifyService.inAppMessageEvent;

  void clearInAppMessageEvent() {
    _notifyService.clearInAppMessageEvent();
  }
}
