/// Dummy data untuk mockup. Nanti diganti dengan data dari API.
library;

class BankAccount {
  const BankAccount({required this.name, required this.balance, required this.unit, required this.rateToIdr});

  final String name;
  final int balance;

  /// Satuan saldo yang ditampilkan, mis. "IDR" atau "POINT".
  final String unit;

  /// Nilai 1 unit dalam rupiah, dipakai saat redeem ke saldo reepo.
  final double rateToIdr;

  int get valueInIdr => (balance * rateToIdr).round();
}

class Category {
  const Category(this.label, this.image, {this.isSvg = false});
  final String label;
  final String image;
  final bool isSvg;
}

class GoogleAccount {
  const GoogleAccount({this.name, required this.email});
  final String? name;
  final String email;
}

class Transaction {
  const Transaction({required this.title, required this.date, required this.amount});
  final String title;
  final String date;
  final int amount;
}

class InboxMessage {
  const InboxMessage({required this.title, required this.body, required this.date});
  final String title;
  final String body;
  final String date;
}

class DummyData {
  static const appVersion = '03.20.01';
  static const initialReepoBalance = 2000000;

  static const banks = [
    BankAccount(name: 'HSBC', balance: 100000, unit: 'IDR', rateToIdr: 1),
    BankAccount(name: 'CIMB', balance: 25000, unit: 'POINT', rateToIdr: 2),
    BankAccount(name: 'CITI', balance: 75000, unit: 'IDR', rateToIdr: 1),
  ];

  static const categories = [
    Category('Culinary', 'assets/images/cat_culinary.png'),
    Category('Sport', 'assets/images/cat_sport.png'),
    Category('Apparel', 'assets/images/cat_apparel.png'),
    Category('Beauty', 'assets/images/cat_beauty.png'),
    Category('Kids', 'assets/images/cat_kids.png'),
    Category('Tools', 'assets/images/cat_tools.png'),
    Category('Leisure', 'assets/images/cat_leisure.png'),
    Category('More', 'assets/icons/cat_more.svg', isSvg: true),
  ];

  static const banners = ['assets/images/banner_1.png', 'assets/images/banner_2.png'];

  static const googleAccounts = [
    GoogleAccount(email: 'brad.pitt@gmail.com'),
    GoogleAccount(name: 'Brad Pitt', email: 'brad86@gmail.com'),
    GoogleAccount(name: 'Brad Pitt', email: 'hollywoodkids@gmail.com'),
  ];

  static const transactions = [
    Transaction(title: 'Redeem HSBC point', date: '08 Okt 2026', amount: 100000),
    Transaction(title: 'Belanja - Culinary', date: '05 Okt 2026', amount: -45000),
    Transaction(title: 'Top up', date: '01 Okt 2026', amount: 500000),
    Transaction(title: 'Belanja - Apparel', date: '28 Sep 2026', amount: -275000),
    Transaction(title: 'Convert CIMB point', date: '20 Sep 2026', amount: 50000),
  ];

  static const inbox = [
    InboxMessage(
      title: 'Online March Treat!',
      body: 'Diskon s/d 50% + 10% untuk kategori Kids. Gunakan kode ELCTOYS10.',
      date: '09 Okt 2026',
    ),
    InboxMessage(title: 'Redeem berhasil', body: 'Poin HSBC kamu sudah masuk ke saldo reepo.', date: '08 Okt 2026'),
    InboxMessage(
      title: 'Selamat datang di reepo',
      body: 'Your Point is Your Currency. Kumpulkan dan tukarkan poinmu di sini.',
      date: '01 Okt 2026',
    ),
  ];

  static const topUpOptions = [50000, 100000, 250000, 500000];
}
