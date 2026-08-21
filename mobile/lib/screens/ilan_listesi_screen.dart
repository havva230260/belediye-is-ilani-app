import 'package:flutter/material.dart';
import '../models/ilan.dart';
import '../services/api_service.dart';
import 'ilan_detay_screen.dart';
import 'basvurularim_screen.dart';

class IlanListesiScreen extends StatefulWidget {
  const IlanListesiScreen({super.key});

  @override
  State<IlanListesiScreen> createState() => _IlanListesiScreenState();
}

class _IlanListesiScreenState extends State<IlanListesiScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Ilan>> _ilanlar;

  @override
  void initState() {
    super.initState();
    _ilanlar = _apiService.ilanlariGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İş İlanları'),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_outlined),
            tooltip: 'Başvurularım',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BasvurularimScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Ilan>>(
        future: _ilanlar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          final ilanlar = snapshot.data ?? [];
          if (ilanlar.isEmpty) {
            return const Center(child: Text('Henüz ilan yok.'));
          }
          return ListView.builder(
            itemCount: ilanlar.length,
            itemBuilder: (context, index) {
              final ilan = ilanlar[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(ilan.baslik),
                  subtitle: Text('${ilan.meslek} • ${ilan.konum}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IlanDetayScreen(ilan: ilan),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
