import 'dart:convert';
import 'package:app/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];

  // Function to handle search action
 Future<void> searchUsers(String query) async {
  final url = Uri.parse('http://127.0.0.1:8000/user/search/?q=$query');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');  // Retrieve token from SharedPreferences

  if (token == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: No token found. Please log in.')),
    );
    return;
  }

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Token $token',  // Ensure the token is sent here
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    if (responseData['success']) {
      setState(() {
        searchResults = responseData['users'];
      });
    } else {
      setState(() {
        searchResults = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No users found.')),
      );
    }
  } else if (response.statusCode == 403) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: Forbidden. Invalid token or not authenticated.')),
    );
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
        title: Text('Search Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text field for search input
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by username',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchUsers(searchController.text);  // Trigger search when the button is clicked
                  },
                ),
              ),
            ),
            SizedBox(height: 16), // Some spacing
            // Display search results
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final user = searchResults[index];
                  return ListTile(
                    title: Text(user['username']),
                    subtitle: Text(user['email']),
                    onTap: () {
                      // Navigate to the ProfilePage when a user is tapped
                    if (user['id'] != null) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(userId: user['id']),
    ),
  );
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: User ID is missing.')),
  );
}


                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
