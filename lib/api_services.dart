import 'dart:convert';

import 'package:demo_infinity_list/person.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  // Start : ambil dari index berapa (Dimulai dari 0)
  // Limit : Berapa data yang diambil
  Future<List<DataResponse>> getData(int start, int limit) async {
    final url =
        'https://jsonplaceholder.typicode.com/posts?_start=$start&_limit=$limit';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => DataResponse.fromJson(e)).toList();
    } else {
      throw Exception('Failed');
    }
  }
}
