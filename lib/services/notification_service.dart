import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_data.dart';

class NotificationService {
  static const String _key = "notifications";

  // ➕ tambah notifikasi
  static Future<void> addNotification(NotificationData data) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> oldData = prefs.getStringList(_key) ?? [];

    oldData.insert(0, jsonEncode(data.toJson()));

    await prefs.setStringList(_key, oldData);
  }

  // 📥 ambil semua notifikasi
  static Future<List<NotificationData>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList(_key) ?? [];

    return data
        .map((e) => NotificationData.fromJson(jsonDecode(e)))
        .toList();
  }
}
