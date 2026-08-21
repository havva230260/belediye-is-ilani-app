import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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