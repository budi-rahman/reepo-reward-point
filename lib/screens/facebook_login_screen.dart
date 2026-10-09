import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/app_state.dart';
import '../theme.dart';
import 'home_screen.dart';

/// Figma: "Facebook Acc"
class FacebookLoginScreen extends StatelessWidget {
  const FacebookLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const dark = TextStyle(fontSize: 13, color: AppColors.textDark);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFEFFFE),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.sheetHeader,
              child: const SafeArea(
                bottom: false,
                child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('Log in with Facebook', style: TextStyle(fontSize: 16, color: AppColors.textDark)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 29),
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: SvgPicture.asset('assets/icons/fb_mascot.svg', width: 45, height: 45),
            ),
            const SizedBox(height: 28),
            const Text('Log in to Reepo with\nFacebook', textAlign: TextAlign.center, style: dark),
            const SizedBox(height: 16),
            const Text('Would you like to continue ?', textAlign: TextAlign.center, style: dark),
            const Spacer(),
            SizedBox(
              width: 198,
              height: 35,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: AppColors.facebook, shape: const RoundedRectangleBorder()),
                onPressed: () {
                  AppState.instance.login('Facebook user');
                  Navigator.of(
                    context,
                  ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
                },
                child: const Text('CONTINUE', style: TextStyle(fontSize: 14, color: AppColors.offWhite)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
