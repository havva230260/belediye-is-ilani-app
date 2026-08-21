import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ilan.dart';
import '../services/basvuru_service.dart';
import 'basvuru_formu_screen.dart';

class IlanDetayScreen extends StatefulWidget {
  final Ilan ilan;
  const IlanDetayScreen({super.key, required this.ilan});

  @override
  State<IlanDetayScreen> createState() => _IlanDetayScreenState();
}

class _IlanDetayScreenState extends State<IlanDetayScreen> {
  bool _yukleniyor = true;
  bool _basvurulmus = false;

  @override
  void initState() {
    super.initState();
    _basvuruDurumunuKontrolEt();
  }

  Future<void> _basvuruDurumunuKontrolEt() async {
    final prefs = await SharedPreferences.getInstance();
    final isArayanId = prefs.getInt('kullaniciId');
    if (isArayanId == null) {
      setState(() {
        _yukleniyor = false;
      });
      return;
    }
    final basvurulmus = await BasvuruService().basvuruDurumunuKontrolEt(
      ilanId: widget.ilan.id,
      isArayanId: isArayanId,
    );
    if (!mounted) return;
    setState(() {
      _basvurulmus = basvurulmus;
      _yukleniyor = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ilan = widget.ilan;
    final tarih =
        '${ilan.sonBasvuruTarihi.day.toString().padLeft(2, '0')}.'
        '${ilan.sonBasvuruTarihi.month.toString().padLeft(2, '0')}.'
        '${ilan.sonBasvuruTarihi.year}';
    return Scaffold(
      appBar: AppBar(title: Text(ilan.baslik)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ilan.baslik, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.work_outline, size: 18), const SizedBox(width: 4), Text(ilan.meslek),
              const SizedBox(width: 16),
              const Icon(Icons.location_on_outlined, size: 18), const SizedBox(width: 4), Text(ilan.konum),
            ]),
            const SizedBox(height: 16),
            Text('Son Başvuru Tarihi: $tarih', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            const Text('İlan Açıklaması', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(ilan.aciklama, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 24),
            if (_yukleniyor)
              const Center(child: CircularProgressIndicator())
            else if (_basvurulmus)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Başvuruldu',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            else
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BasvuruFormuScreen(ilan: ilan)),
                  );
                  _basvuruDurumunuKontrolEt();
                },
                child: const Text('Başvur'),
              ),
          ],
        ),
      ),
    );
  }
}