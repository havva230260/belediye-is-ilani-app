import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/basvurum.dart';
import '../services/basvuru_service.dart';

class BasvurularimScreen extends StatefulWidget {
  const BasvurularimScreen({super.key});

  @override
  State<BasvurularimScreen> createState() => _BasvurularimScreenState();
}

class _BasvurularimScreenState extends State<BasvurularimScreen> {
  final _basvuruService = BasvuruService();
  late Future<List<Basvurum>> _basvurularFuture;

  @override
  void initState() {
    super.initState();
    _basvurularFuture = _basvurulariYukle();
  }

  Future<List<Basvurum>> _basvurulariYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final isArayanId = prefs.getInt('kullaniciId');
    if (isArayanId == null) return [];
    return _basvuruService.basvurularimiGetir(isArayanId);
  }

  void _listeyiYenile() {
    setState(() {
      _basvurularFuture = _basvurulariYukle();
    });
  }

  Color _durumRengi(String durum) {
    switch (durum) {
      case 'Kabul':
        return Colors.green;
      case 'Red':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Başvurularım')),
      body: FutureBuilder<List<Basvurum>>(
        future: _basvurularFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          final basvurular = snapshot.data ?? [];
          if (basvurular.isEmpty) {
            return const Center(child: Text('Henüz bir başvurunuz yok.'));
          }
          return RefreshIndicator(
            onRefresh: () async => _listeyiYenile(),
            child: ListView.builder(
              itemCount: basvurular.length,
              itemBuilder: (context, index) {
                final basvuru = basvurular[index];
                final tarih =
                    '${basvuru.basvuruTarihi.day.toString().padLeft(2, '0')}.'
                    '${basvuru.basvuruTarihi.month.toString().padLeft(2, '0')}.'
                    '${basvuru.basvuruTarihi.year}';
                return ListTile(
                  title: Text(basvuru.ilanBaslik),
                  subtitle: Text('${basvuru.ilanMeslek} • ${basvuru.ilanKonum}\nBaşvuru: $tarih'),
                  isThreeLine: true,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _durumRengi(basvuru.durum).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      basvuru.durum,
                      style: TextStyle(color: _durumRengi(basvuru.durum), fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}