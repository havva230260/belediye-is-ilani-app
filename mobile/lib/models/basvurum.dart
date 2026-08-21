class Basvurum {
  final int id;
  final int ilanId;
  final String ilanBaslik;
  final String ilanMeslek;
  final String ilanKonum;
  final DateTime basvuruTarihi;
  final String durum;

  Basvurum({
    required this.id,
    required this.ilanId,
    required this.ilanBaslik,
    required this.ilanMeslek,
    required this.ilanKonum,
    required this.basvuruTarihi,
    required this.durum,
  });

  factory Basvurum.fromJson(Map<String, dynamic> json) {
    return Basvurum(
      id: json['id'],
      ilanId: json['ilanId'],
      ilanBaslik: json['ilanBaslik'],
      ilanMeslek: json['ilanMeslek'],
      ilanKonum: json['ilanKonum'],
      basvuruTarihi: DateTime.parse(json['basvuruTarihi']),
      durum: json['durum'],
    );
  }
}