import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/form_fields.dart';
import 'onboarding_screens.dart';

/// Data dari layar Registration yang dipakai untuk mengisi awal form.
class RegistrationDraft {
  const RegistrationDraft({required this.fullName, required this.birthDate, required this.phone});

  final String fullName;
  final String birthDate;
  final String phone;
}

const _genders = ['Laki-laki', 'Perempuan'];
const _citizenships = ['WNI', 'WNA'];
const _religions = ['Islam', 'Kristen Protestan', 'Katolik', 'Hindu', 'Buddha', 'Konghucu'];
const _maritalStatuses = ['Belum Kawin', 'Kawin', 'Cerai Hidup', 'Cerai Mati'];
const _provinces = [
  'DKI Jakarta',
  'Jawa Barat',
  'Jawa Tengah',
  'DI Yogyakarta',
  'Jawa Timur',
  'Banten',
  'Bali',
  'Sumatera Utara',
  'Sumatera Selatan',
  'Kalimantan Timur',
  'Sulawesi Selatan',
];
const _homeStatuses = ['Milik Sendiri', 'Milik Keluarga', 'Sewa / Kontrak', 'Rumah Dinas'];
const _educations = ['SD', 'SMP', 'SMA / SMK', 'D3', 'S1', 'S2', 'S3'];
const _jobs = [
  'Pegawai Swasta',
  'PNS',
  'TNI / Polri',
  'Wiraswasta',
  'Pelajar / Mahasiswa',
  'Ibu Rumah Tangga',
  'Lainnya',
];
const _incomeRanges = ['< Rp 5 juta', 'Rp 5 - 10 juta', 'Rp 10 - 25 juta', '> Rp 25 juta'];
const _incomeSources = ['Gaji', 'Hasil Usaha', 'Investasi', 'Warisan / Hibah', 'Lainnya'];

