
// // import 'dart:convert';
// // import 'package:app/edit_profile.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:video_player/video_player.dart';  // Add video player package

// // class ProfilePage extends StatefulWidget {
// //   final int userId; // The ID of the profile to display
// //   const ProfilePage({Key? key, required this.userId}) : super(key: key);

// //   @override
// //   _ProfilePageState createState() => _ProfilePageState();
// // }

// // class _ProfilePageState extends State<ProfilePage> {
// //   Map<String, dynamic>? userData;
// //   List<dynamic> userPosts = []; // Add a list to store user posts
// //   bool isFollowing = false;
// //   int? loggedInUserId;
// //   VideoPlayerController? _videoController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     getLoggedInUserId();
// //     getUserData();
// //     getUserPosts(); // Fetch user posts
// //     checkIfFollowing();
// //   }

// //   Future<void> getLoggedInUserId() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       loggedInUserId = prefs.getInt('user_id');
// //     });
// //   }

// //   Future<void> getUserData() async {
// //     final url = Uri.parse('http://127.0.0.1:8000/user/${widget.userId}/');
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString('token');

// //     final response = await http.get(
// //       url,
// //       headers: {
// //         'Authorization': 'Token $token',
// //         'Content-Type': 'application/json',
// //       },
// //     );

// //     if (response.statusCode == 200) {
// //       setState(() {
// //         userData = jsonDecode(response.body);
// //       });
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to load profile')),
// //       );
// //     }
// //   }

// //   Future<void> getUserPosts() async {
// //     final url = Uri.parse('http://127.0.0.1:8000/posts/?user_id=${widget.userId}'); // Pass the viewed user's ID
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString('token');

// //     final response = await http.get(
// //       url,
// //       headers: {
// //         'Authorization': 'Token $token',
// //         'Content-Type': 'application/json',
// //       },
// //     );

// //     if (response.statusCode == 200) {
// //       setState(() {
// //         userPosts = jsonDecode(response.body)['posts']; // Store the posts in userPosts
// //       });
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to load posts')),
// //       );
// //     }
// //   }

// //   Future<void> checkIfFollowing() async {
// //     final url = Uri.parse('http://127.0.0.1:8000/user/follow/${widget.userId}/');
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString('token');

// //     final response = await http.get(
// //       url,
// //       headers: {
// //         'Authorization': 'Token $token',
// //         'Content-Type': 'application/json',
// //       },
// //     );

// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       setState(() {
// //         isFollowing = data['following']
// //             .any((follow) => follow['follows'] == widget.userId);
// //       });
// //     }
// //   }

// //   Future<void> toggleFollow() async {
// //     final url = Uri.parse('http://127.0.0.1:8000/user/follow/${widget.userId}/');
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString('token');

// //     final response = await http.post(
// //       url,
// //       headers: {
// //         'Authorization': 'Token $token',
// //         'Content-Type': 'application/json',
// //       },
// //     );

// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(data['message'])),
// //       );
// //       setState(() {
// //         isFollowing = !isFollowing; // Toggle follow status
// //       });
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error: Failed to follow/unfollow')),
// //       );
// //     }
// //   }

// //   // Function to check the type of post and return appropriate widget (image, video, text)
// //   Widget buildPostContent(dynamic post) {
// //     // Extract data from post and check for nulls
// //     String? postType = post['post_type'];
// //     String? description = post['description'];
// //     String? mediaUrl = post['media_url'];

// //     // Debugging output for the post
// //     print("Post Type: $postType, Media URL: $mediaUrl, Description: $description");

// //     // Handle different types of posts (image, video, text)
// //     switch (postType) {
// //       case 'image':
// //         return mediaUrl != null
// //             ? Image.network(
// //                 mediaUrl,
// //                 fit: BoxFit.cover,
// //               )
// //             : Text("Image not available");

