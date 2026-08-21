import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ilan.dart';
import '../services/api_service.dart';

class IlanOlusturScreen extends StatefulWidget {
  final Ilan? duzenlenecekIlan;
  const IlanOlusturScreen({super.key, this.duzenlenecekIlan});

  @override
  State<IlanOlusturScreen> createState() => _IlanOlusturScreenState();
}

class _IlanOlusturScreenState extends State<IlanOlusturScreen> {
  final _formKey = GlobalKey<FormState>();
  final _baslikController = TextEditingController();
  final _aciklamaController = TextEditingController();
  final _meslekController = TextEditingController();
  final _konumController = TextEditingController();
  final _apiService = ApiService();

  DateTime? _sonBasvuruTarihi;
  bool _gonderiliyor = false;
  String? _hataMesaji;

  bool get _duzenlemeModu => widget.duzenlenecekIlan != null;

  @override
  void initState() {
    super.initState();
    final ilan = widget.duzenlenecekIlan;
    if (ilan != null) {
      _baslikController.text = ilan.baslik;
      _aciklamaController.text = ilan.aciklama;
      _meslekController.text = ilan.meslek;
      _konumController.text = ilan.konum;
      _sonBasvuruTarihi = ilan.sonBasvuruTarihi;
    }
  }

  Future<void> _tarihSec() async {
    final secilen = await showDatePicker(
      context: context,
      initialDate: _sonBasvuruTarihi ?? DateTime.now().add(const Duration(days: 14)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (secilen != null) {
      setState(() {
        _sonBasvuruTarihi = secilen;
      });
    }
  }

  Future<void> _ilaniKaydet() async {
    if (!_formKey.currentState!.validate()) return;
    if (_sonBasvuruTarihi == null) {
      setState(() {
        _hataMesaji = 'Lütfen son başvuru tarihini seçin.';
      });
      return;
    }

    setState(() {
      _gonderiliyor = true;
      _hataMesaji = null;
    });

    String? hata;

    if (_duzenlemeModu) {
      final ilan = widget.duzenlenecekIlan!;
      hata = await _apiService.ilanGuncelle(
        id: ilan.id,
        baslik: _baslikController.text,
        aciklama: _aciklamaController.text,
        meslek: _meslekController.text,
        konum: _konumController.text,
        sonBasvuruTarihi: _sonBasvuruTarihi!,
        isverenId: ilan.isverenId,
        olusturmaTarihi: ilan.olusturmaTarihi,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      final isverenId = prefs.getInt('kullaniciId');
      if (isverenId == null) {
        setState(() {
          _gonderiliyor = false;
          _hataMesaji = 'Oturum bilgisi bulunamadı, lütfen tekrar giriş yapın.';
        });
        return;
      }
      hata = await _apiService.ilanOlustur(
        baslik: _baslikController.text,
        aciklama: _aciklamaController.text,
        meslek: _meslekController.text,
        konum: _konumController.text,
        sonBasvuruTarihi: _sonBasvuruTarihi!,
        isverenId: isverenId,
      );
    }

    setState(() {
      _gonderiliyor = false;
    });

    if (!mounted) return;

    if (hata == null) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _hataMesaji = hata;
      });
    }
  }

  @override
  void dispose() {
    _baslikController.dispose();
    _aciklamaController.dispose();
    _meslekController.dispose();
    _konumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_duzenlemeModu ? 'İlanı Düzenle' : 'Yeni İlan Oluştur')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _baslikController,
                decoration: const InputDecoration(labelText: 'İlan Başlığı'),
                validator: (deger) => (deger == null || deger.isEmpty) ? 'Başlık zorunludur' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _aciklamaController,
                decoration: const InputDecoration(labelText: 'İlan Açıklaması'),
                maxLines: 4,
                validator: (deger) => (deger == null || deger.isEmpty) ? 'Açıklama zorunludur' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _meslekController,
                decoration: const InputDecoration(labelText: 'Meslek'),
                validator: (deger) => (deger == null || deger.isEmpty) ? 'Meslek zorunludur' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _konumController,
                decoration: const InputDecoration(labelText: 'Konum'),
                validator: (deger) => (deger == null || deger.isEmpty) ? 'Konum zorunludur' : null,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _sonBasvuruTarihi == null
                      ? 'Son Başvuru Tarihi Seç'
                      : 'Son Başvuru Tarihi: ${_sonBasvuruTarihi!.day.toString().padLeft(2, '0')}.${_sonBasvuruTarihi!.month.toString().padLeft(2, '0')}.${_sonBasvuruTarihi!.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _tarihSec,
              ),
              const SizedBox(height: 16),
              if (_hataMesaji != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_hataMesaji!, style: const TextStyle(color: Colors.red)),
                ),
              _gonderiliyor
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _ilaniKaydet,
                      child: Text(_duzenlemeModu ? 'Değişiklikleri Kaydet' : 'İlanı Yayınla'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}