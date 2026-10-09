import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'home_screen.dart';

/// Figma: "Phone Reg" (OTP). Mockup: kode 6 digit apa pun diterima.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _length = 6;
  static const _resendAfter = Duration(minutes: 5);

  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  Duration _remaining = _resendAfter;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _controller.addListener(_onChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remaining = _resendAfter);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining.inSeconds <= 1) t.cancel();
      setState(() => _remaining -= const Duration(seconds: 1));
    });
  }

  void _onChanged() {
    setState(() {});
    if (_controller.text.length == _length) {
      _focus.unfocus();
      AppState.instance.login(AppState.instance.phoneNumber);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  String get _countdown {
    final m = _remaining.inMinutes;
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$m : $s';
  }

  @override
  Widget build(BuildContext context) {
    const label = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white);
    final code = _controller.text;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.red,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(left: 6, top: 4), child: ReepoBackButton(white: true)),
              Padding(
                padding: const EdgeInsets.fromLTRB(27, 40, 27, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Enter your OTP Password', style: label),
                        const SizedBox(width: 4),
                        SvgPicture.asset('assets/icons/mascot_otp.svg', width: 40, height: 40),
                      ],
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => _focus.requestFocus(),
                      child: Stack(
                        children: [
                          Row(
                            children: List.generate(_length, (i) {
                              final active = _focus.hasFocus && i == code.length;
                              return Container(
                                width: 30,
                                height: 31,
                                margin: const EdgeInsets.only(right: 7),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: active ? Border.all(color: AppColors.textBrown, width: 2) : null,
                                ),
                                child: Text(
                                  i < code.length ? code[i] : '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textBrown,
                                  ),
                                ),
                              );
                            }),
                          ),
                          // TextField tersembunyi yang menerima input keyboard.
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0,
                              child: TextField(
                                controller: _controller,
                                focusNode: _focus,
                                keyboardType: TextInputType.number,
                                autofillHints: const [AutofillHints.oneTimeCode],
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(_length),
                                ],
                                showCursor: false,
                                enableInteractiveSelection: false,
                                decoration: const InputDecoration(border: InputBorder.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_remaining > Duration.zero)
                      Text('Your OTP will resend in  $_countdown', style: label)
                    else
                      GestureDetector(
                        onTap: () {
                          _startTimer();
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(const SnackBar(content: Text('OTP dikirim ulang (mockup)')));
                        },
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Text(
                      'Kode dikirim ke ${AppState.instance.phoneNumber}\n(Mockup: masukkan 6 digit angka apa saja)',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
