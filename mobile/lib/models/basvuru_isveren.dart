class BasvuruIsveren {
  final int id;
  final int ilanId;
  final int isArayanId;
  final String basvuranAdSoyad;
  final String basvuranEmail;
  final DateTime dogumTarihi;
  final String telefon;
  final String egitimDurumu;
  final String universite;
  final String bolum;
  final String meslekUzmanlik;
  final int tecrubeYili;
  final String cvDosyaYolu;
  final DateTime basvuruTarihi;
  String durum;
  final int? uygunlukPuani;
  final String? yapayZekaOzeti;

  BasvuruIsveren({
    required this.id,
    required this.ilanId,
    required this.isArayanId,
    required this.basvuranAdSoyad,
    required this.basvuranEmail,
    required this.dogumTarihi,
    required this.telefon,
    required this.egitimDurumu,
    required this.universite,
    required this.bolum,
    required this.meslekUzmanlik,
    required this.tecrubeYili,
    required this.cvDosyaYolu,
    required this.basvuruTarihi,
    required this.durum,
    this.uygunlukPuani,
    this.yapayZekaOzeti,
  });

  factory BasvuruIsveren.fromJson(Map<String, dynamic> json) {
    return BasvuruIsveren(
      id: json['id'],
      ilanId: json['ilanId'],
      isArayanId: json['isArayanId'],
      basvuranAdSoyad: json['basvuranAdSoyad'],
      basvuranEmail: json['basvuranEmail'],
      dogumTarihi: DateTime.parse(json['dogumTarihi']),
      telefon: json['telefon'],
      egitimDurumu: json['egitimDurumu'],
      universite: json['universite'],
      bolum: json['bolum'],
      meslekUzmanlik: json['meslekUzmanlik'],
      tecrubeYili: json['tecrubeYili'],
      cvDosyaYolu: json['cvDosyaYolu'],
      basvuruTarihi: DateTime.parse(json['basvuruTarihi']),
      durum: json['durum'],
      uygunlukPuani: json['uygunlukPuani'],
      yapayZekaOzeti: json['yapayZekaOzeti'],
    );
  }
}