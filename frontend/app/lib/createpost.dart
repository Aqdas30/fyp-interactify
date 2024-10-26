



// import 'dart:io';  // For mobile platforms
// import 'dart:typed_data';  // For web
// import 'package:flutter/foundation.dart';  // For kIsWeb check
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';  // For mobile
// import 'package:file_picker/file_picker.dart';  // For web
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class CreatePostPage extends StatefulWidget {
//   @override
//   _CreatePostPageState createState() => _CreatePostPageState();
// }

// class _CreatePostPageState extends State<CreatePostPage> {
//   File? _selectedMedia;  // For storing picked image/video (mobile)
//   Uint8List? _webMedia;  // For web media (image/video)
//   String? _postType = 'text';  // To track the selected post type
//   TextEditingController _textController = TextEditingController();  // For text-based post
//   final ImagePicker _picker = ImagePicker();

//   // Function to pick media (image/video) based on platform
//   Future<void> _pickMedia() async {
//     if (kIsWeb) {
//       // Web: Use file_picker to pick images or videos
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.media,
//         allowMultiple: false,
//       );

//       if (result != null) {
//         setState(() {
//           _webMedia = result.files.first.bytes;  // Store the media as bytes for web
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No media selected.')),
//         );
//       }
//     } else {
//       // Mobile: Use image_picker to pick images or videos
//       try {
//         XFile? pickedFile;
//         if (_postType == 'image') {
//           pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//         } else if (_postType == 'video') {
//           pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
//         }

//         if (pickedFile != null && pickedFile.path != null) {
//           setState(() {
//             _selectedMedia = File(pickedFile!.path);  // Store the media as File for mobile
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('No media selected.')),
//           );
//         }
//       } catch (e) {
//         print('Error picking media: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to pick media: $e')),
//         );
//       }
//     }
//   }

//   Future<void> _submitPost() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: Token not found. Please log in.')),
//       );
//       return;
//     }

//     var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:8000/post/create/'));
//     request.headers['Authorization'] = 'Token $token';
    
//     if (_postType == 'text') {
//       // Text-based post
//       request.fields['post_type'] = 'text';
//       request.fields['description'] = _textController.text;
//     } else {
//       // Image or Video post
//       request.fields['post_type'] = _postType!;
//       if (kIsWeb) {
//         request.files.add(http.MultipartFile.fromBytes(
//           'media', _webMedia!, filename: 'upload.${_postType == "image" ? "jpg" : "mp4"}',
//         ));
//       } else {
//         // Ensure path is non-null with `!`
//         request.files.add(await http.MultipartFile.fromPath(
//           'media', _selectedMedia!.path,
//         ));
//       }
//     }

//     var response = await request.send();

//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Post created successfully')),
//       );
//       Navigator.pop(context);  // Go back to the previous page
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to create post.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create a Post'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DropdownButton<String>(
//               value: _postType,
//               items: [
//                 DropdownMenuItem(child: Text('Text Post'), value: 'text'),
//                 DropdownMenuItem(child: Text('Image Post'), value: 'image'),
//                 DropdownMenuItem(child: Text('Video Post'), value: 'video'),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   _postType = value;
//                   _selectedMedia = null;  // Clear selected media when changing type
//                   _webMedia = null;
//                 });
//               },
//             ),
//             if (_postType == 'text')
//               TextField(
//                 controller: _textController,
//                 decoration: InputDecoration(labelText: 'Enter text for your post'),
//               ),
//             if (_postType == 'image' || _postType == 'video')
//               ElevatedButton(
//                 onPressed: _pickMedia,
//                 child: Text('Pick ${_postType == 'image' ? 'Image' : 'Video'}'),
//               ),
//             SizedBox(height: 20),
//             if (_postType == 'image' && _selectedMedia != null)
//               Image.file(_selectedMedia!),  // Display selected image (mobile)
//             if (_postType == 'video' && _selectedMedia != null)
//               Text('Video selected: ${_selectedMedia!.path}'),
//             if (kIsWeb && _webMedia != null)
//               _postType == 'image'
//                   ? Image.memory(_webMedia!)  // Display web image
//                   : Text('Video selected for web'),  // Handle web video selection
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _submitPost,
//               child: Text('Submit Post'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:io';  // For mobile platforms
// import 'dart:typed_data';  // For web
// import 'package:flutter/foundation.dart';  // For kIsWeb check
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';  // For mobile
// import 'package:file_picker/file_picker.dart';  // For web
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class CreatePostPage extends StatefulWidget {
//   @override
//   _CreatePostPageState createState() => _CreatePostPageState();
// }

// class _CreatePostPageState extends State<CreatePostPage> {
//   File? _selectedMedia;  // For storing picked image/video (mobile)
//   Uint8List? _webMedia;  // For web media (image/video)
//   String? _postType = 'text';  // To track the selected post type
//   TextEditingController _textController = TextEditingController();  // For text-based post
//   TextEditingController _titleController = TextEditingController();  // For post title
//   TextEditingController _descriptionController = TextEditingController();  // For post description
//   final ImagePicker _picker = ImagePicker();

//   // Function to pick media (image/video) based on platform
//   Future<void> _pickMedia() async {
//     if (kIsWeb) {
//       // Web: Use file_picker to pick images or videos
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.media,
//         allowMultiple: false,
//       );

//       if (result != null) {
//         setState(() {
//           _webMedia = result.files.first.bytes;  // Store the media as bytes for web
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No media selected.')),
//         );
//       }
//     } else {
//       // Mobile: Use image_picker to pick images or videos
//       try {
//         XFile? pickedFile;
//         if (_postType == 'image') {
//           pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//         } else if (_postType == 'video') {
//           pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
//         }

//         if (pickedFile != null) {
//           setState(() {
//             _selectedMedia = File(pickedFile!.path);  // Store the media as File for mobile
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('No media selected.')),
//           );
//         }
//       } catch (e) {
//         print('Error picking media: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to pick media: $e')),
//         );
//       }
//     }
//   }

