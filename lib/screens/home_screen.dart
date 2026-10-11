import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/dummy_data.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'promo_screen.dart';
import 'tab_pages.dart';
import 'transfer_screens.dart';

/// Frame "Menu": beranda dengan navigasi bawah (Awal, Rekening Saya, Scan, Hub Kami, Pengaturan).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _tab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    return StatusBarStyle(
      light: true,
      child: PopScope(
        canPop: _tab == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) setState(() => _tab = 0);
        },
        child: Scaffold(
          backgroundColor: AppColors.navy,
          extendBody: true,
          body: switch (_tab) {
            1 => const AccountsTab(),
            2 => const ContactTab(),
            3 => const SettingsTab(),
            _ => _HomeTab(onOpenTab: (tab) => setState(() => _tab = tab)),
          },
          bottomNavigationBar: _BottomNav(
            current: _tab,
            onSelect: (tab) => setState(() => _tab = tab),
            onScan: () => showComingSoon(context, 'Scan QRIS'),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.label, this.icon, this.color, this.onTap);

  final String label;
  final String icon;
  final Color color;
  final void Function(BuildContext context) onTap;
}

class _HomeTab extends StatefulWidget {
  const _HomeTab({required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  final _search = TextEditingController();

  late final _menu = [
    _MenuItem('Pengiriman\nUang', 'transfer', AppColors.blue, (context) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TransferMenuScreen()));
    }),
    _MenuItem('Deposito', 'wallet', AppColors.navy, (context) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => PromoScreen(promo: DummyData.promos[1])));
    }),
    _MenuItem('Tagihan &\nTop up', 'receipt', AppColors.blue, (context) => showComingSoon(context, 'Tagihan & Top up')),
    _MenuItem('Tabungan', 'rupiah', AppColors.navy, (_) => widget.onOpenTab(1)),
    _MenuItem('Pinjaman\nQu', 'hand', AppColors.navy, (context) => showComingSoon(context, 'Pinjaman Qu')),
    _MenuItem('Tarik\nTunai', 'atm', AppColors.blue, (context) => showComingSoon(context, 'Tarik Tunai')),
    _MenuItem(
      'Belanja\nOnline',
      'shopping_cart',
      AppColors.navy,
      (context) => showComingSoon(context, 'Belanja Online'),
    ),
    _MenuItem('Akses\nUsaha', 'deal', AppColors.blue, (context) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => PromoScreen(promo: DummyData.promos[3])));
    }),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi!';
    if (hour < 15) return 'Selamat Siang!';
    if (hour < 18) return 'Selamat Sore!';
    return 'Selamat Malam!';
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return;
    for (final item in _menu) {
      if (item.label.replaceAll('\n', ' ').toLowerCase().contains(q)) {
        _search.clear();
        item.onTap(context);
        return;
      }
    }
    showMessage(context, 'Menu "$query" tidak ditemukan');
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Stack(
      fit: StackFit.expand,
      children: [
        // "Mesh Color Background" & "Ellipse 27" di Figma.
        positionedGlow(left: -34, top: -10, width: 416, height: 89, sigma: 100),
        positionedGlow(left: 282, top: 100, width: 100, height: 47, sigma: 50),
        Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 14, 14, 31),
                child: Column(
                  children: [
                    Container(
                      height: 43,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          const SizedBox(width: 7),
                          const AppIcon('search', size: 25),
                          Expanded(
                            child: TextField(
                              controller: _search,
                              textInputAction: TextInputAction.search,
                              onSubmitted: _onSearch,
                              style: const TextStyle(fontSize: 15),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const DecoratedBox(
                                decoration: BoxDecoration(color: AppColors.avatarRing, shape: BoxShape.circle),
                                child: SizedBox.expand(),
                              ),
                              Positioned(
                                left: 7,
                                top: -1,
                                child: Image.asset('assets/images/avatar.png', width: 65, height: 65),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _greeting,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                state.customerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView(
                  padding: const EdgeInsets.only(top: 22, bottom: 130),
                  children: [
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 11), child: _BalanceCard()),
                    const SizedBox(height: 44),
                    _menuRow(_menu.sublist(0, 4)),
                    _menuRow(_menu.sublist(4)),
                    const SizedBox(height: 8),
                    const _PromoStrip(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _menuRow(List<_MenuItem> items) {
    return SizedBox(
      height: 113,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [for (final item in items) _MenuButton(item)],
      ),
    );
  }
}

/// "Rekening Tabungan anda" + tombol mata untuk menampilkan/menyembunyikan saldo.
class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    const textStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white);
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => Container(
        height: 68,
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 0),
        decoration: BoxDecoration(color: AppColors.balanceCard, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rekening Tabungan anda',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                GestureDetector(
                  onTap: state.toggleBalance,
                  behavior: HitTestBehavior.opaque,
                  child: AppIcon(state.balanceVisible ? 'eye_crossed' : 'view', size: 25),
                ),
                const SizedBox(width: 5),
                const Text(' Rp ', style: textStyle),
                const SizedBox(width: 5),
                Text(
                  state.balanceVisible ? formatNumber(state.selectedAccount.balance) : '**********',
                  style: textStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton(this.item);

  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => item.onTap(context),
        child: Column(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
                    child: const SizedBox.expand(),
                  ),
                  AppIcon(item.icon),
                  // Hiasan cat warna-warni pada "Pinjaman Qu".
                  if (item.icon == 'hand')
                    Positioned(
                      left: 25,
                      top: 32,
                      child: Image.asset('assets/images/pinjaman_badge.png', width: 30, height: 18.281),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: AppColors.menuLabel, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

/// Deretan thumbnail promo yang bisa digeser ke samping.
class _PromoStrip extends StatelessWidget {
  const _PromoStrip();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: DummyData.promos.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final promo = DummyData.promos[i];
          final height = promo.thumbWidth == 84 ? 84.0 : 82.0;
          return GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PromoScreen(promo: promo))),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: promo.thumbWidth,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [BoxShadow(color: Color(0x40000000), offset: Offset(0, 4), blurRadius: 2)],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(promo.image, width: promo.thumbWidth, height: height, fit: BoxFit.cover),
                    ),
                    if (promo.thumbLogoSize != null)
                      Positioned(
                        left: promo.thumbLogoOffset!.$1,
                        top: promo.thumbLogoOffset!.$2,
                        child: BprLogo(width: promo.thumbLogoSize!),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.current, required this.onSelect, required this.onScan});

  final int current;
  final ValueChanged<int> onSelect;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: 83 + 34 + bottomInset,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 83 + bottomInset,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: ColoredBox(
                color: AppColors.navy,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // "Ellipse 34" & "Ellipse 35" di Figma.
                    positionedGlow(right: 0, top: 36, width: 101, height: 22, sigma: 25),
                    positionedGlow(left: -4, top: 54, width: 75, height: 24, sigma: 25),
                    Padding(
                      padding: EdgeInsets.only(top: 7, bottom: bottomInset),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _item(0, 'home_nav', 'Awal'),
                          _item(1, 'credit_card', 'Rekening Saya'),
                          const Expanded(child: SizedBox()),
                          _item(2, 'headset', 'Hub Kami'),
                          _item(3, 'settings', 'Pengaturan'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tombol scan di tengah (Ellipse 14 putih + Ellipse 15 navy).
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onScan,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const AppIcon('scan'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(int index, String icon, String label) {
    final selected = current == index;
    return Expanded(
      child: InkWell(
        onTap: () => onSelect(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(icon),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
