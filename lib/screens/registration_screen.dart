import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/form_fields.dart';
import 'onboarding_screens.dart';
import 'registration_form_screen.dart';

/// Frame "Registration": cek data awal calon nasabah.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _name = TextEditingController();
  final _birthDate = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _birthDate.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _next() {
    if (_name.text.trim().isEmpty || _birthDate.text.isEmpty || _phone.text.isEmpty) {
      showMessage(context, 'Mohon diisi semua data');
      return;
    }
    if (_phone.text.length < 10) {
      showMessage(context, 'No telp minimal 10 digit');
      return;
    }
    FocusScope.of(context).unfocus();
    final registered = DummyData.registeredPhones.contains(_phone.text);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => registered
            ? const KtpFoundScreen()
            : RegistrationFormScreen(
                initial: RegistrationDraft(fullName: _name.text.trim(), birthDate: _birthDate.text, phone: _phone.text),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarStyle(
      light: false,
      child: Scaffold(
        backgroundColor: AppColors.beige,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(43, 0, 43, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: BprLogo(width: 125)),
                const SizedBox(height: 43),
                const LabelBox(
                  'Mohon diisi',
                  color: AppColors.chip,
                  width: 117,
                  height: 30,
                  weight: FontWeight.w500,
                  padding: EdgeInsets.only(left: 16),
                ),
                const SizedBox(height: 23),
                _row('Nama Lengkap', GreyInput(controller: _name, label: 'Nama Lengkap')),
                const SizedBox(height: 10),
                _row('Tanggal Lahir', GreyInput(controller: _birthDate, label: 'Tanggal Lahir', isDate: true)),
                const SizedBox(height: 10),
                _row(
                  'No telp',
                  GreyInput(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    digitsOnly: true,
                    maxLength: 13,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _next(),
                  ),
                ),
                const SizedBox(height: 27),
                Padding(
                  padding: const EdgeInsets.only(left: 170),
                  child: FlatButtonBox(label: 'Lanjut', onPressed: _next),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, Widget field) {
    return Row(
      children: [
        SizedBox(width: 115, child: Text(label, style: const TextStyle(fontSize: 15))),
        Expanded(child: field),
      ],
    );
  }
}