//   Future<void> _submitPost() async {
//     if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter both title and description.')),
//       );
//       return;
//     }

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');  // Get the token from SharedPreferences

//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: Token not found. Please log in.')),
//       );
//       return;
//     }

//     var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:8000/post/create/'));
//     request.headers['Authorization'] = 'Token $token';  // Add the token to the headers
    
//     // Add title and description
//     request.fields['title'] = _titleController.text;
//     request.fields['description'] = _descriptionController.text;

//     if (_postType == 'text') {
//       // Text-based post
//       request.fields['post_type'] = 'text';
//     } else {
//       // Image or Video post
//       request.fields['post_type'] = _postType!;
//       if (kIsWeb) {
//         if (_webMedia != null) {
//           request.files.add(http.MultipartFile.fromBytes(
//             'media', _webMedia!, filename: 'upload.${_postType == "image" ? "jpg" : "mp4"}',
//           ));
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('No media selected for upload.')),
//           );
//           return;
//         }
//       } else if (_selectedMedia != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'media', _selectedMedia!.path,
//         ));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No media selected for upload.')),
//         );
//         return;
//       }
//     }

//     var response = await request.send();

//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Post created successfully')),
//       );
//       Navigator.pop(context);  // Go back to the previous page
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to create post.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create a Post'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: 'Enter title for your post'),
//             ),
//             DropdownButton<String>(
//               value: _postType,
//               items: [
//                 DropdownMenuItem(child: Text('Text Post'), value: 'text'),
//                 DropdownMenuItem(child: Text('Image Post'), value: 'image'),
//                 DropdownMenuItem(child: Text('Video Post'), value: 'video'),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   _postType = value;
//                   _selectedMedia = null;  // Clear selected media when changing type
//                   _webMedia = null;
//                 });
//               },
//             ),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Enter description for your post'),
//             ),
//             if (_postType == 'image' || _postType == 'video')
//               ElevatedButton(
//                 onPressed: _pickMedia,
//                 child: Text('Pick ${_postType == 'image' ? 'Image' : 'Video'}'),
//               ),
//             SizedBox(height: 20),
//             if (_postType == 'image' && _selectedMedia != null)
//               Image.file(_selectedMedia!),  // Display selected image (mobile)
//             if (_postType == 'video' && _selectedMedia != null)
//               Text('Video selected: ${_selectedMedia!.path}'),
//             if (kIsWeb && _webMedia != null)
//               _postType == 'image'
//                   ? Image.memory(_webMedia!)  // Display web image
//                   : Text('Video selected for web'),  // Handle web video selection
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _submitPost,
//               child: Text('Submit Post'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:io';  // For mobile platforms
import 'dart:typed_data';  // For web
import 'package:flutter/foundation.dart';  // For kIsWeb check
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // For mobile
import 'package:file_picker/file_picker.dart';  // For web
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  File? _selectedMedia;  // For storing picked image/video (mobile)
  Uint8List? _webMedia;  // For web media (image/video)
  String? _postType = 'text';  // To track the selected post type
  TextEditingController _titleController = TextEditingController();  // For post title
  TextEditingController _descriptionController = TextEditingController();  // For post description
  final ImagePicker _picker = ImagePicker();

  // Function to pick media (image/video) based on platform
  Future<void> _pickMedia() async {
    if (kIsWeb) {
      // Web: Use file_picker to pick images or videos
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _webMedia = result.files.first.bytes;  // Store the media as bytes for web
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No media selected.')),
        );
      }
    } else {
      // Mobile: Use image_picker to pick images or videos
      try {
        XFile? pickedFile;
        if (_postType == 'image') {
          pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        } else if (_postType == 'video') {
          pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
        }

        if (pickedFile != null) {
          setState(() {
            _selectedMedia = File(pickedFile!.path);  // Store the media as File for mobile
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No media selected.')),
          );
        }
      } catch (e) {
        print('Error picking media: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick media: $e')),
        );
      }
    }
  }

  // Future<void> _submitPost() async {
  //   if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please enter both title and description.')),
  //     );
  //     return;
  //   }

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');  // Get the token from SharedPreferences

  //   if (token == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: Token not found. Please log in.')),
  //     );
  //     return;
  //   }

  //   var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:8000/post/create/'));
  //   request.headers['Authorization'] = 'Token $token';  // Add the token to the headers
    
  //   // Add title and description
  //   request.fields['title'] = _titleController.text;
  //   request.fields['description'] = _descriptionController.text;

  //   if (_postType == 'text') {
  //     // Text-based post
  //     request.fields['post_type'] = 'text';
  //   } else {
  //     // Image or Video post
  //     request.fields['post_type'] = _postType!;
  //     if (kIsWeb) {
  //       if (_webMedia != null) {
  //         request.files.add(http.MultipartFile.fromBytes(
  //           'media', _webMedia!, filename: 'upload.${_postType == "image" ? "jpg" : "mp4"}',
  //         ));
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('No media selected for upload.')),
  //         );
  //         return;
  //       }
  //     } else if (_selectedMedia != null) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //         'media', _selectedMedia!.path,
  //       ));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('No media selected for upload.')),
  //       );
  //       return;
  //     }
  //   }

  //   var response = await request.send();

  //   if (response.statusCode == 201) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Post created successfully')),
  //     );
  //     Navigator.pop(context);  // Go back to the previous page
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to create post.')),
  //     );
  //   }
  // }
