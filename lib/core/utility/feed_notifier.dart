import 'package:flutter/material.dart';

class FeedNotifier {
  static final ValueNotifier<bool> reload = ValueNotifier(false);

  static void triggerReload() {
    reload.value = !reload.value;
  }
}
