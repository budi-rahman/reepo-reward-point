import 'package:flutter/material.dart';

import '../theme.dart';

/// Dialog izin sign-in gaya iOS ("Google Reg" / "Facebook Reg").
/// Mengembalikan `true` bila user menekan Continue.
Future<bool> showSignInConsent(BuildContext context, String provider) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black26,
    builder: (context) => Dialog(
      backgroundColor: AppColors.offWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Column(
                children: [
                  Text(
                    '“Reepo” Wants to\nUse “$provider” to Sign in',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'This allows the app and website to\nshare information about you',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DialogAction('Cancel', () => Navigator.pop(context, false)),
                  const VerticalDivider(width: 1, thickness: 1, color: Colors.black),
                  _DialogAction('Continue', () => Navigator.pop(context, true)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}

class _DialogAction extends StatelessWidget {
  const _DialogAction(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
