import 'package:flutter/foundation.dart';
import 'package:flutter_provider/Posts/post_model.dart';
import 'post_service.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  bool _isFetched = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  final PostService _postService = PostService();

  Future<void> getPosts() async {
    if (_isFetched) return;

    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _postService.fetchPosts();
      _isFetched = true;
    } catch (error) {
      if (kDebugMode) {
        print("Couldn't get posts in provider");
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
