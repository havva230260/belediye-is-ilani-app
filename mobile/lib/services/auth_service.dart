import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:5073/api';

  Future<String?> girisYap(String email, String sifre) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Auth/giris'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'sifre': sifre}),
    );

    if (response.statusCode == 200) {
      final veri = jsonDecode(utf8.decode(response.bodyBytes));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', veri['token']);
      await prefs.setInt('kullaniciId', veri['id']);
      await prefs.setString('adSoyad', veri['adSoyad']);
      await prefs.setString('rol', veri['rol']);
      return null;
    } else {
      return 'E-posta veya şifre hatalı.';
    }
  }

  Future<String?> kayitOl(String adSoyad, String email, String sifre, int rol) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Auth/kayit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'adSoyad': adSoyad,
        'email': email,
        'sifre': sifre,
        'rol': rol,
      }),
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      return 'Kayıt başarısız: ${utf8.decode(response.bodyBytes)}';
    }
  }
}