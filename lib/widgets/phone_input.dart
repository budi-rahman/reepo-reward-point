import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme.dart';

/// Baris input nomor HP: bendera Indonesia, kode "+62", dan field nomor.
class PhoneInputRow extends StatelessWidget {
  const PhoneInputRow({super.key, required this.controller, this.focusNode, this.onSubmitted});

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;

  static const _boxDecoration = BoxDecoration(
    color: AppColors.offWhite,
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );
  static const _textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.countryCode);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 33,
      child: Row(
        children: [
          Container(
            width: 30,
            decoration: _boxDecoration,
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/flag_id.svg', width: 20, height: 20),
          ),
          const SizedBox(width: 8),
          Container(
            width: 32,
            decoration: _boxDecoration,
            alignment: Alignment.center,
            child: const FittedBox(child: Text('+62', style: _textStyle)),
          ),
          const SizedBox(width: 10),
          Container(
            width: 151,
            decoration: _boxDecoration.copyWith(color: Colors.white),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: onSubmitted,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(13),
                _PhoneGroupingFormatter(),
              ],
              cursorColor: AppColors.red,
              style: _textStyle.copyWith(fontSize: 16),
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: '1234 5678 9000',
                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.placeholder),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Memformat nomor menjadi kelompok 4 digit: "1234 5678 9000".
class _PhoneGroupingFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
