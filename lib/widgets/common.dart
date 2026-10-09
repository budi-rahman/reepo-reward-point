import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme.dart';

/// Teks "reepo" dengan font brand Audiowide.
class ReepoWordmark extends StatelessWidget {
  const ReepoWordmark({super.key, this.size = 16, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'reepo',
      style: TextStyle(fontFamily: AppFonts.brand, fontSize: size, color: color, height: 1.1),
    );
  }
}

/// Tombol kembali "back 1" dari desain (versi putih & merah).
class ReepoBackButton extends StatelessWidget {
  const ReepoBackButton({super.key, this.white = false, this.onPressed});

  final bool white;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      icon: SvgPicture.asset(
        white ? 'assets/icons/back_white.svg' : 'assets/icons/back_red.svg',
        width: 20,
        height: 30,
      ),
    );
  }
}

/// Kepala maskot (outline putih).
class MascotOutline extends StatelessWidget {
  const MascotOutline({super.key, this.size = 60});
  final double size;

  @override
  Widget build(BuildContext context) => SvgPicture.asset('assets/icons/mascot_outline.svg', width: size, height: size);
}

void showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$feature — segera hadir (mockup)')));
}
