import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/basvuru_isveren.dart';
import '../models/basvurum.dart';

class BasvuruService {
  static const String baseUrl = 'http://10.0.2.2:5073/api';

  Future<bool> basvuruDurumunuKontrolEt({
    required int ilanId,
    required int isArayanId,
  }) async {
    final uri = Uri.parse('$baseUrl/Basvurular/kontrol?ilanId=$ilanId&isArayanId=$isArayanId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) == true;
    }
    return false;
  }

  Future<List<BasvuruIsveren>> basvurulariGetir(int ilanId) async {
    final uri = Uri.parse('$baseUrl/Basvurular/ilan/$ilanId/detayli');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> veri = jsonDecode(utf8.decode(response.bodyBytes));
      return veri.map((json) => BasvuruIsveren.fromJson(json)).toList();
    } else {
      throw Exception('Başvurular yüklenemedi (kod: ${response.statusCode})');
    }
  }

  Future<List<Basvurum>> basvurularimiGetir(int isArayanId) async {
    final uri = Uri.parse('$baseUrl/Basvurular/basvuran/$isArayanId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> veri = jsonDecode(utf8.decode(response.bodyBytes));
      return veri.map((json) => Basvurum.fromJson(json)).toList();
    } else {
      throw Exception('Başvurularınız yüklenemedi (kod: ${response.statusCode})');
    }
  }

  Future<String?> durumGuncelle(int basvuruId, String yeniDurum) async {
    final uri = Uri.parse('$baseUrl/Basvurular/$basvuruId/durum');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(yeniDurum),
    );
    if (response.statusCode == 204) {
      return null;
    } else {
      return 'Durum güncellenemedi (kod: ${response.statusCode})';
    }
  }

  Future<String?> basvuruGonder({
    required int ilanId,
    required int isArayanId,
    required DateTime dogumTarihi,
    required String telefon,
    required String egitimDurumu,
    required String universite,
    required String bolum,
    required String meslekUzmanlik,
    required int tecrubeYili,
    required File cvDosyasi,
  }) async {
    final uri = Uri.parse('$baseUrl/Basvurular');
    final request = http.MultipartRequest('POST', uri);
    request.fields['IlanId'] = ilanId.toString();
    request.fields['IsArayanId'] = isArayanId.toString();
    request.fields['DogumTarihi'] = dogumTarihi.toIso8601String();
    request.fields['Telefon'] = telefon;
    request.fields['EgitimDurumu'] = egitimDurumu;
    request.fields['Universite'] = universite;
    request.fields['Bolum'] = bolum;
    request.fields['MeslekUzmanlik'] = meslekUzmanlik;
    request.fields['TecrubeYili'] = tecrubeYili.toString();
    request.files.add(await http.MultipartFile.fromPath(
      'CvDosyasi',
      cvDosyasi.path,
      contentType: MediaType('application', 'pdf'),
    ));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 201) {
      return null;
    } else {
      return 'Başvuru gönderilemedi (kod: ${response.statusCode}) ${utf8.decode(response.bodyBytes)}';
    }
  }
}