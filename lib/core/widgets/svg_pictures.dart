import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:vibe/presentation/screens/web_screen_layout.dart';

class InstagramLogo extends StatelessWidget {
  final Color? color;
  final bool enableOnTapForWeb;
  const InstagramLogo({super.key, this.color, this.enableOnTapForWeb = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: enableOnTapForWeb
            ? () => Get.offAll(const WebScreenLayout())
            : null,
        child: Text(
          'Vibe',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 32,
            color: color ?? Theme.of(context).focusColor,
          ),
        ),
      );
}
