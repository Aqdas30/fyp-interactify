
import 'dart:convert';
import 'package:app/createpost.dart';
import 'package:app/profile.dart';
import 'package:app/feed.dart';  // Import the FeedPage
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? userId; // Store logged-in user ID
  final TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = []; // To store the search results

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedUserId = prefs.getInt('user_id'); // Retrieve the stored user ID
    print('Stored User ID: $storedUserId'); // Log the stored ID for debugging
    setState(() {
      userId = storedUserId;
    });
  }

  Future<void> searchUsers(String query) async {
    final url = Uri.parse('http://127.0.0.1:8000/user/search/?q=$query'); // Search API endpoint
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Retrieve the token from local storage

    // Send a GET request to the search endpoint
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        setState(() {
          searchResults = responseData['users']; // Update search results
        });
      } else {
        setState(() {
          searchResults = []; // No results found
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No users found.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Failed to fetch results.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.feed),  // Icon for Feed page
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedPage()), // Navigate to FeedPage
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              if (userId != null) {
                // Navigate to Profile Page with the logged-in user's ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userId: userId!), // Pass logged-in userId
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User ID not found! Please log in.')),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.add),  // Icon for creating a post
            onPressed: () {
              // Navigate to CreatePostPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostPage()), // Navigate to CreatePostPage
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by username',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchUsers(searchController.text); // Trigger search
                  },
                ),
              ),
            ),
            SizedBox(height: 16), // Add some space
            Expanded(
              child: searchResults.isNotEmpty
                  ? ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final user = searchResults[index];
                        return ListTile(
                          title: Text(user['username']),
                          subtitle: Text(user['email']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(userId: user['id']),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text('Search for users to follow.'), // Message when no search results are present
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
