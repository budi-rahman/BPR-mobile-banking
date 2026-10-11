/// Data dummy untuk mockup. Semua nilai di sini tidak terhubung ke backend.
class DummyData {
  static const customerName = 'Ilham Joenoes';

  /// Nasabah yang KTP-nya dianggap sudah terdaftar (layar "Registration KTP Found").
  static const registeredPhones = ['081234567890', '08123456789'];

  static const accounts = [
    SavingsAccount(number: '12345678', type: 'Tabungan Varia', balance: 23083023, vaNumber: '18127812345678'),
    SavingsAccount(number: '12345679', type: 'Tabungan Usaha', balance: 5750000, vaNumber: '18127812345679'),
  ];

  static const banks = ['BANK BCA', 'BANK MANDIRI', 'BANK BNI', 'BANK BRI', 'BANK PERMATA', 'BANK CIMB NIAGA'];

  /// Nama penerima berdasarkan nomor rekening. Nomor lain memakai [fallbackRecipients].
  static const recipients = {'1234567890': 'JONNY TAK ABET', '87654321': 'SITI RAHMAWATI', '12340000': 'BUDI SANTOSO'};
  static const fallbackRecipients = ['JONNY TAK ABET', 'ANDI PRATAMA', 'DEWI LESTARI', 'RUDI HARTONO', 'MEGA PUTRI'];

  static const transferMethods = [
    TransferMethod(
      name: 'BI FAST',
      description: 'Pengiriman uang melalui jaringan Bank Indonesia',
      fee: 2500,
      maxAmount: 250000000,
    ),
    TransferMethod(
      name: 'Online',
      description: 'Pengiriman uang maksimal 25 Juta dalam satu kali pengiriman',
      fee: 6500,
      maxAmount: 25000000,
    ),
    TransferMethod(
      name: 'SKN',
      description: 'Pengiriman uang maksimal 500 Juta, di proses sesuai jam kerja BI',
      fee: 2900,
      maxAmount: 500000000,
    ),
    TransferMethod(name: 'RTGS', description: 'Pengiriman uang lebih dari 100 Juta', fee: 30000, minAmount: 100000001),
  ];

  static const promos = [
    Promo(
      code: '001/MKT/BV-08/2023',
      image: 'assets/images/promo_gratis_kopi.png',
      thumbWidth: 82,
      paragraphs: [
        'Buka rekening tabungan baru di BPR Varia dan nikmati kopi gratis dari mitra kami selama periode promo.',
      ],
      closing: 'SEMUDAH ITU SEGAMPANG ITU!',
      thumbLogoSize: 20,
      thumbLogoOffset: (4, 56),
    ),
    Promo(
      code: '002/MKT/BV-08/2023',
      image: 'assets/images/promo_deposito.jpg',
      thumbWidth: 150,
      wide: true,
      paragraphs: [
        'Kamu ingin keuanganmu lebih baik, jangan lewatkan penempatan deposito di tempat kami, '
            'dengan tingkat bunga terbaik dan dijamin LPS.',
      ],
      closingPrefix: 'Tunggu apalagi - ',
      closing: 'AYO BUKA SEKARANG!',
      thumbLogoSize: 30,
      thumbLogoOffset: (5, 52),
    ),
    Promo(
      code: '003/MKT/BV-08/2023',
      image: 'assets/images/promo_pinjaman_hp.jpg',
      thumbWidth: 84,
      paragraphs: [
        'Ngga mau ketinggalan jaman kan? Mudahkan kamu untuk mendapatkan handphone idaman.',
        'Tunggu sebentar lagi ya! kami akan sapa kamu untuk segera bisa kamu pesan.',
      ],
      closing: 'SEMUDAH ITU SEGAMPANG ITU!',
    ),
    Promo(
      code: '004/MKT/BV-08/2023',
      image: 'assets/images/promo_seminar.jpg',
      thumbWidth: 76,
      imageAspect: 300 / 321.878,
      paragraphs: [
        'Ilmu itu mahal, yuk barengan ikut berbagi ilmu bisnis biar usaha-mu lancar.',
        'Jangan sampai ketinggala ya!',
      ],
      closing: 'SEMUDAH ITU SEGAMPANG ITU!',
    ),
  ];

  static const mutations = [
    Mutation(date: '28 Agu 2023', title: 'Setoran Tunai', amount: 5000000),
    Mutation(date: '27 Agu 2023', title: 'Transfer ke BANK BCA - JONNY TAK ABET', amount: -2002500),
    Mutation(date: '25 Agu 2023', title: 'Bunga Tabungan', amount: 85523),
    Mutation(date: '20 Agu 2023', title: 'Pembayaran Listrik PLN', amount: -350000),
    Mutation(date: '15 Agu 2023', title: 'Transfer masuk dari SITI RAHMAWATI', amount: 1500000),
  ];
}

class SavingsAccount {
  const SavingsAccount({required this.number, required this.type, required this.balance, required this.vaNumber});

  final String number;
  final String type;
  final int balance;
  final String vaNumber;

  SavingsAccount copyWith({int? balance}) =>
      SavingsAccount(number: number, type: type, balance: balance ?? this.balance, vaNumber: vaNumber);
}

class TransferMethod {
  const TransferMethod({
    required this.name,
    required this.description,
    required this.fee,
    this.minAmount = 1,
    this.maxAmount,
  });

  final String name;
  final String description;
  final int fee;
  final int minAmount;
  final int? maxAmount;
}

class Promo {
  const Promo({
    required this.code,
    required this.image,
    required this.thumbWidth,
    required this.paragraphs,
    required this.closing,
    this.closingPrefix = '',
    this.wide = false,
    this.imageAspect = 1,
    this.thumbLogoSize,
    this.thumbLogoOffset,
  });

  final String code;
  final String image;
  final double thumbWidth;
  final List<String> paragraphs;
  final String closingPrefix;
  final String closing;

  /// Gambar lebar (Deposito) ditampilkan 370px, lainnya 300px seperti di Figma.
  final bool wide;
  final double imageAspect;

  /// Logo BPR Varia kecil yang ditempel di atas thumbnail beranda.
  final double? thumbLogoSize;
  final (double, double)? thumbLogoOffset;
}

class Mutation {
  const Mutation({required this.date, required this.title, required this.amount});

  final String date;
  final String title;
  final int amount;
}
