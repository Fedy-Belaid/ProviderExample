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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PostProvider>(context, listen: false).getPosts();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<PostProvider>(context, listen: false).getPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildInitialShimmer() {
    return ListView.builder(
      itemCount: 10, // Show 10 shimmer items for initial load
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 80.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPaginationShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: 80.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoadingInitial && postProvider.posts.isEmpty) {
            return buildInitialShimmer(); //
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: postProvider.posts.length +
                  (postProvider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == postProvider.posts.length) {
                  return buildPaginationShimmer();
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                        "${postProvider.posts[index].id} ${postProvider.posts[index].title}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(postProvider.posts[index].url),
                        Text(postProvider.posts[index].thumbnailUrl),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
