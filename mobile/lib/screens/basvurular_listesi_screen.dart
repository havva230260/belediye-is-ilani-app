import 'package:flutter/material.dart';
import '../models/ilan.dart';
import '../models/basvuru_isveren.dart';
import '../services/basvuru_service.dart';
import 'basvuru_detay_screen.dart';

class BasvurularListesiScreen extends StatefulWidget {
  final Ilan ilan;
  const BasvurularListesiScreen({super.key, required this.ilan});

  @override
  State<BasvurularListesiScreen> createState() => _BasvurularListesiScreenState();
}

class _BasvurularListesiScreenState extends State<BasvurularListesiScreen> {
  final _basvuruService = BasvuruService();
  late Future<List<BasvuruIsveren>> _basvurularFuture;

  @override
  void initState() {
    super.initState();
    _basvurularFuture = _basvuruService.basvurulariGetir(widget.ilan.id);
  }

  void _listeyiYenile() {
    setState(() {
      _basvurularFuture = _basvuruService.basvurulariGetir(widget.ilan.id);
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
      appBar: AppBar(title: Text('${widget.ilan.baslik} - Başvurular')),
      body: FutureBuilder<List<BasvuruIsveren>>(
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
            return const Center(child: Text('Bu ilana henüz başvuru yapılmamış.'));
          }
          return RefreshIndicator(
            onRefresh: () async => _listeyiYenile(),
            child: ListView.builder(
              itemCount: basvurular.length,
              itemBuilder: (context, index) {
                final basvuru = basvurular[index];
                return ListTile(
                  title: Text(basvuru.basvuranAdSoyad),
                  subtitle: Text('${basvuru.meslekUzmanlik} • ${basvuru.tecrubeYili} yıl tecrübe'),
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
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BasvuruDetayScreen(basvuru: basvuru)),
                    );
                    _listeyiYenile();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}