// //       case 'video':
// //         if (mediaUrl != null) {
// //           _videoController = VideoPlayerController.network(mediaUrl)
// //             ..initialize().then((_) {
// //               setState(() {});  // Ensure the first frame is shown after the video is initialized
// //             });
// //           return _videoController != null && _videoController!.value.isInitialized
// //               ? AspectRatio(
// //                   aspectRatio: _videoController!.value.aspectRatio,
// //                   child: VideoPlayer(_videoController!),
// //                 )
// //               : Center(child: CircularProgressIndicator());  // Loading indicator for video
// //         } else {
// //           return Text("Video not available");
// //         }

// //       case 'text':
// //       default:
// //         return description != null
// //             ? Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                 child: Text(description),
// //               )
// //             : Text("No description available");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(userData != null ? userData!['username'] : 'Profile'),
// //         actions: [
// //           if (loggedInUserId == widget.userId) // Show Edit Profile button for the logged-in user
// //             IconButton(
// //               icon: Icon(Icons.edit),
// //               onPressed: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => EditProfilePage(userData: userData!),
// //                   ),
// //                 );
// //               },
// //             ),
// //         ],
// //       ),
// //       body: userData != null
// //           ? Column(
// //               children: [
// //                 ListTile(
// //                   title: Text('Email: ${userData!['email']}'),
// //                   subtitle: Text('Bio: ${userData!['bio']}'),
// //                 ),
// //                 if (loggedInUserId != widget.userId) // Only show Follow button for other users
// //                   ElevatedButton(
// //                     onPressed: toggleFollow,
// //                     child: Text(isFollowing ? 'Unfollow' : 'Follow'),
// //                   ),
// //                 Divider(),
// //                 Text('Posts:'),
// //                 userPosts.isNotEmpty
// //                     ? Expanded(
// //                         child: ListView.builder(
// //                           itemCount: userPosts.length,
// //                           itemBuilder: (context, index) {
// //                             final post = userPosts[index];

// //                             return Card(
// //                               margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   ListTile(
// //                                     title: Text(post['title'] ?? "No Title"),  // Fallback for null title
// //                                     subtitle: buildPostContent(post),  // Display post content (text, image, or video)
// //                                   ),
// //                                   Padding(
// //                                     padding: EdgeInsets.symmetric(horizontal: 16.0),
// //                                     child: Column(
// //                                       crossAxisAlignment: CrossAxisAlignment.start,
// //                                       children: [
// //                                         Text('Likes: ${post['like_count']}'),
// //                                         Text('Comments: ${post['comment_count']}'),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       )
// //                     : Text('No posts yet.'),
// //               ],
// //             )
// //           : Center(child: CircularProgressIndicator()), // Show loader while fetching data
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _videoController?.dispose();  // Dispose of the video controller when not needed
// //     super.dispose();
// //   }
// // }

// import 'dart:convert';
// import 'package:app/edit_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';  // Add video player package

// class ProfilePage extends StatefulWidget {
//   final int userId; // The ID of the profile to display
//   const ProfilePage({Key? key, required this.userId}) : super(key: key);

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   Map<String, dynamic>? userData;
//   List<dynamic> userPosts = []; // Add a list to store user posts
//   bool isFollowing = false;
//   int? loggedInUserId;
//   VideoPlayerController? _videoController;

//   @override
//   void initState() {
//     super.initState();
//     getLoggedInUserId();
//     getUserData();
//     getUserPosts(); // Fetch user posts
//     checkIfFollowing();
//   }

//   Future<void> getLoggedInUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       loggedInUserId = prefs.getInt('user_id');
//     });
//   }

//   Future<void> getUserData() async {
//     final url = Uri.parse('http://127.0.0.1:8000/user/${widget.userId}/');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Token $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         userData = jsonDecode(response.body);
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load profile')),
//       );
//     }
//   }

//   Future<void> getUserPosts() async {
//     final url = Uri.parse('http://127.0.0.1:8000/posts/?user_id=${widget.userId}'); // Pass the viewed user's ID
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Token $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         userPosts = jsonDecode(response.body)['posts']; // Store the posts in userPosts
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load posts')),
//       );
//     }
//   }

//   Future<void> checkIfFollowing() async {
//     final url = Uri.parse('http://127.0.0.1:8000/user/follow/${widget.userId}/');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Token $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         isFollowing = data['following']
//             .any((follow) => follow['follows'] == widget.userId);
//       });
//     }
//   }

