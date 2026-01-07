import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  // ANDROID EMULATOR
  static const String baseUrl = "http://10.0.2.2/bioskop_api";

  // =======================
  // GET ALL MOVIES
  // =======================
  static Future<List<Movie>> getMovies() async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/movies/get_movies.php"))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}");
      }

      final body = response.body.trim();
      final List data = jsonDecode(body);
      return data.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Gagal mengambil data film");
    }
  }

  // =======================
  // GET MOVIE DETAIL
  // =======================
  static Future<Movie> getMovieDetail(int movieId) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/movies/get_movie_detail.php?id=$movieId"),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}");
      }

      return Movie.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception("Gagal mengambil detail film");
    }
  }

  // =======================
  // LOGIN (FIX FINAL)
  // =======================
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/auth/login.php"),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode({
              "email": email,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return {
          "success": false,
          "message": "Server error (${response.statusCode})",
        };
      }

      final body = response.body.trim();

      if (!body.startsWith("{")) {
        return {
          "success": false,
          "message": "Response server tidak valid",
        };
      }

      return jsonDecode(body);
    } on SocketException {
      return {
        "success": false,
        "message": "Tidak bisa terhubung ke server",
      };
    } on FormatException {
      return {
        "success": false,
        "message": "Format JSON tidak valid",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Terjadi kesalahan",
      };
    }
  }

  // =======================
  // REGISTER
  // =======================
  static Future<Map<String, dynamic>> register(
    String nama,
    String email,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/auth/register.php"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "nama": nama,
              "email": email,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return {
          "success": false,
          "message": "Server error",
        };
      }

      final body = response.body.trim();

      if (!body.startsWith("{")) {
        return {
          "success": false,
          "message": "Response server tidak valid",
        };
      }

      return jsonDecode(body);
    } catch (e) {
      return {
        "success": false,
        "message": "Register gagal",
      };
    }
  }
}
