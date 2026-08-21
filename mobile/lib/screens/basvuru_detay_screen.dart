import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/basvuru_isveren.dart';
import '../services/basvuru_service.dart';

class BasvuruDetayScreen extends StatefulWidget {
  final BasvuruIsveren basvuru;
  const BasvuruDetayScreen({super.key, required this.basvuru});

  @override
  State<BasvuruDetayScreen> createState() => _BasvuruDetayScreenState();
}

class _BasvuruDetayScreenState extends State<BasvuruDetayScreen> {
  final _basvuruService = BasvuruService();
  late String _durum;
  bool _guncelleniyor = false;

  @override
  void initState() {
    super.initState();
    _durum = widget.basvuru.durum;
  }

  Future<void> _cvyiAc() async {
    final url = Uri.parse('http://10.0.2.2:5073${widget.basvuru.cvDosyaYolu}');
    final acildi = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!acildi) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CV açılamadı.')),
      );
    }
  }

  Future<void> _durumuGuncelle(String yeniDurum) async {
    setState(() {
      _guncelleniyor = true;
    });
    final hata = await _basvuruService.durumGuncelle(widget.basvuru.id, yeniDurum);
    setState(() {
      _guncelleniyor = false;
    });
    if (!mounted) return;
    if (hata == null) {
      setState(() {
        _durum = yeniDurum;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Başvuru "$yeniDurum" olarak işaretlendi.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hata)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.basvuru;
    return Scaffold(
      appBar: AppBar(title: Text(b.basvuranAdSoyad)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Durum: $_durum', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(height: 32),
            _bilgiSatiri('E-posta', b.basvuranEmail),
            _bilgiSatiri('Telefon', b.telefon),
            _bilgiSatiri('Doğum Tarihi',
                '${b.dogumTarihi.day.toString().padLeft(2, '0')}.${b.dogumTarihi.month.toString().padLeft(2, '0')}.${b.dogumTarihi.year}'),
            _bilgiSatiri('Eğitim Durumu', b.egitimDurumu),
            _bilgiSatiri('Üniversite', b.universite),
            _bilgiSatiri('Bölüm', b.bolum),
            _bilgiSatiri('Meslek / Uzmanlık', b.meslekUzmanlik),
            _bilgiSatiri('Tecrübe Yılı', b.tecrubeYili.toString()),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _cvyiAc,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("CV'yi Görüntüle"),
            ),
            const SizedBox(height: 24),
            if (_guncelleniyor)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () => _durumuGuncelle('Kabul'),
                      child: const Text('Kabul Et'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => _durumuGuncelle('Red'),
                      child: const Text('Reddet'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _bilgiSatiri(String baslik, String deger) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(baslik, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          Text(deger, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}