//   Future<void> toggleFollow() async {
//     final url = Uri.parse('http://127.0.0.1:8000/user/follow/${widget.userId}/');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     final response = await http.post(
//       url,
//       headers: {
//         'Authorization': 'Token $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(data['message'])),
//       );
//       setState(() {
//         isFollowing = !isFollowing; // Toggle follow status
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: Failed to follow/unfollow')),
//       );
//     }
//   }

//   // Function to check the type of post and return appropriate widget (image, video, text)
//   Widget buildPostContent(dynamic post) {
//     // Extract data from post and check for nulls
//     String? postType = post['post_type'];
//     String? description = post['description'];
//     String? mediaUrl = post['media_url'];

//     // Debugging output for the post
//     print("Post Type: $postType, Media URL: $mediaUrl, Description: $description");

//     // Handle different types of posts (image, video, text)
//     switch (postType) {
//       case 'image':
//         return mediaUrl != null
//             ? Image.network(
//                 mediaUrl,
//                 fit: BoxFit.cover,
//               )
//             : Text("Image not available");

//       case 'video':
//         if (mediaUrl != null) {
//           _videoController = VideoPlayerController.network(mediaUrl)
//             ..initialize().then((_) {
//               setState(() {});  // Ensure the first frame is shown after the video is initialized
//             });
//           return _videoController != null && _videoController!.value.isInitialized
//               ? AspectRatio(
//                   aspectRatio: _videoController!.value.aspectRatio,
//                   child: VideoPlayer(_videoController!),
//                 )
//               : Center(child: CircularProgressIndicator());  // Loading indicator for video
//         } else {
//           return Text("Video not available");
//         }

//       case 'text':
//       default:
//         return description != null
//             ? Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Text(description),
//               )
//             : Text("No description available");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(userData != null ? userData!['username'] : 'Profile'),
//         actions: [
//           if (loggedInUserId == widget.userId) // Show Edit Profile button for the logged-in user
//             IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EditProfilePage(userData: userData!),
//                   ),
//                 );
//               },
//             ),
//         ],
//       ),
//       body: userData != null
//           ? Column(
//               children: [
//                 ListTile(
//                   title: Text('Email: ${userData!['email']}'),
//                   subtitle: Text('Bio: ${userData!['bio']}'),
//                 ),
//                 if (loggedInUserId != widget.userId) // Only show Follow button for other users
//                   ElevatedButton(
//                     onPressed: toggleFollow,
//                     child: Text(isFollowing ? 'Unfollow' : 'Follow'),
//                   ),
//                 Divider(),
//                 Text('Posts:'),
//                 userPosts.isNotEmpty
//                     ? Expanded(
//                         child: ListView.builder(
//                           itemCount: userPosts.length,
//                           itemBuilder: (context, index) {
//                             final post = userPosts[index];
//                             return Card(
//                               margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ListTile(
//                                     title: Text(post['title'] ?? "No Title"),  // Fallback for null title
//                                     subtitle: buildPostContent(post),  // Display post content (text, image, or video)
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(horizontal: 16.0),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text('Likes: ${post['like_count']}'),
//                                         Text('Comments: ${post['comment_count']}'),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       )
//                     : Text('No posts yet.'),
//               ],
//             )
//           : Center(child: CircularProgressIndicator()), // Show loader while fetching data
//     );
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();  // Dispose of the video controller when not needed
//     super.dispose();
//   }
// }




import 'dart:convert';
import 'dart:io';
import 'package:app/edit_profile.dart';  // Make sure this is your actual edit profile page
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';  // Add video player package
import 'drawer.dart';

class ProfilePage extends StatefulWidget {
  final int userId; // The ID of the profile to display
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  List<dynamic> userPosts = []; // Add a list to store user posts
  bool isFollowing = false;
  int? loggedInUserId;
  VideoPlayerController? _videoController;

  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  bool showUserPosts = true; // Toggle between user posts and tagged posts

  @override
  void initState() {
    super.initState();
    getLoggedInUserId();
    getUserData();
    getUserPosts(); // Fetch user posts
    checkIfFollowing();
  }

