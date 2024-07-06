import 'dart:convert';
import 'package:flutter_provider/Posts/post_model.dart';
import 'package:http/http.dart' as http;

class PostService {
  Future<List<Post>> getPosts(int start, int limit) async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/photos?_start=$start&_limit=$limit'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map<Post>((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
