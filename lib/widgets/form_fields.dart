import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import 'common.dart';

/// Kotak input abu-abu (Rectangle #D9D9D9, tinggi 32, radius 5) dari layar login & registrasi.
///
/// Bisa berupa teks biasa, pilihan ([options]) atau tanggal ([isDate]).
class GreyInput extends StatelessWidget {
  const GreyInput({
    super.key,
    required this.controller,
    this.label,
    this.width,
    this.height = 32,
    this.color = AppColors.field,
    this.keyboardType,
    this.options,
    this.isDate = false,
    this.obscure = false,
    this.maxLength,
    this.digitsOnly = false,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  final TextEditingController controller;

  /// Dipakai sebagai judul pemilih opsi/tanggal.
  final String? label;
  final double? width;
  final double height;
  final Color color;
  final TextInputType? keyboardType;
  final List<String>? options;
  final bool isDate;
  final bool obscure;
  final int? maxLength;
  final bool digitsOnly;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  bool get _picker => options != null || isDate;

  Future<void> _pick(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final value = await (isDate
        ? pickDate(context)
        : pickOption(context, label ?? 'Pilih', options!, selected: controller.text));
    if (value != null) controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: TextField(
        controller: controller,
        readOnly: _picker,
        onTap: _picker ? () => _pick(context) : null,
        obscureText: obscure,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        inputFormatters: [
          if (digitsOnly) FilteringTextInputFormatter.digitsOnly,
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ],
        style: const TextStyle(fontSize: 14, color: Colors.black),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          suffixIcon: _picker
              ? Icon(isDate ? Icons.calendar_today_outlined : Icons.arrow_drop_down, size: 18, color: Colors.black45)
              : null,
          suffixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 20),
        ),
      ),
    );
  }
}

/// Label di atas kotak input (Inter 15 hitam), jarak 25px dari atas label ke atas kotak seperti di Figma.
class LabeledInput extends StatelessWidget {
  const LabeledInput({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25,
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15)),
        ),
        child,
      ],
    );
  }
}
