
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';  // Add video player package

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<dynamic> followedUserPosts = [];
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    fetchFollowedUserPosts();  // Fetch posts from followed users
  }

  Future<void> fetchFollowedUserPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: No token found. Please log in.')),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/feed/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',  // Add the token in the request header
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        followedUserPosts = responseData['posts'];
      });
      print("Posts Data: $followedUserPosts"); // Debugging all the post data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Failed to fetch posts.')),
      );
    }
  }

  Future<void> likePost(int postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('http://127.0.0.1:8000/post/like/$postId/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );

      // Update the likes count in the UI
      setState(() {
        followedUserPosts.firstWhere((post) => post['id'] == postId)['like_count'] = responseData['likes_count'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Failed to like/unlike post.')),
      );
    }
  }

  Future<void> commentOnPost(int postId, String comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Token not found. Please log in.')),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/post/comment/$postId/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'comment': comment}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );

      // Update the comment count in the UI
      setState(() {
        followedUserPosts.firstWhere((post) => post['id'] == postId)['comment_count'] = responseData['comments_count'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Failed to post comment.')),
      );
    }
  }

  // Function to check the type of post and return appropriate widget (image, video, text)
  Widget buildPostContent(dynamic post) {
    // Extract data from post and check for nulls
    String? postType = post['post_type'];
    String? description = post['description'];
    String? mediaUrl = post['media_url'];

    // Debugging output for the post
    print("Post Type: $postType, Media URL: $mediaUrl, Description: $description");

    // Handle different types of posts (image, video, text)
    switch (postType) {
      case 'image':
        return mediaUrl != null
            ? Image.network(
                mediaUrl,
                fit: BoxFit.cover,
              )
            : Text("Image not available");

      case 'video':
        if (mediaUrl != null) {
          _videoController = VideoPlayerController.network(mediaUrl)
            ..initialize().then((_) {
              setState(() {});  // Ensure the first frame is shown after the video is initialized
            });
          return _videoController != null && _videoController!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                )
              : Center(child: CircularProgressIndicator());  // Loading indicator for video
        } else {
          return Text("Video not available");
        }

      case 'text':
      default:
        return description != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(description),
              )
            : Text("No description available");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: followedUserPosts.isNotEmpty
          ? ListView.builder(
              itemCount: followedUserPosts.length,
              itemBuilder: (context, index) {
                final post = followedUserPosts[index];
                TextEditingController commentController = TextEditingController();

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(post['title'] ?? "No Title"),  // Fallback for null title
                        subtitle: buildPostContent(post),  // Display post content (text, image, or video)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Likes: ${post['like_count']}'),
                            Text('Comments: ${post['comment_count']}'),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: () {
                              likePost(post['id']);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Comment on Post'),
                                    content: TextField(
                                      controller: commentController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your comment',
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          commentOnPost(post['id'], commentController.text);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Post'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),  // Show loading indicator while fetching posts
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();  // Dispose of the video controller when not needed
    super.dispose();
  }
}
