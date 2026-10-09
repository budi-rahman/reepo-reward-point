import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Figma: "Redeem Other" — konfirmasi redeem saldo bank ke saldo reepo.
class RedeemScreen extends StatelessWidget {
  const RedeemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final bank = state.selectedBank;
    final empty = bank.balance == 0;
    const brown = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textBrown);

    return _WhitePage(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (empty)
            Text('Saldo ${bank.name} kamu kosong', style: brown)
          else ...[
            Text(
              'Redeem ${formatNumber(bank.balance)} ${bank.unit} dari ${bank.name}',
              style: brown.copyWith(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('your ', style: brown),
                ReepoWordmark(size: 20, color: AppColors.textBrown),
                Text(' balance will be', style: brown),
              ],
            ),
            const SizedBox(height: 6),
            Text('IDR ${formatNumber(state.reepoBalance + bank.valueInIdr)}', style: brown.copyWith(fontSize: 25)),
          ],
          const SizedBox(height: 12),
          SizedBox(
            height: 29,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.red,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () {
                if (empty) {
                  Navigator.pop(context);
                  return;
                }
                state.redeemSelectedBank();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const RedeemSuccessScreen()));
              },
              child: const Text(
                'OKAY !',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma: "Succesful redeem"
class RedeemSuccessScreen extends StatelessWidget {
  const RedeemSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _WhitePage(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Congratulations !',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: AppColors.textBrown),
          ),
          const SizedBox(height: 8),
          Text(
            'Saldo reepo kamu sekarang IDR ${formatNumber(AppState.instance.reepoBalance)}',
            style: const TextStyle(fontSize: 14, color: AppColors.textBrown),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Kembali ke beranda',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhitePage extends StatelessWidget {
  const _WhitePage({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(left: 6, top: 4), child: ReepoBackButton()),
              Expanded(
                child: Center(
                  child: Padding(padding: const EdgeInsets.only(bottom: 120), child: child),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
