import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Data pengguna dari API publik (`/users`).
class ApiUser {
  /// Membuat [ApiUser].
  const ApiUser({
    required this.id,
    required this.name,
    required this.email,
    required this.company,
  });

  /// ID pengguna.
  final int id;

  /// Nama pengguna.
  final String name;

  /// Email pengguna.
  final String email;

  /// Nama perusahaan.
  final String company;

  /// Membuat [ApiUser] dari JSON.
  factory ApiUser.fromJson(Map<String, dynamic> json) => ApiUser(
        id: json['id'] as int,
        name: json['name'] as String? ?? '-',
        email: json['email'] as String? ?? '-',
        company: (json['company'] as Map?)?['name'] as String? ?? '-',
      );
}

/// Error yang sudah dibersihkan dan aman ditampilkan ke pengguna.
class ApiException implements Exception {
  /// Membuat [ApiException] dengan [message].
  const ApiException(this.message);

  /// Pesan untuk pengguna.
  final String message;

  @override
  String toString() => message;
}

class ApiService {
  /// Membuat service. [client] dapat diganti untuk pengujian.
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<ApiUser>> fetchUsers() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/users');
    try {
      final headers = <String, String>{'Accept': 'application/json'};
      if (AppConfig.apiKey.isNotEmpty) {
        headers['x-api-key'] = AppConfig.apiKey;
      }
      final response =
          await _client.get(uri, headers: headers).timeout(const Duration(seconds: 10));
          
      debugPrint('[ApiService] GET ${uri.path} -> ${response.statusCode}');

      if (response.statusCode != 200) {
        throw ApiException('Server mengembalikan status ${response.statusCode}.');
      }
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => ApiUser.fromJson(e as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet.');
    } on TimeoutException {
      throw const ApiException('Permintaan melebihi batas waktu (10 detik).');
    } on FormatException {
      throw const ApiException('Format data dari server tidak valid.');
    } on http.ClientException {
      throw const ApiException('Gagal menghubungi server.');
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('[ApiService] error tak terduga (${e.runtimeType})');
      throw const ApiException('Terjadi kesalahan tak terduga.');
    }
  }
}
