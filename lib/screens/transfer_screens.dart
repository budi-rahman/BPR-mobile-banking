import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_state.dart';
import '../data/dummy_data.dart';
import '../theme.dart';
import '../widgets/common.dart';

const _footerNote =
    'Pengiriman uang bekerjasama dengan  Bank Permata yang dalam hal ini menjadi Bank Persepsi dari '
    'BPR Varia Central Artha.';

const _brownBold = TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.menuLabel);

enum TransferType { account, bank }

/// Kerangka layar pengiriman uang: header, isi yang bisa di-scroll, catatan kaki & tombol home.
class _TransferScaffold extends StatelessWidget {
  const _TransferScaffold({required this.navy, required this.children});

  /// Header navy (frame "Pengiriman Uang") atau tosca (form & receipt).
  final bool navy;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return StatusBarStyle(
      light: navy,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _TransferHeader(navy: navy),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
              ),
            ),
            if (!keyboardOpen)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 14, 19),
                  child: Column(
                    children: [
                      const Text(_footerNote, style: TextStyle(fontSize: 10, color: Colors.black)),
                      const SizedBox(height: 21),
                      const HomeCircleButton(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TransferHeader extends StatelessWidget {
  const _TransferHeader({required this.navy});

  final bool navy;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: navy ? AppColors.navy : AppColors.tealHeader,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 75,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 30,
                top: 17,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Container(
                    width: 202,
                    height: 46,
                    padding: const EdgeInsets.only(left: 64),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: navy ? AppColors.pill.withValues(alpha: 0.7) : AppColors.beige,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Pengiriman Uang',
                      style: _brownBold.copyWith(color: navy ? const Color(0xFFFFFCFC) : AppColors.menuLabel),
                    ),
                  ),
                ),
              ),
              if (navy)
                Positioned(
                  left: 29,
                  top: -4,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(color: AppColors.pill, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const AppIcon('transfer'),
                  ),
                )
              else
                Positioned(
                  left: 30,
                  top: 1,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(color: AppColors.beige, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const AppIcon('transfer_badge', size: 50),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kartu tosca berisi rekening sumber, saldo, rekening VA Permata & status.
class _AccountCard extends StatelessWidget {
  const _AccountCard();

  Future<void> _chooseAccount(BuildContext context) async {
    final state = AppState.instance;
    final labels = [for (final a in state.accounts) '${a.number}  •  ${a.type}'];
    final picked = await pickOption(
      context,
      'Pilih Rekening Tabungan',
      labels,
      selected: labels[state.selectedAccountIndex],
    );
    if (picked != null) state.selectAccount(labels.indexOf(picked));
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    const muted = TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textMuted);
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final account = state.selectedAccount;
        return Container(
          margin: const EdgeInsets.fromLTRB(19, 29, 29, 0),
          padding: const EdgeInsets.fromLTRB(11, 21, 11, 10),
          decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LabelBox('Rekening Tabungan', width: 164),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _chooseAccount(context),
                child: _ValueBox(
                  width: 164,
                  child: Row(
                    children: [
                      Expanded(child: Text(account.number, style: muted)),
                      const AppIcon('down', size: 20, opacity: 0.2),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const LabelBox('Saldo Tabungan', width: 164),
              const SizedBox(height: 8),
              _ValueBox(width: 164, child: Text('Rp  ${formatNumber(account.balance)}', style: _brownBold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(child: LabelBox('Rekening VA Bank Permata')),
                  const SizedBox(width: 14),
                  const LabelBox('Status', width: 70),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _ValueBox(child: Text(account.vaNumber, style: muted)),
                  ),
                  const SizedBox(width: 14),
                  const _ValueBox(
                    width: 70,
                    child: Center(child: Text('Aktif', style: muted)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ValueBox extends StatelessWidget {
  const _ValueBox({required this.child, this.width, this.height = 23});

  final Widget child;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: AppColors.beige, borderRadius: BorderRadius.circular(5)),
      child: child,
    );
  }
}

/// Kotak judul krem ("PENGIRIMAN ANTAR REKENING").
class _TitlePill extends StatelessWidget {
  const _TitlePill(this.text, {required this.width, this.height = 37, this.leftPadding = 13});

  final String text;
  final double width;
  final double height;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(left: leftPadding),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: AppColors.beige, borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: _brownBold),
    );
  }
}

/// Frame "Pengiriman Uang".
class TransferMenuScreen extends StatelessWidget {
  const TransferMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _TransferScaffold(
      navy: true,
      children: [
        const _AccountCard(),
        const SizedBox(height: 55),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _option(context, 'Antar Rekening', 'antar_rekening', TransferType.account),
            _option(context, 'Antar Bank', 'antar_bank', TransferType.bank),
          ],
        ),
      ],
    );
  }

  Widget _option(BuildContext context, String label, String icon, TransferType type) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TransferFormScreen(type: type))),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Text(label, style: _brownBold),
            const SizedBox(height: 13),
            ClipOval(child: AppIcon(icon, size: 70)),
          ],
        ),
      ),
    );
  }
}

