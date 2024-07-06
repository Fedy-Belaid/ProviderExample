import 'package:flutter/material.dart';
import 'package:flutter_provider/Posts/post_model.dart';
import 'package:flutter_provider/Posts/post_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PostProvider>(context, listen: false).getPosts();
    });
  }

  Widget buildShimmer() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 80.0,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          return postProvider.isLoading
              ? buildShimmer()
              : ListView.builder(
                  itemCount: postProvider.posts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(postProvider.posts[index].title),
                      subtitle: Text(postProvider.posts[index].body),
                    );
                  });
        },
      ),
    );
  }
}
