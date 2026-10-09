import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reepo/screens/facebook_login_screen.dart';
import 'package:reepo/screens/google_account_screen.dart';
import 'package:reepo/screens/home_screen.dart';
import 'package:reepo/screens/otp_screen.dart';
import 'package:reepo/screens/redeem_screen.dart';
import 'package:reepo/screens/register_screen.dart';
import 'package:reepo/screens/splash_screen.dart';
import 'package:reepo/theme.dart';

Future<void> _loadFont(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final f in files) {
    final bytes = File(f).readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    await _loadFont('SourceSans', [
      'assets/fonts/SourceSans3-Regular.ttf',
      'assets/fonts/SourceSans3-Semibold.ttf',
      'assets/fonts/SourceSans3-Bold.ttf',
    ]);
    await _loadFont('Audiowide', ['assets/fonts/Audiowide-Regular.ttf']);
    await _loadFont('MaterialIcons', [
      '${Platform.environment['FLUTTER_ROOT'] ?? r'C:\src\flutter\flutter_windows_3.32.0-stable\flutter'}'
          r'\bin\cache\artifacts\material_fonts\MaterialIcons-Regular.otf',
    ]);
  });

  final screens = <String, Widget Function()>{
    'splash': () => const SplashScreen(),
    'register': () => const RegisterScreen(),
    'otp': () => const OtpScreen(),
    'google': () => const GoogleAccountScreen(),
    'facebook': () => const FacebookLoginScreen(),
    'home': () => const HomeScreen(),
    'redeem': () => const RedeemScreen(),
    'success': () => const RedeemSuccessScreen(),
  };

  for (final entry in screens.entries) {
    testWidgets(entry.key, (tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.75;
      tester.view.padding = const FakeViewPadding(top: 66);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(debugShowCheckedModeBanner: false, theme: buildTheme(), home: entry.value()));
      // Biarkan aset (PNG/SVG) selesai di-decode.
      for (var i = 0; i < 5; i++) {
        await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
        await tester.pump(const Duration(milliseconds: 100));
      }
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('screenshots/${entry.key}.png'));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));
    });
  }
}