/// Frame "Registration KTP Not Found" (1/3), "... 2" (2/3) dan "... 4" (3/3).
class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({super.key, required this.initial, this.initialStep = 0});

  final RegistrationDraft initial;
  final int initialStep;

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final _c = <String, TextEditingController>{};
  final _scroll = ScrollController();
  late int _step = widget.initialStep;
  bool _agreed = false;

  TextEditingController c(String key) => _c.putIfAbsent(key, TextEditingController.new);

  @override
  void initState() {
    super.initState();
    final names = widget.initial.fullName.split(' ');
    c('fullName').text = widget.initial.fullName;
    c('firstName').text = names.first;
    c('lastName').text = names.skip(1).join(' ');
    c('birthDate').text = widget.initial.birthDate;
    c('mobile').text = widget.initial.phone;
    c('citizenship').text = 'WNI';
  }

  @override
  void dispose() {
    for (final controller in _c.values) {
      controller.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  void _next() {
    FocusScope.of(context).unfocus();
    final error = switch (_step) {
      0 when c('fullName').text.trim().isEmpty => 'Nama Lengkap wajib diisi',
      0 when c('motherName').text.trim().isEmpty => 'Nama Ibu Kandung wajib diisi',
      1 when c('mobile').text.isEmpty => 'No Handphone wajib diisi',
      1 when !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(c('email').text.trim()) =>
        'Alamat Email belum valid (dipakai untuk e-KYC)',
      2 when !_agreed => 'Centang persetujuan terlebih dahulu',
      _ => null,
    };
    if (error != null) {
      showMessage(context, error);
      return;
    }
    if (_step < 2) {
      setState(() => _step++);
      _scroll.jumpTo(0);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const EkycOnboardingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step--);
      },
      child: StatusBarStyle(
        light: false,
        child: Scaffold(
          backgroundColor: AppColors.beige,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(child: BprLogo(width: 105, height: 98)),
                        const SizedBox(height: 7),
                        const _SectionChip('MOHON DIISI DENGAN LENGKAP', width: 254),
                        const SizedBox(height: 7),
                        _step == 2
                            ? const _SectionChip('SUMBER DANA', width: 124)
                            : const _SectionChip('DATA PRIBADI & ALAMAT', width: 198),
                        const SizedBox(height: 14),
                        ...switch (_step) {
                          0 => _personalData(),
                          1 => _contactData(),
                          _ => _sourceOfFunds(),
                        },
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 4, 26, 8),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButtonBox(
                          label: _step == 2 ? 'Saya Setuju' : 'Lanjut',
                          onPressed: _next,
                          color: AppColors.chip,
                          width: _step == 2 ? 104 : 78,
                          height: 32,
                          fontSize: 15,
                        ),
                      ),
                      Text('${_step + 1}/3', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _personalData() => [
    Row(
      children: [
        const SizedBox(width: 119, child: Text('Nama Lengkap', style: TextStyle(fontSize: 15))),
        Expanded(child: GreyInput(controller: c('fullName'))),
      ],
    ),
    const SizedBox(height: 21),
    _pair(_field('Nama Depan', 'firstName'), _field('Nama Belakang', 'lastName')),
    _pair(
      _field('Jenis Kelamin', 'gender', options: _genders),
      _field('Kewarganegaraan', 'citizenship', options: _citizenships),
    ),
    _pair(
      _field('Agama', 'religion', options: _religions),
      _field('Status Pernikahan', 'marital', options: _maritalStatuses),
    ),
    _pair(_field('Tempat', 'birthPlace'), _field('Tanggal lahir', 'birthDate', isDate: true)),
    _gap(_field('Alamat', 'address')),
    _gap(_rtRwPos('ktp')),
    _pair(_field('Kelurahan', 'village'), _field('Kecamatan', 'district')),
    _pair(_field('Provinsi', 'province', options: _provinces), const SizedBox()),
    _pair(_field('Nama Ibu Kandung', 'motherName'), const SizedBox()),
  ];

  List<Widget> _contactData() => [
    _pair(_field('No Telp Rumah', 'homePhone', phone: true), _field('No Handphone', 'mobile', phone: true)),
    _gap(_field('Alamat Email', 'email', keyboardType: TextInputType.emailAddress)),
    _gap(_field('Alamat Tinggal Saat ini', 'currentAddress')),
    _gap(_rtRwPos('current')),
    _pair(_field('Kelurahan', 'currentVillage'), _field('Kecamatan', 'currentDistrict')),
    _pair(
      _field('Provinsi', 'currentProvince', options: _provinces),
      _field('Status Rumah', 'homeStatus', options: _homeStatuses),
    ),
    _pair(_field('Pendidikan', 'education', options: _educations), _field('Pekerjaan', 'job', options: _jobs)),
  ];

  List<Widget> _sourceOfFunds() => [
    _pair(
      _field('Jumlah Pendapatan', 'income', options: _incomeRanges),
      _field('Sumber Pendapatan', 'incomeSource', options: _incomeSources),
    ),
    _pair(_field('No NPWP', 'npwp', digits: true, maxLength: 16), const SizedBox()),
    _pair(_field('Tempat Diterbitkan', 'npwpPlace'), _field('Tanggal Diterbitkan', 'npwpDate', isDate: true)),
    const SizedBox(height: 25),
    GestureDetector(
      onTap: () => setState(() => _agreed = !_agreed),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 3),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(5)),
            child: _agreed ? const Text('X', style: TextStyle(fontSize: 15, height: 1)) : null,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Dengan ini saya telah menyetujui isi dari formulir ini dan akan dilanjutkan dengan proses '
              'e-KYC dan penandatangan pembukaan rekaning secara digital.',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: Color(0xFF070707),
              ),
            ),
          ),
        ],
      ),
    ),
  ];

  Widget _field(
    String label,
    String key, {
    List<String>? options,
    bool isDate = false,
    bool phone = false,
    bool digits = false,
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return LabeledInput(
      label: label,
      child: GreyInput(
        controller: c(key),
        label: label,
        options: options,
        isDate: isDate,
        keyboardType: phone || digits ? TextInputType.number : keyboardType,
        digitsOnly: phone || digits,
        maxLength: phone ? 13 : maxLength,
      ),
    );
  }

  /// RT (41) - RW (41) - Kode Pos (73), jarak sesuai Figma.
  Widget _rtRwPos(String prefix) {
    return Row(
      children: [
        SizedBox(
          width: 41,
          child: LabeledInput(
            label: 'RT',
            child: GreyInput(controller: c('${prefix}Rt'), digitsOnly: true, maxLength: 3),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 41,
          child: LabeledInput(
            label: 'RW',
            child: GreyInput(controller: c('${prefix}Rw'), digitsOnly: true, maxLength: 3),
          ),
        ),
        const SizedBox(width: 18),
        SizedBox(
          width: 73,
          child: LabeledInput(
            label: 'Kode Pos',
            child: GreyInput(controller: c('${prefix}PostCode'), digitsOnly: true, maxLength: 5),
          ),
        ),
      ],
    );
  }

  Widget _pair(Widget left, Widget right) => _gap(
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 29),
        Expanded(child: right),
      ],
    ),
  );

  /// Setiap baris label+input berjarak 63px di Figma (25 label + 32 input + 6).
  Widget _gap(Widget child) => Padding(padding: const EdgeInsets.only(bottom: 6), child: child);
}

class _SectionChip extends StatelessWidget {
  const _SectionChip(this.text, {required this.width});

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return LabelBox(text, color: AppColors.chip, width: width, height: 32, padding: const EdgeInsets.only(left: 7));
  }
}
