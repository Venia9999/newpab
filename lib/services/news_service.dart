import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../config/api_config.dart';

class NewsService {
  static Future<List<Article>> getNews() async {
    final url = Uri.parse(
      "${ApiConfig.newsBaseUrl}/everything"
      "?q=film OR movie OR cinema"
      "&language=en"
      "&sortBy=publishedAt"
      "&apiKey=${ApiConfig.newsApiKey}",
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      final List list = jsonData['articles'];

      // ⛔ fallback aman
      if (list.isEmpty) {
        print("⚠️ NEWS API: DATA KOSONG");
        return [];
      }

      return list.map((e) => Article.fromJson(e)).toList();
    } else {
      throw Exception("Gagal load berita");
    }
  }
}
