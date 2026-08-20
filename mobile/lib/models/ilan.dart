class Ilan {
  final int id;
  final String baslik;
  final String aciklama;
  final String meslek;
  final String konum;
  final DateTime sonBasvuruTarihi;

  Ilan({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.meslek,
    required this.konum,
    required this.sonBasvuruTarihi,
  });

  factory Ilan.fromJson(Map<String, dynamic> json) {
    return Ilan(
      id: json['id'],
      baslik: json['baslik'],
      aciklama: json['aciklama'],
      meslek: json['meslek'],
      konum: json['konum'],
      sonBasvuruTarihi: DateTime.parse(json['sonBasvuruTarihi']),
    );
  }
}