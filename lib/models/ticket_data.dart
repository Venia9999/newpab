class TicketData {
  String namaUser;
  String movieTitle;
  String jam;
  String kursi;
  DateTime tanggal;
  int jumlahTiket;
  int totalHarga;
  String metodePembayaran;
  String virtualAccount;

  TicketData({
    required this.namaUser,
    required this.movieTitle,
    required this.jam,
    required this.kursi,
    required this.tanggal,
    required this.jumlahTiket,
    required this.totalHarga,
    required this.metodePembayaran,
    required this.virtualAccount,
  });
}
