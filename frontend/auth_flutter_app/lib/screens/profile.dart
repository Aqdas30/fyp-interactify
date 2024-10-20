import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  XFile? _postImage;
  bool showUserPosts = true; // Toggle between user posts and tagged posts

  Future<void> _pickImage(
      {required ImageSource source, required bool isProfile}) async {
    final XFile? image = await _picker.pickImage(source: source);
    setState(() {
      if (isProfile) {
        _profileImage = image;
      } else {
        _postImage = image;
      }
    });
  }

  void _showImagePickerOptions(bool isProfile) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildImagePickerOption('Choose from Gallery',
                  Icons.photo_library, ImageSource.gallery, isProfile),
              _buildImagePickerOption('Take a Photo', Icons.camera_alt,
                  ImageSource.camera, isProfile),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildImagePickerOption(
      String title, IconData icon, ImageSource source, bool isProfile) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        _pickImage(source: source, isProfile: isProfile);
        Navigator.of(context).pop(); // Close the modal
      },
    );
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
            _buildNewPostSection(),
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
                const Text('User Name',
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
                const Text('Hello, I am Username.',
                    style: TextStyle(fontSize: 14)),
                const Text('Welcome to my profile!',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text('Edit Bio'),
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
                  onTap: () => _showImagePickerOptions(true),
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

  // New post section
  Widget _buildNewPostSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Color(0xFFada7af), borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'What do you want to tell everyone?',
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[500],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text('Post'),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: GestureDetector(
              onTap: () => _showImagePickerOptions(false),
              child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[400],
                  child: const Icon(Icons.camera_alt,
                      size: 24, color: Colors.black)),
            ),
          ),
        ],
      ),
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
    List<Map<String, dynamic>> posts = [
      {
        "image": "assets/sample_image1.png", // Replace with local image asset
        "text": "This is a caption with an image"
      },
      {
        "image": "assets/sample_image2.png", // Replace with local image asset
        "text": "" // Just an image post
      },
      {
        "image": "",
        "text": "This is just a text post" // Just text, no image
      },
      {
        "image": "assets/sample_image3.png", // Replace with local image asset
        "text": "Another caption with an image"
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        var post = posts[index];
        return Card(
          child: Column(
            children: [
              if (post['image'].isNotEmpty)
                Image.asset(
                  post['image'],
                  height: 100,
                  fit: BoxFit.cover,
                ),
              if (post['text'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(post['text']),
                ),
            ],
          ),
        );
      },
    );
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
