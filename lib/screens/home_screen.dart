import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/app_state.dart';
import '../data/dummy_data.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'redeem_screen.dart';
import 'tab_pages.dart';

/// Figma: "Main Menu 1" (+ dropdown bank "Main Menu 7", unit POINT "Main Menu 8").
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeTab(onOpenDeals: () => setState(() => _tab = 2)),
      const HistoryPage(),
      const DealsPage(),
      const InboxPage(),
      const ProfilePage(),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        body: Stack(
          children: [
            Positioned.fill(
              child: IndexedStack(index: _tab, children: pages),
            ),
            Positioned(
              left: 13,
              right: 13,
              bottom: 16 + MediaQuery.paddingOf(context).bottom,
              child: _BottomNav(current: _tab, onTap: (i) => setState(() => _tab = i)),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.onOpenDeals});
  final VoidCallback onOpenDeals;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) => Column(
        children: [
          _Header(onOpenDeals: onOpenDeals),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.redGradientTop, Color(0xFFFF6A6A), Color(0xFFFFE3E3)],
                  stops: [0, 0.55, 1],
                ),
              ),
              child: ListView(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 100 + MediaQuery.paddingOf(context).bottom),
                children: [
                  const _CategoryCard(),
                  const SizedBox(height: 14),
                  _BannerStrip(onTap: onOpenDeals),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header merah: scan / reepo / cart, kartu saldo, dan tombol aksi.
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.onOpenDeals});
  final VoidCallback onOpenDeals;

  @override
  Widget build(BuildContext context) {
    const actionHeight = 54.0;
    return Stack(
      children: [
        // Latar merah berhenti di tengah tombol aksi, seperti di desain.
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: actionHeight / 2,
          child: const ColoredBox(color: AppColors.red),
        ),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              const _TopBar(),
              const SizedBox(height: 4),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: _BalanceCards()),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SizedBox(
                  height: actionHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ActionButton(
                        label: 'TOP UP',
                        icon: SvgPicture.asset('assets/icons/topup.svg', width: 17, height: 20),
                        badge: true,
                        onTap: () => _showTopUp(context),
                      ),
                      _ActionButton(
                        label: 'REDEEM',
                        icon: const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 22),
                        badge: true,
                        onTap: onOpenDeals,
                      ),
                      _ActionButton(
                        label: 'REDEEM',
                        icon: const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 22),
                        onTap: () => _openRedeem(context),
                      ),
                      _ActionButton(
                        label: 'CONVERT',
                        icon: const Icon(Icons.sync, color: Colors.white, size: 24),
                        onTap: () => _showConvert(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    const label = TextStyle(fontSize: 15, color: Colors.white, height: 1.2);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => showComingSoon(context, 'Scan QR'),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('scan', style: label),
                Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
              ],
            ),
          ),
          const Spacer(),
          const Column(children: [ReepoWordmark(size: 16), SizedBox(height: 4), MascotOutline(size: 32)]),
          const Spacer(),
          InkWell(
            onTap: () => showComingSoon(context, 'Keranjang'),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('cart', style: label),
                Icon(Icons.shopping_basket_outlined, color: Colors.white, size: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCards extends StatelessWidget {
  const _BalanceCards();

  static const _cardDecoration = BoxDecoration(
    color: AppColors.red,
    borderRadius: BorderRadius.all(Radius.circular(5)),
    boxShadow: [BoxShadow(color: Color(0x40000000), offset: Offset(0, 4), blurRadius: 4)],
  );
  static const _label = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.offWhite, height: 1.1);
  static const _amount = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, height: 1.15);

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final bank = state.selectedBank;

    return SizedBox(
      height: 54,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Saldo reepo
          Expanded(
            flex: 141,
            child: Container(
              decoration: _cardDecoration,
              padding: const EdgeInsets.fromLTRB(14, 6, 10, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('IDR', style: _label),
                      SizedBox(width: 16),
                      ReepoWordmark(size: 16),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(child: Text(formatNumber(state.reepoBalance), style: _amount)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Saldo bank lain
          Expanded(
            flex: 163,
            child: Container(
              decoration: _cardDecoration,
              padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Other', style: _label),
                      const Spacer(),
                      _WhiteChip(
                        width: 21,
                        onTap: () => _openRedeem(context),
                        child: const Text(
                          '>>',
                          style: TextStyle(fontFamily: AppFonts.brand, fontSize: 13, color: AppColors.red, height: 1),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const _BankSelector(),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('in', style: _label),
                      const SizedBox(width: 10),
                      Text(bank.unit, style: _label),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FittedBox(child: Text(formatNumber(bank.balance), style: _amount)),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteChip extends StatelessWidget {
  const _WhiteChip({required this.width, required this.child, this.onTap});
  final double width;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.offWhite,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: 19,
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Dropdown bank (HSBC / CIMB / CITI) — Figma "Main Menu 7".
class _BankSelector extends StatelessWidget {
  const _BankSelector();

  static const _style = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.red, height: 1);

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return MenuAnchor(
      alignmentOffset: const Offset(0, 2),
      style: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      menuChildren: [
        for (var i = 0; i < state.banks.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Builder(
              builder: (itemContext) => _WhiteChip(
                width: 66,
                onTap: () {
                  state.selectBank(i);
                  MenuController.maybeOf(itemContext)?.close();
                },
                child: Text(state.banks[i].name, style: _style),
              ),
            ),
          ),
      ],
      builder: (context, controller, _) => _WhiteChip(
        width: 66,
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.selectedBank.name, style: _style),
            const Icon(Icons.arrow_drop_down, size: 14, color: AppColors.red),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.icon, required this.onTap, this.badge = false});

  final String label;
  final Widget icon;
  final VoidCallback onTap;

  /// Maskot kecil di pojok kanan atas (TOP UP & REDEEM pertama).
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 54,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: Color(0x40000000), offset: Offset(0, 4), blurRadius: 10)],
              ),
              child: Material(
                color: AppColors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: AppColors.borderWhite, width: 2),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: onTap,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 24, child: Center(child: icon)),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (badge)
            Positioned(
              right: 4,
              top: 5,
              child: IgnorePointer(child: SvgPicture.asset('assets/icons/mascot_badge.svg', width: 15, height: 15)),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Konten: kartu kategori & banner promo.
// ---------------------------------------------------------------------------

class _CategoryCard extends StatelessWidget {
  const _CategoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13),
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFCFF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Color(0x40000000), offset: Offset(0, 4), blurRadius: 8)],
      ),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        childAspectRatio: 0.95,
        children: [
          for (final c in DummyData.categories)
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => showComingSoon(context, 'Kategori ${c.label}'),
              child: Column(
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: Center(
                      child: c.isSvg
                          ? SvgPicture.asset(c.image, width: 30, height: 30)
                          : Image.asset(c.image, width: 52, height: 52, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(c.label, style: const TextStyle(fontSize: 13, color: AppColors.textBrown)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _BannerStrip extends StatelessWidget {
  const _BannerStrip({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemCount: DummyData.banners.length * 2,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => GestureDetector(
          onTap: onTap,
          child: Container(
            width: 152,
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [BoxShadow(color: Color(0x40000000), offset: Offset(0, 4), blurRadius: 2)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(DummyData.banners[i % DummyData.banners.length], fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom navigation (pill putih).
// ---------------------------------------------------------------------------

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.current, required this.onTap});
  final int current;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const brown = AppColors.textBrown;
    final items = <(String, Widget)>[
      ('HOME', SvgPicture.asset('assets/icons/nav_home.svg', width: 25, height: 25)),
      ('HISTORY', SvgPicture.asset('assets/icons/nav_history.svg', width: 25, height: 25)),
      (
        'DEALS',
        Transform.flip(flipY: true, child: SvgPicture.asset('assets/icons/nav_deals.svg', width: 25, height: 22)),
      ),
      ('INBOX', const Icon(Icons.download_outlined, color: brown, size: 26)),
      ('PROFILE', SvgPicture.asset('assets/icons/nav_profile.svg', width: 25, height: 25)),
    ];

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => onTap(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 25, child: Center(child: items[i].$2)),
                    Text(
                      items[i].$1,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.1,
                        color: i == current ? AppColors.red : brown,
                        fontWeight: i == current ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Aksi
// ---------------------------------------------------------------------------

void _openRedeem(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RedeemScreen()));
}

Future<void> _showConvert(BuildContext context) async {
  final state = AppState.instance;
  final index = await showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              'Convert poin ke saldo reepo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textBrown),
            ),
          ),
          for (var i = 0; i < state.banks.length; i++)
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.red,
                child: Icon(Icons.account_balance, color: Colors.white, size: 20),
              ),
              title: Text(state.banks[i].name, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(
                '${formatNumber(state.banks[i].balance)} ${state.banks[i].unit}'
                ' ≈ IDR ${formatNumber(state.banks[i].valueInIdr)}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pop(context, i),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  if (index == null || !context.mounted) return;
  state.selectBank(index);
  _openRedeem(context);
}

Future<void> _showTopUp(BuildContext context) async {
  final amount = await showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top up saldo reepo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textBrown),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final v in DummyData.topUpOptions)
                  ActionChip(
                    label: Text('IDR ${formatNumber(v)}'),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.red),
                    side: const BorderSide(color: AppColors.red),
                    backgroundColor: AppColors.offWhite,
                    onPressed: () => Navigator.pop(context, v),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  if (amount == null || !context.mounted) return;
  AppState.instance.topUp(amount);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('Top up IDR ${formatNumber(amount)} berhasil (dummy)')));
}
