import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/dummy_data.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'register_screen.dart';

/// Figma: "Opening"
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _next);
  }

  void _next() {
    _timer?.cancel();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const RegisterScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.red,
        body: GestureDetector(
          onTap: _next,
          child: SafeArea(
            child: SizedBox.expand(
              child: Column(
                children: [
                  const Spacer(),
                  const ReepoLogo(),
                  const Spacer(),
                  const Text(
                    'version ${DummyData.appVersion}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.offWhite),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma: "Component 1" — logo e.point + maskot + "reepo" + tagline.
class ReepoLogo extends StatelessWidget {
  const ReepoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 169,
      height: 103,
      child: Stack(
        children: [
          Positioned(left: 27, top: 17, child: SvgPicture.asset('assets/icons/epoint.svg', width: 66, height: 22)),
          Positioned(left: 100, top: 0, child: SvgPicture.asset('assets/icons/mascot_logo.svg', width: 42, height: 41)),
          const Positioned(left: 24, top: 30, child: ReepoWordmark(size: 36)),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Text(
              'Your Point is Your Currency',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
