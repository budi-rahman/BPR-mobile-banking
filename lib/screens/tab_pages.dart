import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'login_screen.dart';

/// Kerangka tab beranda selain "Awal": header navy + lembar putih, mengikuti gaya frame "Menu".
class _TabPage extends StatelessWidget {
  const _TabPage({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        positionedGlow(left: -34, top: -10, width: 416, height: 89, sigma: 100),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView(padding: const EdgeInsets.fromLTRB(11, 22, 11, 130), children: children),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

const _sectionStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.menuLabel);

/// Tab "Rekening Saya": daftar rekening dan mutasi terakhir.
class AccountsTab extends StatelessWidget {
  const AccountsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => _TabPage(
        title: 'Rekening Saya',
        children: [
          for (final account in state.accounts)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(color: AppColors.balanceCard, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${account.type}  •  ${account.number}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: state.toggleBalance,
                        child: AppIcon(state.balanceVisible ? 'eye_crossed' : 'view', size: 25),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Rp  ${state.balanceVisible ? formatNumber(account.balance) : '**********'}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'VA Bank Permata: ${account.vaNumber}',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('Mutasi Terakhir', style: _sectionStyle),
          ),
          const SizedBox(height: 4),
          for (final m in state.mutations)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: Text(m.title, style: const TextStyle(fontSize: 14)),
              subtitle: Text(m.date, style: const TextStyle(fontSize: 12)),
              trailing: Text(
                '${m.amount < 0 ? '-' : '+'} Rp ${formatNumber(m.amount.abs())}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: m.amount < 0 ? const Color(0xFFD32F2F) : AppColors.teal,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Tab "Hub Kami". Kontak di sini hanya data dummy.
class ContactTab extends StatelessWidget {
  const ContactTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.headset_mic_outlined, 'Call Center', '1500-XXX (dummy)'),
      (Icons.chat_outlined, 'WhatsApp', '+62 8XX-XXXX-XXXX (dummy)'),
      (Icons.mail_outline, 'Email', 'cs@contoh-bprvaria.id (dummy)'),
      (Icons.location_on_outlined, 'Kantor Pusat', 'BPR Varia Central Artha'),
    ];
    return _TabPage(
      title: 'Hub Kami',
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: Text('Butuh bantuan? Hubungi kami melalui:', style: _sectionStyle),
        ),
        for (final (icon, title, value) in items)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            leading: CircleAvatar(
              backgroundColor: AppColors.blue,
              child: Icon(icon, color: Colors.white),
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(value),
            onTap: () => showComingSoon(context, title),
          ),
      ],
    );
  }
}

/// Tab "Pengaturan" dengan tombol keluar.
class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _notifications = true;

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari Mobile Banking BPR Varia?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Keluar')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    AppState.instance.logout();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return _TabPage(
      title: 'Pengaturan',
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.avatarRing,
            backgroundImage: const AssetImage('assets/images/avatar.png'),
          ),
          title: Text(state.customerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          subtitle: Text('User ID: ${state.userId.isEmpty ? '-' : state.userId}'),
        ),
        const Divider(),
        _tile(Icons.lock_outline, 'Ubah Password', () => showComingSoon(context, 'Ubah Password')),
        _tile(Icons.pin_outlined, 'Ubah PIN Transaksi', () => showComingSoon(context, 'Ubah PIN Transaksi')),
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          secondary: const Icon(Icons.notifications_none, color: AppColors.navy),
          title: const Text('Notifikasi'),
          value: _notifications,
          onChanged: (v) => setState(() => _notifications = v),
        ),
        _tile(
          Icons.info_outline,
          'Tentang Aplikasi',
          () => showAboutDialog(
            context: context,
            applicationName: 'BPR Varia Mobile Banking',
            applicationVersion: '0.1.0 (mockup)',
            applicationIcon: const BprLogo(width: 56),
            children: const [Text('Mockup frontend dengan data dummy, belum terhubung ke sistem bank.')],
          ),
        ),
        const Divider(),
        _tile(Icons.logout, 'Keluar', _logout, color: const Color(0xFFD32F2F)),
      ],
    );
  }

  Widget _tile(IconData icon, String title, VoidCallback onTap, {Color color = AppColors.navy}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color == AppColors.navy ? null : color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
