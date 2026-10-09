import 'package:flutter/foundation.dart';

import 'dummy_data.dart';

/// State sederhana di memori untuk mockup (tanpa backend).
class AppState extends ChangeNotifier {
  AppState._();
  static final instance = AppState._();

  String phoneNumber = '';
  String? loggedInAs;

  int reepoBalance = DummyData.initialReepoBalance;
  List<BankAccount> banks = List.of(DummyData.banks);
  int selectedBankIndex = 0;

  BankAccount get selectedBank => banks[selectedBankIndex];

  void login(String who) {
    loggedInAs = who;
    notifyListeners();
  }

  void selectBank(int index) {
    selectedBankIndex = index;
    notifyListeners();
  }

  void topUp(int amount) {
    reepoBalance += amount;
    notifyListeners();
  }

  /// Memindahkan seluruh saldo bank terpilih ke saldo reepo.
  void redeemSelectedBank() {
    final bank = selectedBank;
    reepoBalance += bank.valueInIdr;
    banks[selectedBankIndex] = BankAccount(name: bank.name, balance: 0, unit: bank.unit, rateToIdr: bank.rateToIdr);
    notifyListeners();
  }
}

String formatNumber(int value) {
  final negative = value < 0;
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${negative ? '-' : ''}$buffer';
}