  Future<void> getLoggedInUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUserId = prefs.getInt('user_id');
    });
  }

  Future<void> getUserData() async {
    final url = Uri.parse('http://127.0.0.1:8000/user/${widget.userId}/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile')),
      );
    }
  }

  Future<void> getUserPosts() async {
    final url = Uri.parse('http://127.0.0.1:8000/posts/?user_id=${widget.userId}'); // Pass the viewed user's ID
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userPosts = jsonDecode(response.body)['posts']; // Store the posts in userPosts
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load posts')),
      );
    }
  }

  Future<void> checkIfFollowing() async {
    final url = Uri.parse('http://127.0.0.1:8000/user/follow/${widget.userId}/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        isFollowing = data['following']
            .any((follow) => follow['follows'] == widget.userId);
      });
    }
  }

  Future<void> toggleFollow() async {
    final url = Uri.parse('http://127.0.0.1:8000/user/follow/${widget.userId}/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
      setState(() {
        isFollowing = !isFollowing; // Toggle follow status
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Failed to follow/unfollow')),
      );
    }
  }

  Future<void> _pickImage({required bool isProfile}) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (isProfile) {
        _profileImage = image;
      }
    });
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
      drawer: SettingsDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopBar(),
            const SizedBox(height: 20),
            _buildProfileSection(),
            const SizedBox(height: 20),
            _buildStatsSection(),
            const SizedBox(height: 20),
            _buildToggleIcons(),
            _buildPostsGrid(),
          ],
        ),
      ),
    );
  }

  // Top Bar with settings and username
  Widget _buildTopBar() {
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: CustomPaint(
                size: const Size(150, 100), painter: AbstractShapePainter()),
          ),
          Positioned(
            top: 35,
            left: 20,
            child: GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.7),
                radius: 18,
                child:
                    const Icon(Icons.settings, size: 22, color: Colors.black),
              ),
            ),
          ),
          Positioned(
            top: 35,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(userData != null ? userData!['username'] : 'User Name',
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Container(height: 1, width: 140, color: Colors.grey[400]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profile image and bio section
  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userData != null
                    ? 'Hello, I am ${userData!['username']}.'
                    : 'Hello, I am Username.'),
                Text(userData != null
                    ? 'Bio: ${userData!['bio']}'
                    : 'Welcome to my profile!'),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Edit Profile Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfilePage(userData: userData!),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(File(_profileImage!.path))
                    : const AssetImage('assets/profile_placeholder.png')
                        as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _pickImage(isProfile: true),
                  child: const Icon(Icons.camera_alt,
                      size: 20, color: Color(0xFFada7af)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Stats (Posts, Followers, Following)
  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('1000', 'Posts'),
        _buildStatItem('5007', 'Followers'),
        _buildStatItem('9020', 'Following'),
      ],
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }

  // Toggle icons (User posts, Tagged posts)
  Widget _buildToggleIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToggleIcon(Icons.grid_on, showUserPosts, true),
        const SizedBox(width: 30),
        _buildToggleIcon(Icons.person_pin, !showUserPosts, false),
      ],
    );
  }

  Widget _buildToggleIcon(IconData icon, bool isSelected, bool toggleValue) {
    return GestureDetector(
      onTap: () => setState(() => showUserPosts = toggleValue),
      child: Column(
        children: [
          Icon(icon, size: 30),
          if (isSelected) const SizedBox(height: 5),
          if (isSelected) Container(height: 2, width: 50, color: Colors.blue),
        ],
      ),
    );
  }

  // Posts grid that supports different post types (image, text, or both)
  Widget _buildPostsGrid() {
    return userPosts.isNotEmpty
        ? GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: userPosts.length,
            itemBuilder: (context, index) {
              final post = userPosts[index];
              return Card(
                child: Column(
                  children: [
                    if (post['media_url'] != null)
                      Image.network(post['media_url'], height: 100),
                    if (post['description'] != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(post['description']),
                      ),
                  ],
                ),
              );
            },
          )
        : const Center(child: Text('No posts yet.'));
  }
}

// Custom painter for the abstract shape at the top left
class AbstractShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.9, 0);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.8, 0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
