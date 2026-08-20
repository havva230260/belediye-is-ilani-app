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
}