Future<void> _submitPost() async {
  if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter both title and description.')),
    );
    return;
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');  // Get the token from SharedPreferences

  if (token == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: Token not found. Please log in.')),
    );
    return;
  }

  var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:8000/post/create/'));
  request.headers['Authorization'] = 'Token $token';  // Add the token to the headers
  
  // Add title and description
  request.fields['title'] = _titleController.text;
  request.fields['description'] = _descriptionController.text;

  if (_postType == 'text') {
    request.fields['post_type'] = 'text';
  } else {
    request.fields['post_type'] = _postType!;
    if (kIsWeb) {
      if (_webMedia != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'media', _webMedia!, filename: 'upload.${_postType == "image" ? "jpg" : "mp4"}',
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No media selected for upload.')),
        );
        return;
      }
    } else if (_selectedMedia != null) {
      print('Media path: ${_selectedMedia!.path}');  // Debugging: check if media is present
      request.files.add(await http.MultipartFile.fromPath(
        'media', _selectedMedia!.path,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No media selected for upload.')),
      );
      return;
    }
  }

  print(request.fields);  // Debugging: Check if the fields are being added
  print(request.files);   // Debugging: Check if the files are being added to the request

  var response = await request.send();

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post created successfully')),
    );
    Navigator.pop(context);  // Go back to the previous page
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to create post.')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Enter title for your post'),
            ),
            DropdownButton<String>(
              value: _postType,
              items: [
                DropdownMenuItem(child: Text('Text Post'), value: 'text'),
                DropdownMenuItem(child: Text('Image Post'), value: 'image'),
                DropdownMenuItem(child: Text('Video Post'), value: 'video'),
              ],
              onChanged: (value) {
                setState(() {
                  _postType = value;
                  _selectedMedia = null;  // Clear selected media when changing type
                  _webMedia = null;
                });
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Enter description for your post'),
            ),
            if (_postType == 'image' || _postType == 'video')
              ElevatedButton(
                onPressed: _pickMedia,
                child: Text('Pick ${_postType == 'image' ? 'Image' : 'Video'}'),
              ),
            SizedBox(height: 20),
            if (_postType == 'image' && _selectedMedia != null)
              Image.file(_selectedMedia!),  // Display selected image (mobile)
            if (_postType == 'video' && _selectedMedia != null)
              Text('Video selected: ${_selectedMedia!.path}'),
            if (kIsWeb && _webMedia != null)
              _postType == 'image'
                  ? Image.memory(_webMedia!)  // Display web image
                  : Text('Video selected for web'),  // Handle web video selection
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('Submit Post'),
            ),
          ],
        ),
      ),
    );
  }
}
