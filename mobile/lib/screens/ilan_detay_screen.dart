import 'package:flutter/material.dart';
import '../models/ilan.dart';

class IlanDetayScreen extends StatelessWidget {
  final Ilan ilan;

  const IlanDetayScreen({super.key, required this.ilan});

  @override
  Widget build(BuildContext context) {
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
            Text(
              ilan.baslik,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.work_outline, size: 18),
                const SizedBox(width: 4),
                Text(ilan.meslek),
                const SizedBox(width: 16),
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 4),
                Text(ilan.konum),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Son Başvuru Tarihi: $tarih',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Text(
              'İlan Açıklaması',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(ilan.aciklama, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}