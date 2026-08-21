import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ilan.dart';

class ApiService {
  // Android emülatörü, bilgisayarın "localhost"una bu özel adresle erişir
  static const String baseUrl = 'http://10.0.2.2:5073/api';

  Future<List<Ilan>> ilanlariGetir() async {
    final response = await http.get(Uri.parse('$baseUrl/Ilanlar'));

    if (response.statusCode == 200) {
      final List<dynamic> veri = jsonDecode(utf8.decode(response.bodyBytes));
      return veri.map((json) => Ilan.fromJson(json)).toList();
    } else {
      throw Exception('İlanlar yüklenemedi (kod: ${response.statusCode})');
    }
  }

  Future<List<Ilan>> ilanlariGetirIsveren(int isverenId) async {
    final response = await http.get(Uri.parse('$baseUrl/Ilanlar/isveren/$isverenId'));

    if (response.statusCode == 200) {
      final List<dynamic> veri = jsonDecode(utf8.decode(response.bodyBytes));
      return veri.map((json) => Ilan.fromJson(json)).toList();
    } else {
      throw Exception('İlanlar yüklenemedi (kod: ${response.statusCode})');
    }
  }

  Future<String?> ilanOlustur({
    required String baslik,
    required String aciklama,
    required String meslek,
    required String konum,
    required DateTime sonBasvuruTarihi,
    required int isverenId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Ilanlar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'baslik': baslik,
        'aciklama': aciklama,
        'meslek': meslek,
        'konum': konum,
        'sonBasvuruTarihi': sonBasvuruTarihi.toIso8601String(),
        'isverenId': isverenId,
      }),
    );

    if (response.statusCode == 201) {
      return null;
    } else {
      return 'İlan oluşturulamadı (kod: ${response.statusCode}) ${utf8.decode(response.bodyBytes)}';
    }
  }

  Future<String?> ilanGuncelle({
    required int id,
    required String baslik,
    required String aciklama,
    required String meslek,
    required String konum,
    required DateTime sonBasvuruTarihi,
    required int isverenId,
    required DateTime olusturmaTarihi,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Ilanlar/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'baslik': baslik,
        'aciklama': aciklama,
        'meslek': meslek,
        'konum': konum,
        'sonBasvuruTarihi': sonBasvuruTarihi.toIso8601String(),
        'isverenId': isverenId,
        'olusturmaTarihi': olusturmaTarihi.toIso8601String(),
      }),
    );

    if (response.statusCode == 204) {
      return null;
    } else {
      return 'İlan güncellenemedi (kod: ${response.statusCode}) ${utf8.decode(response.bodyBytes)}';
    }
  }
}