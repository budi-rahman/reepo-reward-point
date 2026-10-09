import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/consent_dialog.dart';
import '../widgets/phone_input.dart';
import 'facebook_login_screen.dart';
import 'google_account_screen.dart';
import 'otp_screen.dart';

/// Figma: "Registration" + "Phone Reg" (state saat keyboard terbuka).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phone = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
    _phone.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phone.dispose();
    _focus.dispose();
    super.dispose();
  }

  String get _digits => _phone.text.replaceAll(' ', '');

  void _continue() {
    if (_digits.length < 9) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Masukkan nomor HP yang valid (min. 9 digit)')));
      return;
    }
    AppState.instance.phoneNumber = '+62 ${_phone.text}';
    _focus.unfocus();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OtpScreen()));
  }

  Future<void> _google() async {
    _focus.unfocus();
    if (!await showSignInConsent(context, 'google.com') || !mounted) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GoogleAccountScreen()));
  }

  Future<void> _facebook() async {
    _focus.unfocus();
    if (!await showSignInConsent(context, 'facebook') || !mounted) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FacebookLoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final showContinue = _focus.hasFocus || _phone.text.isNotEmpty;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.red,
        body: GestureDetector(
          onTap: () => _focus.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: keyboardOpen ? 40 : 115),
                          const Center(child: MascotOutline()),
                          const SizedBox(height: 22),
                          const Text(
                            'WELCOME !',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.offWhite),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Enter your mobile number to continue',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.offWhite),
                          ),
                          const SizedBox(height: 4),
                          PhoneInputRow(controller: _phone, focusNode: _focus, onSubmitted: (_) => _continue()),
                          const SizedBox(height: 22),
                          AnimatedOpacity(
                            opacity: showContinue ? 1 : 0,
                            duration: const Duration(milliseconds: 150),
                            child: Center(
                              child: TextButton(
                                onPressed: showContinue ? _continue : null,
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.offWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (!keyboardOpen) ...[
                            const Text(
                              'or continue with your social account',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.offWhite),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _SocialButton(
                                  onTap: _google,
                                  child: Image.asset('assets/images/google.png', width: 30, height: 30),
                                ),
                                const SizedBox(width: 11),
                                _SocialButton(
                                  onTap: _facebook,
                                  child: SvgPicture.asset('assets/icons/facebook.svg', width: 31, height: 31),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkResponse(onTap: onTap, radius: 22, child: child);
  }
}
