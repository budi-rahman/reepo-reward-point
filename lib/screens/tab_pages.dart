import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/dummy_data.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'register_screen.dart';

/// Halaman tab selain HOME. Tidak ada di Figma, dibuat sederhana dengan dummy data
/// agar bottom navigation bisa dicoba.
class _TabScaffold extends StatelessWidget {
  const _TabScaffold({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.red,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const Spacer(),
                  const MascotOutline(size: 32),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(13, 12, 13, 100 + MediaQuery.paddingOf(context).bottom),
            children: children,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: child,
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'HISTORY',
      children: [
        for (final t in DummyData.transactions)
          _Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: t.amount >= 0 ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                child: Icon(
                  t.amount >= 0 ? Icons.south_west : Icons.north_east,
                  color: t.amount >= 0 ? Colors.green : AppColors.red,
                  size: 20,
                ),
              ),
              title: Text(
                t.title,
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textBrown),
              ),
              subtitle: Text(t.date),
              trailing: Text(
                '${t.amount >= 0 ? '+' : ''}${formatNumber(t.amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: t.amount >= 0 ? Colors.green.shade700 : AppColors.red,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class DealsPage extends StatelessWidget {
  const DealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'DEALS',
      children: [
        for (final banner in DummyData.banners)
          _Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () => showComingSoon(context, 'Detail promo'),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 152 / 82,
                    child: Image.asset(banner, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      title: 'INBOX',
      children: [
        for (final m in DummyData.inbox)
          _Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.red,
                child: Icon(Icons.mail_outline, color: Colors.white, size: 20),
              ),
              title: Text(
                m.title,
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textBrown),
              ),
              subtitle: Text('${m.body}\n${m.date}'),
              isThreeLine: true,
            ),
          ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return _TabScaffold(
      title: 'PROFILE',
      children: [
        _Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const MascotOutline(size: 40),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reepo Member',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textBrown),
                      ),
                      Text(state.loggedInAs ?? '-', style: const TextStyle(color: AppColors.textBrown)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _Card(
          child: Column(
            children: [
              for (final item in const [
                (Icons.person_outline, 'Edit profil'),
                (Icons.account_balance_outlined, 'Akun bank terhubung'),
                (Icons.lock_outline, 'Keamanan'),
                (Icons.help_outline, 'Bantuan'),
              ])
                ListTile(
                  leading: Icon(item.$1, color: AppColors.red),
                  title: Text(item.$2, style: const TextStyle(color: AppColors.textBrown)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showComingSoon(context, item.$2),
                ),
            ],
          ),
        ),
        _Card(
          child: ListTile(
            leading: const Icon(Icons.logout, color: AppColors.red),
            title: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w700),
            ),
            onTap: () => Navigator.of(
              context,
            ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const RegisterScreen()), (_) => false),
          ),
        ),
        const Center(
          child: Text('version ${DummyData.appVersion}', style: TextStyle(color: AppColors.muted)),
        ),
      ],
    );
  }
}
