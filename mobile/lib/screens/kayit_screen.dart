import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class KayitScreen extends StatefulWidget {
  const KayitScreen({super.key});

  @override
  State<KayitScreen> createState() => _KayitScreenState();
}

class _KayitScreenState extends State<KayitScreen> {
  final _adSoyadController = TextEditingController();
  final _emailController = TextEditingController();
  final _sifreController = TextEditingController();
  final _authService = AuthService();

  int _secilenRol = 0; // 0 = İş Arayan, 1 = İşveren
  bool _yukleniyor = false;
  String? _hataMesaji;
  String? _basariMesaji;

  Future<void> _kayitOl() async {
    setState(() {
      _yukleniyor = true;
      _hataMesaji = null;
      _basariMesaji = null;
    });

    final hata = await _authService.kayitOl(
      _adSoyadController.text.trim(),
      _emailController.text.trim(),
      _sifreController.text,
      _secilenRol,
    );

    setState(() {
      _yukleniyor = false;
      if (hata != null) {
        _hataMesaji = hata;
      } else {
        _basariMesaji = 'Kayıt başarılı! Şimdi giriş yapabilirsin.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _adSoyadController,
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-posta'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _sifreController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            const Text('Hesap Türü'),
            RadioListTile<int>(
              title: const Text('İş Arayan'),
              value: 0,
              groupValue: _secilenRol,
              onChanged: (deger) => setState(() => _secilenRol = deger!),
            ),
            RadioListTile<int>(
              title: const Text('İşveren'),
              value: 1,
              groupValue: _secilenRol,
              onChanged: (deger) => setState(() => _secilenRol = deger!),
            ),
            const SizedBox(height: 12),
            if (_hataMesaji != null)
              Text(_hataMesaji!, style: const TextStyle(color: Colors.red)),
            if (_basariMesaji != null)
              Text(_basariMesaji!, style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 12),
            _yukleniyor
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _kayitOl,
                    child: const Text('Kayıt Ol'),
                  ),
          ],
        ),
      ),
    );
  }
}