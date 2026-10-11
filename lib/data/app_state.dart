import 'package:flutter/foundation.dart';

import 'dummy_data.dart';

/// State sederhana di memori untuk mockup (tanpa backend).
class AppState extends ChangeNotifier {
  AppState._();
  static final instance = AppState._();

  String userId = '';
  String customerName = DummyData.customerName;
  bool balanceVisible = false;

  List<SavingsAccount> accounts = List.of(DummyData.accounts);
  List<Mutation> mutations = List.of(DummyData.mutations);
  int selectedAccountIndex = 0;

  SavingsAccount get selectedAccount => accounts[selectedAccountIndex];

  void login(String id) {
    userId = id;
    notifyListeners();
  }

  void logout() {
    userId = '';
    balanceVisible = false;
    notifyListeners();
  }

  void toggleBalance() {
    balanceVisible = !balanceVisible;
    notifyListeners();
  }

  void selectAccount(int index) {
    selectedAccountIndex = index;
    notifyListeners();
  }

  /// Memotong saldo rekening terpilih dan mencatat mutasinya.
  void debit(int total, String description) {
    final account = selectedAccount;
    accounts[selectedAccountIndex] = account.copyWith(balance: account.balance - total);
    mutations.insert(0, Mutation(date: 'Hari ini', title: description, amount: -total));
    notifyListeners();
  }
}

/// Format angka dengan pemisah ribuan koma, sesuai desain ("23,083,023").
String formatNumber(int value) {
  final negative = value < 0;
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '${negative ? '-' : ''}$buffer';
}

int parseAmount(String text) => int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
