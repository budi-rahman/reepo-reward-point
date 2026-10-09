import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_state.dart';
import '../data/dummy_data.dart';
import '../theme.dart';
import 'home_screen.dart';

/// Figma: "Google Choose Acc"
class GoogleAccountScreen extends StatelessWidget {
  const GoogleAccountScreen({super.key});

  void _choose(BuildContext context, GoogleAccount account) {
    AppState.instance.login(account.email);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    const dark = TextStyle(color: AppColors.textDark);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFEFFFE),
        body: Column(
          children: [
            Container(
              color: AppColors.sheetHeader,
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('< Back', style: TextStyle(fontSize: 14, color: AppColors.red)),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Today', style: dark.copyWith(fontSize: 16, height: 1)),
                          Text(_now(), style: dark.copyWith(fontSize: 12, height: 1.1)),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Edit', style: TextStyle(fontSize: 14, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              child: Row(
                children: [
                  Image.asset('assets/images/google.png', width: 15, height: 15),
                  const SizedBox(width: 5),
                  Text('Sign in with Google', style: dark.copyWith(fontSize: 13)),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black54),
            const SizedBox(height: 22),
            Text('Choose an account', style: dark.copyWith(fontSize: 22)),
            Text.rich(
              TextSpan(
                text: 'to continue to ',
                children: const [
                  TextSpan(
                    text: 'Reepo',
                    style: TextStyle(color: AppColors.red),
                  ),
                ],
              ),
              style: dark.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 20),
            for (final account in DummyData.googleAccounts)
              InkWell(
                onTap: () => _choose(context, account),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    children: [
                      Image.asset('assets/images/avatar.png', width: 30.75, height: 30),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (account.name != null)
                            Text(
                              account.name!,
                              style: dark.copyWith(fontSize: 13, fontWeight: FontWeight.w600, height: 1),
                            ),
                          Text(account.email, style: dark.copyWith(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _now() {
    final t = TimeOfDay.now();
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}
