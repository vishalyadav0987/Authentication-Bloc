import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/image_model.dart';

class ImageRepository {
  Future<List<ImageModel>> fetchImages({int page = 1, int limit = 10}) async {
    final url = Uri.parse(
      'https://picsum.photos/v2/list?page=$page&limit=$limit',
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => ImageModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
