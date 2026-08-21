import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ilan.dart';
import '../services/basvuru_service.dart';

class BasvuruFormuScreen extends StatefulWidget {
  final Ilan ilan;
  const BasvuruFormuScreen({super.key, required this.ilan});

  @override
  State<BasvuruFormuScreen> createState() => _BasvuruFormuScreenState();
}

class _BasvuruFormuScreenState extends State<BasvuruFormuScreen> {
  final _formKey = GlobalKey<FormState>();
  final _telefonController = TextEditingController();
  final _universiteController = TextEditingController();
  final _bolumController = TextEditingController();
  final _meslekController = TextEditingController();

  DateTime? _dogumTarihi;
  String? _egitimDurumu;
  int _tecrubeYili = 0;
  File? _cvDosyasi;
  bool _gonderiliyor = false;

  final List<String> _egitimSecenekleri = [
    'İlkokul',
    'Ortaokul',
    'Lise',
    'Ön Lisans',
    'Lisans',
    'Yüksek Lisans',
    'Doktora',
  ];

  Future<void> _dogumTarihiSec() async {
    final secilen = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950, 1, 1),
      lastDate: DateTime.now(),
    );
    if (secilen != null) {
      setState(() {
        _dogumTarihi = secilen;
      });
    }
  }

  Future<void> _cvSec() async {
    final dosya = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (dosya != null && dosya.path != null) {
      setState(() {
        _cvDosyasi = File(dosya.path!);
      });
    }
  }

  Future<void> _basvuruyuGonder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dogumTarihi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen doğum tarihinizi seçin.')),
      );
      return;
    }
    if (_egitimDurumu == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen eğitim durumunuzu seçin.')),
      );
      return;
    }
    if (_cvDosyasi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen PDF formatında CV dosyanızı seçin.')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final isArayanId = prefs.getInt('kullaniciId');
    if (isArayanId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oturum bilgisi bulunamadı, lütfen tekrar giriş yapın.')),
      );
      return;
    }

    setState(() {
      _gonderiliyor = true;
    });

    final hata = await BasvuruService().basvuruGonder(
      ilanId: widget.ilan.id,
      isArayanId: isArayanId,
      dogumTarihi: _dogumTarihi!,
      telefon: _telefonController.text,
      egitimDurumu: _egitimDurumu!,
      universite: _universiteController.text,
      bolum: _bolumController.text,
      meslekUzmanlik: _meslekController.text,
      tecrubeYili: _tecrubeYili,
      cvDosyasi: _cvDosyasi!,
    );

    setState(() {
      _gonderiliyor = false;
    });

    if (!mounted) return;

    if (hata == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Başvuru Alındı'),
          content: const Text('Başvurunuz başarıyla gönderildi.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hata)));
    }
  }

  @override
  void dispose() {
    _telefonController.dispose();
    _universiteController.dispose();
    _bolumController.dispose();
    _meslekController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.ilan.baslik} - Başvuru')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _dogumTarihi == null
                      ? 'Doğum Tarihi Seç'
                      : 'Doğum Tarihi: ${_dogumTarihi!.day.toString().padLeft(2, '0')}.${_dogumTarihi!.month.toString().padLeft(2, '0')}.${_dogumTarihi!.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _dogumTarihiSec,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _telefonController,
                decoration: const InputDecoration(labelText: 'Telefon'),
                keyboardType: TextInputType.phone,
                validator: (deger) => (deger == null || deger.isEmpty) ? 'Telefon zorunludur' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _egitimDurumu,
                decoration: const InputDecoration(labelText: 'Eğitim Durumu'),
                items: _egitimSecenekleri
                    .map((secenek) => DropdownMenuItem(value: secenek, child: Text(secenek)))
                    .toList(),
                onChanged: (deger) {
                  setState(() {
                    _egitimDurumu = deger;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _universiteController,
                decoration: const InputDecoration(labelText: 'Üniversite'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bolumController,
                decoration: const InputDecoration(labelText: 'Bölüm'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _meslekController,
                decoration: const InputDecoration(labelText: 'Meslek / Uzmanlık'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Tecrübe Yılı:'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _tecrubeYili > 0 ? () => setState(() => _tecrubeYili--) : null,
                  ),
                  Text('$_tecrubeYili', style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => _tecrubeYili++),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _cvSec,
                icon: const Icon(Icons.attach_file),
                label: Text(_cvDosyasi == null
                    ? 'CV Seç (PDF)'
                    : 'Seçilen: ${_cvDosyasi!.path.split('/').last}'),
              ),
              const SizedBox(height: 24),
              _gonderiliyor
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _basvuruyuGonder,
                      child: const Text('Başvuruyu Gönder'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}