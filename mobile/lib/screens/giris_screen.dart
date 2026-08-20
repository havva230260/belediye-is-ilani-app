import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'ilan_listesi_screen.dart';
import 'kayit_screen.dart';

class GirisScreen extends StatefulWidget {
  const GirisScreen({super.key});

  @override
  State<GirisScreen> createState() => _GirisScreenState();
}

class _GirisScreenState extends State<GirisScreen> {
  final _emailController = TextEditingController();
  final _sifreController = TextEditingController();
  final _authService = AuthService();

  bool _yukleniyor = false;
  String? _hataMesaji;

  Future<void> _girisYap() async {
    setState(() {
      _yukleniyor = true;
      _hataMesaji = null;
    });

    final hata = await _authService.girisYap(
      _emailController.text.trim(),
      _sifreController.text,
    );

    setState(() {
      _yukleniyor = false;
    });

    if (hata != null) {
      setState(() {
        _hataMesaji = hata;
      });
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IlanListesiScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            const SizedBox(height: 20),
            if (_hataMesaji != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_hataMesaji!, style: const TextStyle(color: Colors.red)),
              ),
            _yukleniyor
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _girisYap,
                    child: const Text('Giriş Yap'),
                  ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KayitScreen()),
                );
              },
              child: const Text('Hesabın yok mu? Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}