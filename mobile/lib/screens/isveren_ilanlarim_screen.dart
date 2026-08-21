import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ilan.dart';
import '../services/api_service.dart';
import 'ilan_olustur_screen.dart';
import 'basvurular_listesi_screen.dart';

class IsverenIlanlarimScreen extends StatefulWidget {
  const IsverenIlanlarimScreen({super.key});

  @override
  State<IsverenIlanlarimScreen> createState() => _IsverenIlanlarimScreenState();
}

class _IsverenIlanlarimScreenState extends State<IsverenIlanlarimScreen> {
  final _apiService = ApiService();
  late Future<List<Ilan>> _ilanlarFuture;

  @override
  void initState() {
    super.initState();
    _ilanlarFuture = _ilanlariYukle();
  }

  Future<List<Ilan>> _ilanlariYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final isverenId = prefs.getInt('kullaniciId');
    if (isverenId == null) return [];
    return _apiService.ilanlariGetirIsveren(isverenId);
  }

  void _listeyiYenile() {
    setState(() {
      _ilanlarFuture = _ilanlariYukle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İlanlarım')),
      body: FutureBuilder<List<Ilan>>(
        future: _ilanlarFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          final ilanlar = snapshot.data ?? [];
          if (ilanlar.isEmpty) {
            return const Center(child: Text('Henüz bir ilan oluşturmadınız.'));
          }
          return RefreshIndicator(
            onRefresh: () async => _listeyiYenile(),
            child: ListView.builder(
              itemCount: ilanlar.length,
              itemBuilder: (context, index) {
                final ilan = ilanlar[index];
                return ListTile(
                  title: Text(ilan.baslik),
                  subtitle: Text('${ilan.meslek} • ${ilan.konum}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Düzenle',
                        onPressed: () async {
                          final sonuc = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IlanOlusturScreen(duzenlenecekIlan: ilan),
                            ),
                          );
                          if (sonuc == true) {
                            _listeyiYenile();
                          }
                        },
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BasvurularListesiScreen(ilan: ilan)),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final sonuc = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IlanOlusturScreen()),
          );
          if (sonuc == true) {
            _listeyiYenile();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}