/// Frame "Pengiriman Uang Antar Rekening" & "Pengiriman Uang Antar Bank".
class TransferFormScreen extends StatefulWidget {
  const TransferFormScreen({super.key, required this.type});

  final TransferType type;

  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  final _recipient = TextEditingController();
  final _amount = TextEditingController();
  String _bank = DummyData.banks.first;
  int _method = 0;

  bool get _isBank => widget.type == TransferType.bank;

  @override
  void initState() {
    super.initState();
    _recipient.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _recipient.dispose();
    _amount.dispose();
    super.dispose();
  }

  String? get _recipientName {
    final number = _recipient.text;
    if (number.length < 6) return null;
    return DummyData.recipients[number] ??
        DummyData.fallbackRecipients[int.parse(number.substring(number.length - 4)) %
            DummyData.fallbackRecipients.length];
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final account = AppState.instance.selectedAccount;
    final amount = parseAmount(_amount.text);
    final method = _isBank ? DummyData.transferMethods[_method] : null;
    final fee = method?.fee ?? 0;
    final name = _recipientName;

    String? error;
    if (name == null) {
      error = 'Nomor rekening penerima minimal 6 digit';
    } else if (!_isBank && _recipient.text == account.number) {
      error = 'Rekening penerima tidak boleh sama dengan rekening sumber';
    } else if (amount < 10000) {
      error = 'Jumlah minimal Rp 10,000';
    } else if (method != null && amount < method.minAmount) {
      error = '${method.name} hanya untuk pengiriman lebih dari Rp ${formatNumber(method.minAmount - 1)}';
    } else if (method?.maxAmount != null && amount > method!.maxAmount!) {
      error = 'Maksimal ${method.name} Rp ${formatNumber(method.maxAmount!)}';
    } else if (amount + fee > account.balance) {
      error = 'Saldo tidak mencukupi';
    }
    if (error != null) {
      showMessage(context, error);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TransferReceiptScreen(
          transfer: TransferData(
            type: widget.type,
            bank: _isBank ? _bank : 'BPR VARIA',
            accountNumber: _recipient.text,
            recipient: name!,
            amount: amount,
            fee: fee,
            method: method?.name,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _recipientName;
    return _TransferScaffold(
      navy: false,
      children: [
        const _AccountCard(),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isBank
                  ? const _TitlePill('PENGIRIMAN ANTAR BANK', width: 218, height: 43, leftPadding: 9)
                  : const _TitlePill('PENGIRIMAN ANTAR REKENING', width: 261),
              SizedBox(height: _isBank ? 13 : 16),
              if (_isBank) ...[
                _row(
                  'Bank Tujuan',
                  109,
                  GestureDetector(
                    onTap: () async {
                      final picked = await pickOption(context, 'Bank Tujuan', DummyData.banks, selected: _bank);
                      if (picked != null) setState(() => _bank = picked);
                    },
                    child: _InputBox(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(_bank, style: _brownBold, overflow: TextOverflow.ellipsis),
                          ),
                          const AppIcon('down', size: 20, opacity: 0.2),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              _row(
                'Penerima Uang',
                129,
                _InputBox(
                  child: TextField(
                    controller: _recipient,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
                    style: _brownBold,
                    decoration: _inputDecoration('No. Rekening'),
                  ),
                ),
              ),
              if (name != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 164),
                  child: Text(
                    'a.n. $name',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.teal),
                  ),
                ),
              const SizedBox(height: 8),
              _row(
                'Jumlah',
                74,
                _InputBox(
                  child: Row(
                    children: [
                      const Text('Rp  ', style: _brownBold),
                      Expanded(
                        child: TextField(
                          controller: _amount,
                          keyboardType: TextInputType.number,
                          inputFormatters: [ThousandsFormatter(), LengthLimitingTextInputFormatter(14)],
                          style: _brownBold,
                          decoration: _inputDecoration('0'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isBank) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var i = 0; i < DummyData.transferMethods.length; i++)
                      _MethodTile(
                        method: DummyData.transferMethods[i],
                        selected: _method == i,
                        onTap: () => setState(() => _method = i),
                      ),
                  ],
                ),
              ],
              SizedBox(height: _isBank ? 23 : 120),
              FlatButtonBox(
                label: 'Lanjut',
                onPressed: _submit,
                color: AppColors.beige,
                width: 78,
                height: 32,
                fontSize: 15,
                weight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    isCollapsed: true,
    border: InputBorder.none,
    hintText: hint,
    hintStyle: _brownBold.copyWith(color: AppColors.textMuted),
  );

  /// Chip label di kiri (lebar sesuai Figma) dan kotak input di kanan (mulai x=194).
  Widget _row(String label, double chipWidth, Widget input) {
    return Row(
      children: [
        SizedBox(
          width: 164,
          child: Align(
            alignment: Alignment.centerLeft,
            child: LabelBox(label, width: chipWidth, height: 32),
          ),
        ),
        Expanded(child: input),
      ],
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => _ValueBox(height: 32, child: child);
}

/// Pilihan BI FAST / Online / SKN / RTGS dengan bayangan abu-abu seperti di Figma.
class _MethodTile extends StatelessWidget {
  const _MethodTile({required this.method, required this.selected, required this.onTap});

  final TransferMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : AppColors.tileText;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70,
        height: 54,
        child: Stack(
          children: [
            Positioned(
              left: 4,
              top: 3,
              child: Container(
                width: 66,
                height: 51,
                decoration: BoxDecoration(color: AppColors.tileShadow, borderRadius: BorderRadius.circular(5)),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 65,
              height: 49,
              padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
              decoration: BoxDecoration(
                color: selected ? AppColors.turquoise : AppColors.mint,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.name, style: TextStyle(fontSize: 10, color: textColor, height: 1.1)),
                  const SizedBox(height: 2),
                  Text(
                    method.description,
                    maxLines: 4,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 6, color: textColor, height: 1.15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransferData {
  const TransferData({
    required this.type,
    required this.bank,
    required this.accountNumber,
    required this.recipient,
    required this.amount,
    required this.fee,
    this.method,
  });

  final TransferType type;
  final String bank;
  final String accountNumber;
  final String recipient;
  final int amount;
  final int fee;
  final String? method;

  int get total => amount + fee;

  String get title => type == TransferType.bank ? 'PENGIRIMAN ANTAR BANK' : 'PENGIRIMAN ANTAR REKENING';
}

/// Frame "Reciept ... Query" (konfirmasi, tombol SETUJU) dan "Reciept ... Status" (SUKSES).
class TransferReceiptScreen extends StatefulWidget {
  const TransferReceiptScreen({super.key, required this.transfer, this.success = false});

  final TransferData transfer;
  final bool success;

  @override
  State<TransferReceiptScreen> createState() => _TransferReceiptScreenState();
}

class _TransferReceiptScreenState extends State<TransferReceiptScreen> {
  bool _processing = false;

  Future<void> _approve() async {
    setState(() => _processing = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final t = widget.transfer;
    AppState.instance.debit(t.total, 'Transfer ke ${t.bank} - ${t.recipient}');
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => TransferReceiptScreen(transfer: t, success: true)));
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.transfer;
    return PopScope(
      // Setelah sukses, tombol kembali langsung ke beranda.
      canPop: !widget.success,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).popUntil((r) => r.settings.name == homeRouteName || r.isFirst);
      },
      child: _TransferScaffold(
        navy: false,
        children: [
          const SizedBox(height: 85),
          Center(child: _TitlePill(t.title, width: 261, leftPadding: 13)),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.only(left: 52, right: 20),
            child: Column(
              children: [
                _ReceiptRow('Bank tujuan', Text(t.bank, style: _receiptValue)),
                _ReceiptRow('Penerima uang', Text(t.recipient, style: _receiptValue)),
                _ReceiptRow('Jumlah', _money(t.amount), gapAfter: 5),
                _ReceiptRow('Biaya', _money(t.fee)),
                _ReceiptRow('Total uang', _money(t.total)),
              ],
            ),
          ),
          if (widget.success) ...[
            const SizedBox(height: 80),
            const Center(
              child: Text(
                'Mohon lakukan pengecekan\nRekening Penerima',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ),
            const SizedBox(height: 48),
          ] else
            const SizedBox(height: 150),
          Center(
            child: widget.success
                ? const _OrangeBox(
                    width: 85,
                    child: Center(child: Text('SUKSES', style: _receiptValue)),
                  )
                : GestureDetector(
                    onTap: _processing ? null : _approve,
                    child: _OrangeBox(
                      width: 85,
                      child: Center(
                        child: _processing
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('SETUJU', style: _receiptValue),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _money(int value) => Row(
    children: [
      const Text('Rp', style: _receiptValue),
      const Spacer(),
      Text(formatNumber(value), style: _receiptValue),
    ],
  );
}

const _receiptValue = TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1);

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow(this.label, this.value, {this.gapAfter = 0});

  final String label;
  final Widget value;
  final double gapAfter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5 + gapAfter),
      child: Row(
        children: [
          SizedBox(
            width: 134,
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.menuLabel),
            ),
          ),
          _OrangeBox(width: 150, child: value),
        ],
      ),
    );
  }
}

/// Kotak oranye (rgba(247,139,40,0.8)) dengan bayangan krem 3px di bawahnya.
class _OrangeBox extends StatelessWidget {
  const _OrangeBox({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width + 2,
      height: 23,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 3,
            child: Container(
              width: width + 2,
              height: 20,
              decoration: BoxDecoration(color: AppColors.orangeShadow, borderRadius: BorderRadius.circular(5)),
            ),
          ),
          Container(
            width: width,
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 7),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(5)),
            child: child,
          ),
        ],
      ),
    );
  }
}
