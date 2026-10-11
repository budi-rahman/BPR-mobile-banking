import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/form_fields.dart';
import 'home_screen.dart';
import 'registration_screen.dart';

/// Frame "Login and Registration".
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userId = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _userId.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (_userId.text.trim().isEmpty || _password.text.isEmpty) {
      showMessage(context, 'User ID dan Password wajib diisi');
      return;
    }
    FocusScope.of(context).unfocus();
    AppState.instance.login(_userId.text.trim());
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
        settings: const RouteSettings(name: homeRouteName),
      ),
      (_) => false,
    );
  }

  void _forgotPassword() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lupa Password'),
        content: const Text(
          'Untuk mengatur ulang password, silakan hubungi Call Center BPR Varia '
          'atau datang ke kantor cabang terdekat dengan membawa KTP.',
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const linkStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.link);
    return StatusBarStyle(
      light: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 54),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 285),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BprLogo(),
                    _row('User ID', GreyInput(controller: _userId, label: 'User ID')),
                    const SizedBox(height: 18),
                    _row(
                      'Password',
                      GreyInput(
                        controller: _password,
                        obscure: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _login(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _forgotPassword,
                          child: const Text('Lupa Password', style: linkStyle),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegistrationScreen())),
                          child: const Text('Buka Rekening', style: linkStyle),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.only(left: 77),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FlatButtonBox(
                          label: 'Lanjut',
                          onPressed: _login,
                          textColor: AppColors.loginButtonText,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, Widget field) {
    return Row(
      children: [
        SizedBox(width: 77, child: Text(label, style: const TextStyle(fontSize: 15))),
        Expanded(child: field),
      ],
    );
  }
}
