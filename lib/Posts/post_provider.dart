import 'package:flutter/foundation.dart';
import 'package:flutter_provider/Posts/post_model.dart';
import 'post_service.dart';

class PostProvider with ChangeNotifier {
  final List<Post> _posts = [];
  bool _isLoadingInitial = false;
  bool _isLoadingMore = false;
  bool _hasMorePosts = true;
  int _currentPage = 0;
  final int _limit = 10;

  List<Post> get posts => _posts;
  bool get isLoadingInitial => _isLoadingInitial;
  bool get isLoadingMore => _isLoadingMore;

  final PostService _postService = PostService();

  Future<void> getPosts() async {
    if (_isLoadingInitial || _isLoadingMore || !_hasMorePosts) return;

    if (_posts.isEmpty) {
      _isLoadingInitial = true;
    } else {
      _isLoadingMore = true;
    }
    notifyListeners();

    try {
      List<Post> newPosts =
          await _postService.getPosts(_currentPage * _limit, _limit);
      if (newPosts.isEmpty) {
        _hasMorePosts = false;
      } else {
        _posts.addAll(newPosts);
        _currentPage++;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    _isLoadingInitial = false;
    _isLoadingMore = false;
    notifyListeners();
  }
}
